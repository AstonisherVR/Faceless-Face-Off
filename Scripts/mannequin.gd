extends CharacterBody2D

# I like to export the variables so that GoDot will show me
# a list of all the things that I can do after pressing a dot.
enum Stages {STAGE_0, STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5_KILL} 	# These are the stages of the enemy.
enum Masks {NO_MASK, NEUTRAL_MASK, HAPPY_MASK, SAD_MASK, WOLF_MASK}			# These are the masks that it can wear.
enum States {ATTACKING, STUNNED, RECOVERING}

@export_group("Sprite References")
@export var mannequin_stand_sprite: Sprite2D
@export var mannequin_forward_sprite: Sprite2D

@export_group("Small Masks")
@export var small_neutral_mask: Sprite2D
@export var small_happy_mask: Sprite2D
@export var small_sad_clown_mask: Sprite2D
@export var small_wolf_mask: Sprite2D

@export_group("Big Masks")
@export var big_neutral_mask: Sprite2D
@export var big_happy_mask: Sprite2D
@export var big_sad_clown_mask: Sprite2D
@export var big_wolf_mask: Sprite2D

@export_group("Timers")
@export var movement_timer: Timer	# This makes the enemy move
@export var kill_countdown: Timer	# Countdown until the enemy will kill.
@export var stunned_timer: Timer	# Stunned for a period of time.
@export var recovery_timer: Timer	# This makes the enemy recover after it's been defeated.

@export_group("Gameplay Properties")
@export var collisions: Array[CollisionShape2D]
@export var marker_points: Array[Marker2D]
@export var health_value: int		# This is the value assigned to the main health.
@export var agression_level: int	# This is how agressive the enemy is. Will change durning the night.
@export var attack_frequency: int	# This is the time for how often the enemy has a chance to move. Changing it makes the enemy move more often.
@export var stunned_time: int		# This is how long it takes to be defeated.
@export var recovery_time: int		# This is how long it will take the enemy to start.
@export var chance_to_mask: int		# This is how much the enemy has a chance to put on a mask. 

var main_health: int				# When it raches 0, the mannequin goes back to Stage 0.
var current_stage: Stages = Stages.STAGE_0
var current_mask: Masks = Masks.NO_MASK
var current_state: States = States.ATTACKING
var taking_damage: bool = false

func _ready() -> void:
	initialize_enemy()

func _process(delta: float) -> void:
	if taking_damage:
		apply_damage(1 * delta)

func initialize_enemy() -> void:
	main_health = health_value
	set_z_ordering(-2)
	set_sprite(0)
	movement_timer.wait_time = attack_frequency
	movement_timer.start()

func apply_damage(damage: int) -> void:
	main_health -= damage
	if main_health <= 0:
		reset_enemy()

func update_ai() -> void:
	if agression_level >= randi() % 100 + 1:
		match current_stage:
			Stages.STAGE_0, Stages.STAGE_1, Stages.STAGE_2:
				advance_position(0, -1)
			Stages.STAGE_3:
				advance_position(1, 4)
			Stages.STAGE_4:
				if kill_countdown.is_stopped():
					kill_countdown.start()
			Stages.STAGE_5_KILL:
				kill_player()
		
		if should_change_mask():
			change_mask()

func advance_position(sprite_index: int, z_order: int) -> void:
	if current_state == States.ATTACKING:
		current_stage += 1
		if current_stage < marker_points.size() and marker_points[current_stage]:
			position = marker_points[current_stage].position
			set_sprite(sprite_index)
			set_z_ordering(z_order)

func should_change_mask() -> bool:
	return kill_countdown.is_stopped() and \
		   chance_to_mask >= randi() % 100 + 1 and \
		   current_stage <= Stages.STAGE_4

func change_mask() -> void:
	current_mask = Masks.values().pick_random()
	set_current_mask(current_mask, current_stage)
	set_active_collisions(current_mask, current_stage)

func set_sprite(number: int) -> void:
	mannequin_stand_sprite.visible = (number == 0)
	mannequin_forward_sprite.visible = (number == 1)

func set_z_ordering(number: int) -> void:
	z_index = number

func set_current_mask(mask: Masks, stage: Stages) -> void:
	hide_all_masks()
	if stage < Stages.STAGE_4:
		show_small_mask(mask)
	else:
		show_big_mask(mask)

func hide_all_masks() -> void:
	var all_masks = [
		small_neutral_mask, small_happy_mask, small_sad_clown_mask, small_wolf_mask,
		big_neutral_mask, big_happy_mask, big_sad_clown_mask, big_wolf_mask
	]
	for mask in all_masks:
		mask.hide()

func show_big_mask(mask: Masks) -> void:
	match mask:
		Masks.NEUTRAL_MASK: big_neutral_mask.show()
		Masks.HAPPY_MASK: big_happy_mask.show()
		Masks.SAD_MASK: big_sad_clown_mask.show()
		Masks.WOLF_MASK: big_wolf_mask.show()
		_: pass

func show_small_mask(mask: Masks) -> void:
	match mask:
		Masks.NEUTRAL_MASK: small_neutral_mask.show()
		Masks.HAPPY_MASK: small_happy_mask.show()
		Masks.SAD_MASK: small_sad_clown_mask.show()
		Masks.WOLF_MASK: small_wolf_mask.show()
		_: pass

func set_active_collisions(mask: Masks, stage: Stages) -> void:
	for collision in collisions:
		collision.disabled = true
	
	var collision_index = -1
	match mask:
		Masks.NEUTRAL_MASK: collision_index = 0
		Masks.HAPPY_MASK: collision_index = 1
		Masks.SAD_MASK: collision_index = 2
		_: return
	
	if stage == Stages.STAGE_4:
		collision_index += 3
	
	if collision_index >= 0 and collision_index < collisions.size():
		collisions[collision_index].disabled = false

# Timer Callbacks
func _on_movement_timer_timeout() -> void:
	update_ai()
	movement_timer.start()

func _on_kill_countdown_timeout() -> void:
	current_stage = Stages.STAGE_5_KILL

func _on_stunned_timer_timeout() -> void:
	taking_damage = false
	current_state = States.RECOVERING
	recovery_timer.start(recovery_time)

func _on_recovery_timer_timeout() -> void:
	main_health = health_value
	current_state = States.ATTACKING
	current_stage = Stages.STAGE_0
	movement_timer.start()

# Player Interaction Methods
func hammer_hit() -> void:
	if current_mask in [Masks.NO_MASK, Masks.NEUTRAL_MASK]:
		stun_enemy()

func flashlight_shined() -> void:
	if current_mask == Masks.HAPPY_MASK:
		stun_enemy()

func reflection_shown() -> void:
	if current_mask == Masks.SAD_MASK:
		stun_enemy()

func whistle_used() -> void:
	if current_mask == Masks.WOLF_MASK:
		stun_enemy()

func stun_enemy() -> void:
	taking_damage = true
	current_state = States.STUNNED
	movement_timer.stop()
	stunned_timer.start(stunned_time)

func reset_enemy() -> void:
	current_stage = Stages.STAGE_0
	current_state = States.RECOVERING
	taking_damage = false
	position = marker_points[0].position if marker_points.size() > 0 else Vector2.ZERO
	recovery_timer.start(recovery_time)

func kill_player() -> void:
	print_rich("[color=red][b]Game Over![/b][/color]")
	# Implement actual game over logic here
