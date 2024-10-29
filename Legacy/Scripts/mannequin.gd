#
extends CharacterBody2D

# I like to export the variables so that GoDot will show me
# a list of all the things that I can do after pressing a dot.
enum Stages {STAGE_0, STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5_KILL} 	# These are the stages of the enemy.
enum Masks {NO_MASK, NEUTRAL_MASK, HAPPY_MASK, SAD_MASK, WOLF_MASK}			# These are the masks that it can wear.
enum Damage_States {NO_DAMAGE, GENERATOR_UP_DAMAGE, FLASHLIGHT_DAMAGE, HAMMER_DAMAGE, MIRROR_DAMAGE, WHISTLE_DAMAGE}

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

var increase_base_stats_amount : = 3000
var main_health: float
var should_be_taking_damage_now : bool
var current_stage: = Stages.STAGE_0
var current_mask: = Masks.NO_MASK
var current_damage_taking_state := Damage_States.NO_DAMAGE

var hammer_is_hitting := false

func _ready() -> void:
	OldGlobals.gameplay_stage_changed.connect(_on_gameplay_stage_received)
	stop_yourself()

func _on_gameplay_stage_received():
	increase_base_stats_amount += 1
	initialize_enemy(increase_base_stats_amount)

func _process(delta: float) -> void:
	handle_damage(delta)

func initialize_enemy(increase_base: float) -> void:
	agression_level = 30 + (increase_base * randi_range(5, 10))
	attack_frequency = 3 - (int(increase_base) % 2)
	chance_to_mask = 40 * increase_base/1.1
	health_value = 30.0 * increase_base
	set_z_ordering(-2)
	set_sprite(0)
	main_health = health_value
	movement_timer.wait_time = attack_frequency
	movement_timer.start()

func update_ai() -> void:
	if agression_level >= randi() % 100 + 1:
		match current_stage:
			Stages.STAGE_0, Stages.STAGE_1, Stages.STAGE_2:
				advance_position(0, -1)
			Stages.STAGE_3:
				if house.door_stage in range(3):
					house.change_door()
					reset_enemy()
				else:
					advance_position(1, 4)
			Stages.STAGE_4:
				if kill_countdown.is_stopped():
					kill_countdown.start()
			Stages.STAGE_5_KILL:
				kill_player()

		if should_change_mask():
			change_mask()

func advance_position(sprite_index: int, z_order: int) -> void:
	current_stage += 1
	play_footsteps()
	if marker_points[current_stage]:
		position = marker_points[current_stage].position
		set_sprite(sprite_index)
		set_z_ordering(z_order)

func _on_movement_timer_timeout() -> void:
	update_ai()
	movement_timer.start()

func _on_kill_countdown_timeout() -> void:
	current_stage = Stages.STAGE_5_KILL

func handle_damage(delta: float) -> void:
	#print(should_be_taking_damage_now)
	if should_be_taking_damage_now:
		check_mask_for_damage()
		match current_damage_taking_state:
			Damage_States.GENERATOR_UP_DAMAGE:
				#print("GENERATOR_UP_DAMAGE")
				main_health -= delta * 80
			Damage_States.FLASHLIGHT_DAMAGE:
				#print("FLASHLIGHT_DAMAGE")
				main_health -= delta * 90
			Damage_States.HAMMER_DAMAGE:
				#print("HAMMER_DAMAGE")
				main_health -= 25
			Damage_States.MIRROR_DAMAGE:
				#print("MIRROR_DAMAGE")
				main_health -= delta * 100
			Damage_States.WHISTLE_DAMAGE:
				#print("WHISTLE_DAMAGE")
				main_health -= delta * 75
	else:
		current_damage_taking_state = Damage_States.NO_DAMAGE
		#print("NO_DAMAGE")
	#print(Globals.current_gameplay_stage)

