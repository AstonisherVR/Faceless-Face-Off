extends CharacterBody2D

# I like to export the variables so that GoDot will show me
# a list of all the things that I can do after pressing a dot.
enum Stages {STAGE_0, STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5_KILL} 	# These are the stages of the enemy.
enum Masks {NO_MASK, NEUTRAL_MASK, HAPPY_MASK, SAD_MASK, WOLF_MASK}			# These are the masks that it can wear.
#enum States {ATTACKING}
enum Damage_States {NO_DAMAGE, STILL_PLAYER_DAMAGE, FLASHLIGHT_DAMAGE, HAMMER_DAMAGE, MIRROR_DAMAGE, WHISTLE_DAMAGE}

@export_group("Sprites")
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

@export_group("Gameplay Properties")
@export var health_value: int		# This is the value assigned to the main health.
@export var agression_level: int	# This is how agressive the enemy is. Will change durning the night.
@export var attack_frequency: int	# This is the time for how often the enemy has a chance to move. Changing it makes the enemy move more often.
@export var chance_to_mask: int		# This is how much the enemy has a chance to put on a mask.
@export var collisions: Array[CollisionShape2D]
@export var marker_points: Array[Marker2D]
@export var house: Node2D

@export_group("Sound Effects")
@export var footsteps_sfx: Array[AudioStreamPlayer2D]
@export var stinger: AudioStreamPlayer2D
var increase_base_stats_amount: float
var main_health: float
var should_be_taking_damage_now: bool
var current_stage = Stages.STAGE_0
var current_mask = Masks.NO_MASK
var current_damage_taking_state = Damage_States.NO_DAMAGE

# Main functions
func _ready() -> void:
	Globals.gameplay_stage_changed.connect(_on_gameplay_stage_received)
	stop_yourself()

func _process(delta: float) -> void:
	handle_damage(delta)

# Enemy Initialization
func _on_gameplay_stage_received() -> void:
	increase_base_stats_amount += 1
	initialize_enemy(increase_base_stats_amount)

func initialize_enemy(increase_base: float) -> void:
	agression_level = 30 + (increase_base * randi_range(5, 10))
	attack_frequency = 3 - (int(increase_base) % 2)
	chance_to_mask = 40 * increase_base / 1.1
	health_value = 30 * increase_base
	set_z_ordering(-2)
	set_sprite(0)
	main_health = health_value
	movement_timer.wait_time = attack_frequency
	movement_timer.start()

# AI Handling
func update_ai() -> void:
	if agression_level >= randi() % 100 + 1:
		match current_stage:
			Stages.STAGE_0, Stages.STAGE_1, Stages.STAGE_2:
				advance_position(0, -1)
			Stages.STAGE_3:
				handle_stage_3_interactions()
			Stages.STAGE_4:
				if kill_countdown.is_stopped():
					kill_countdown.start()
			Stages.STAGE_5_KILL:
				kill_player()

		if should_change_mask():
			change_mask()

func handle_stage_3_interactions() -> void:
	if house.door_stage in range(3):
		house.change_door()
		reset_enemy()
	else:
		advance_position(1, 4)

func advance_position(sprite_index: int, z_order: int) -> void:
	current_stage += 1
	play_footsteps()
	if marker_points.has(current_stage):
		position = marker_points[current_stage].position
		set_sprite(sprite_index)
		set_z_ordering(z_order)

# Damage Handling
func handle_damage(delta: float) -> void:
	match current_damage_taking_state:
		Damage_States.NO_DAMAGE:
			main_health = health_value
		Damage_States.STILL_PLAYER_DAMAGE:
			pass
		Damage_States.FLASHLIGHT_DAMAGE:
			main_health -= delta * 50
		Damage_States.HAMMER_DAMAGE:
			main_health -= 25
		Damage_States.MIRROR_DAMAGE:
			main_health -= delta * 65
		Damage_States.WHISTLE_DAMAGE:
			main_health -= delta * 60

	if main_health <= 0:
		reset_enemy()

func stun_enemy() -> void:
	if should_be_taking_damage_now:
		movement_timer.stop()
		match current_mask:
			Masks.NEUTRAL_MASK:
				current_damage_taking_state = Damage_States.HAMMER_DAMAGE
			Masks.HAPPY_MASK:
				current_damage_taking_state = Damage_States.FLASHLIGHT_DAMAGE
			Masks.SAD_MASK:
				current_damage_taking_state = Damage_States.MIRROR_DAMAGE
			Masks.WOLF_MASK:
				current_damage_taking_state = Damage_States.WHISTLE_DAMAGE
	else:
		movement_timer.start()
		current_damage_taking_state = Damage_States.NO_DAMAGE

# Enemy Reset and Game Over
func reset_enemy() -> void:
	current_damage_taking_state = Damage_States.NO_DAMAGE
	current_stage = Stages.STAGE_0
	current_mask = Masks.NO_MASK
	position = marker_points[0].position
	main_health = health_value
	movement_timer.start()

func kill_player() -> void:
	print_rich("[color=red][b]Game Over![/b][/color]")
	get_tree().change_scene_to_file("res://Scenes/UI Scenes/main_menu.tscn")

# Utility Functions
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
	for mask in [small_neutral_mask, small_happy_mask, small_sad_clown_mask, small_wolf_mask, 
				big_neutral_mask, big_happy_mask, big_sad_clown_mask, big_wolf_mask]:
		mask.hide()

func show_small_mask(mask: Masks) -> void:
	match mask:
		Masks.NEUTRAL_MASK: small_neutral_mask.show()
		Masks.HAPPY_MASK: small_happy_mask.show()
		Masks.SAD_MASK: small_sad_clown_mask.show()
		Masks.WOLF_MASK: small_wolf_mask.show()

func show_big_mask(mask: Masks) -> void:
	match mask:
		Masks.NEUTRAL_MASK: big_neutral_mask.show()
		Masks.HAPPY_MASK: big_happy_mask.show()
		Masks.SAD_MASK: big_sad_clown_mask.show()
		Masks.WOLF_MASK: big_wolf_mask.show()

func set_active_collisions(mask: Masks, stage: Stages) -> void:
	for collision in collisions:
		collision.disabled = true
	var collision_index = get_collision_index(mask, stage)
	if collision_index >= 0 and collision_index < collisions.size():
		collisions[collision_index].disabled = false

func get_collision_index(mask: Masks, stage: Stages) -> int:
	var collision_index: int = -1

	# Set the collision_index based on the mask
	match mask:
		Masks.NEUTRAL_MASK: collision_index = 0
		Masks.HAPPY_MASK: collision_index = 1
		Masks.SAD_MASK: collision_index = 2
		_: return -1  # Return -1 if no match
	# Adjust for stage 4 after the mask match
	if stage == Stages.STAGE_4:
		collision_index += 3
	return collision_index


func should_change_mask() -> bool:
	return kill_countdown.is_stopped() and \
		   chance_to_mask >= randi() % 100 + 1 and \
		   current_stage <= Stages.STAGE_4

func change_mask() -> void:
	current_mask = Masks.values().pick_random()
	set_current_mask(current_mask, current_stage)
	set_active_collisions(current_mask, current_stage)

func play_footsteps() -> void:
	footsteps_sfx.pick_random().play()

func stop_yourself() -> void:
	current_stage = Stages.STAGE_0
	set_z_ordering(-2)
	set_sprite(0)
	if marker_points.has(current_stage):
		position = marker_points[current_stage].global_position