func check_mask_for_damage():
	if main_health <= 0:
		reset_enemy()
	if current_stage != Stages.STAGE_0:
		match current_mask:
			Masks.NO_MASK:
				current_damage_taking_state = Damage_States.GENERATOR_UP_DAMAGE 
			Masks.NEUTRAL_MASK:
				current_damage_taking_state = Damage_States.HAMMER_DAMAGE
			Masks.HAPPY_MASK:
				current_damage_taking_state = Damage_States.FLASHLIGHT_DAMAGE
			Masks.SAD_MASK:
				current_damage_taking_state = Damage_States.MIRROR_DAMAGE
			Masks.WOLF_MASK:
				current_damage_taking_state = Damage_States.WHISTLE_DAMAGE

func reset_enemy() -> void:
	should_be_taking_damage_now = false
	current_damage_taking_state = Damage_States.NO_DAMAGE
	current_stage = Stages.STAGE_0
	current_mask = Masks.NO_MASK
	position = marker_points[0].position
	main_health = health_value
	movement_timer.start()

func kill_player() -> void:
	print_rich("[color=red][b]Game Over![/b][/color]")
	get_tree().change_scene_to_file("res://Legacy/Scenes/UI Scenes/main_menu.tscn")

func set_sprite(number: int) -> void:
	mannequin_stand_sprite.visible = (number == 0)
	mannequin_forward_sprite.visible = (number == 1)

func set_z_ordering(number: int) -> void:
	z_index = number

func set_current_mask(mask: Masks, stage: Stages) -> void:
	for masks in [small_neutral_mask, small_happy_mask, small_sad_clown_mask, small_wolf_mask, 
				big_neutral_mask, big_happy_mask, big_sad_clown_mask, big_wolf_mask]:
		masks.hide()
	if stage < Stages.STAGE_4:
		match mask:
			Masks.NEUTRAL_MASK: small_neutral_mask.show()
			Masks.HAPPY_MASK: small_happy_mask.show()
			Masks.SAD_MASK: small_sad_clown_mask.show()
			Masks.WOLF_MASK: small_wolf_mask.show()
			_: pass
	else:
		match mask:
			Masks.NEUTRAL_MASK: big_neutral_mask.show()
			Masks.HAPPY_MASK: big_happy_mask.show()
			Masks.SAD_MASK: big_sad_clown_mask.show()
			Masks.WOLF_MASK: big_wolf_mask.show()
			_: pass

func should_change_mask() -> bool:
	return kill_countdown.is_stopped() and \
		chance_to_mask >= randi() % 100 + 1 and \
		current_stage <= Stages.STAGE_4

func change_mask() -> void:
	current_mask = Masks.values().pick_random()
	set_current_mask(current_mask, current_stage)
	set_active_collisions(current_mask, current_stage)

func play_footsteps() -> void:
	var new_footsep_sfx = footsteps_sfx.pick_random()
	new_footsep_sfx.play()

func stop_yourself() -> void:
	current_stage = Stages.STAGE_0
	set_z_ordering(-2)
	set_sprite(0)
	if marker_points[current_stage]:
		position = marker_points[current_stage].global_position

func set_active_collisions(mask: Masks, stage: Stages) -> void:
	for collision in collisions:
		collision.disabled = true
	var collision_index = get_collision_index(mask, stage)
	if collision_index >= 0 and collision_index < collisions.size():
		collisions[collision_index].disabled = false
	match mask:
		Masks.NEUTRAL_MASK: collision_index = 0
		Masks.HAPPY_MASK: collision_index = 1
		Masks.SAD_MASK: collision_index = 2
		_: return
	if stage == Stages.STAGE_4:
		collision_index += 3
	if collision_index >= 0 and collision_index < collisions.size():
		collisions[collision_index].disabled = false

func get_collision_index(mask: Masks, stage: Stages) -> int:
	var collision_index: int = -1
	if stage == Stages.STAGE_4:
		collision_index += 3
	match mask:
		Masks.NEUTRAL_MASK: collision_index = 0
		Masks.HAPPY_MASK: collision_index = 1
		Masks.SAD_MASK: collision_index = 2
		Masks.WOLF_MASK: collision_index = 3
	return collision_index
