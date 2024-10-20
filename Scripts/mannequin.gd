extends CharacterBody2D

# I like to export the variables 
## so that when I press a dot next to the variable "movement_timer." 
### GoDot will show me a list of all the things that I can do.
enum Stages {STAGE_0, STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5_KILL}	 # These are the stages of the enemy.
enum Masks {NO_MASK, NEUTRAL_MASK, HAPPY_MASK, SAD_MASK, WOLF_MASK}	# These are the masks that it can wear.


@export var mannequin_stand_sprite: Sprite2D
@export var mannequin_forawrd_sprite: Sprite2D

@export var small_neutral_mask: Sprite2D
@export var small_happy_mask: Sprite2D
@export var small_sad_clown_mask: Sprite2D
@export var small_wolf_mask: Sprite2D

@export var big_neutral_mask: Sprite2D
@export var big_happy_mask: Sprite2D
@export var big_sad_clown_mask: Sprite2D
@export var big_wolf_mask: Sprite2D

@export var movement_timer: Timer	# This makes the enemy move. 
@export var kill_countdown: Timer	# Countdown until the enemy will kill.

@export var collisions: Array [CollisionShape2D] # I need to have all the colisions so that I can manually enable/disable them.
@export var marker_points: Array[Marker2D]	# Those are the positions of where the enemy can go.

@export var agression_level: int	# This is how agressive the enemy is. Will change durning the night.
@export var attack_frequency: int	# This is the time for how often the enemy has a chance to move. Changing it makes the enemy move more often.
@export var chance_to_mask: int	 # This is how much the enemy has a chance to put on a mask. 

@export var current_stage := Stages.STAGE_0
@export var current_mask := Masks.NO_MASK

func _ready() -> void:
	set_z_ordering(-2)
	set_sprite(0)
	movement_timer.start()

func _on_movement_timer_timeout() -> void: # When the timer is done, the enemy has a chance to move.
	update_ai()
	movement_timer.wait_time = attack_frequency
	movement_timer.start()

func _on_kill_countdown_timeout() -> void:
	current_stage = Stages.STAGE_5_KILL

func update_ai() -> void:
	if agression_level >= randi()%100+1:
		match current_stage:
			Stages.STAGE_0:
				ai_move()
				set_sprite(0)
				set_z_ordering(-1)
			Stages.STAGE_1:
				ai_move()
				set_sprite(0)
				set_z_ordering(-1)
			Stages.STAGE_2:
				ai_move()
				set_sprite(0)
				set_z_ordering(-1)
			Stages.STAGE_3:
				ai_move()
				set_sprite(1)
				set_z_ordering(4)
			Stages.STAGE_4:
				if kill_countdown.is_stopped(): # This is to make sure the timer gets triggered only once.
					kill_countdown.start()
			Stages.STAGE_5_KILL:
				kill_player()
		if kill_countdown.is_stopped():
			if chance_to_mask >= randi()%100+1 and current_stage <= 4:
				current_mask = Masks.values().pick_random()
				#print("current_stage ", current_stage)
				#print("current_mask ", current_mask)
				match current_mask:
					Masks.NO_MASK:
						set_current_mask(Masks.NO_MASK, current_stage)
					Masks.NEUTRAL_MASK:
						set_current_mask(Masks.NEUTRAL_MASK, current_stage)
					Masks.HAPPY_MASK:
						set_current_mask(Masks.HAPPY_MASK, current_stage)
					Masks.SAD_MASK:
						set_current_mask(Masks.SAD_MASK, current_stage)
					Masks.WOLF_MASK:
						set_current_mask(Masks.WOLF_MASK, current_stage)

func ai_move() -> void:
	current_stage += 1
	if marker_points[current_stage]:
		position = marker_points[current_stage].position

func hammer_hit():
	print("OUCH! THAT HURT!")

func reflection_shown():
	print("AHH! I'M HEDOUS!")

func flashed():
	print("I CAN'T SEE!")

func whistle_used():
	print("MY EARS!")
	player_defended()

func no_movement_detected():
	print("Good kid.") 

func kill_player() -> void:
	print_rich("[color=red][b]Game Over![/b][/color]")
	#get_tree().paused = true

func player_defended() -> void:
	current_stage = Stages.STAGE_0
	movement_timer
	movement_timer.stop()
	movement_timer.wait_time = attack_frequency

func set_sprite(number) -> void:
	if number == 0:
		mannequin_stand_sprite.show()
		mannequin_forawrd_sprite.hide()
	elif number == 1:
		mannequin_stand_sprite.hide()
		mannequin_forawrd_sprite.show()

func set_z_ordering(number) -> void:
	z_index = number

func set_current_mask(current_mask_number: int, current_stage_number: int) -> void:
	if current_mask_number == 0:
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 1 and current_stage_number < 4:
		small_neutral_mask.show()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 1 and current_stage_number >= 4: 
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.show()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 2 and current_stage_number < 4:
		small_neutral_mask.hide()
		small_happy_mask.show()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 2 and current_stage_number >= 4:
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.show()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 3 and current_stage_number < 4:
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.show()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 3 and current_stage_number >= 4:
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.show()
		big_wolf_mask.hide()
	elif current_mask_number == 4 and current_stage_number < 4:
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.show()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.hide()
	elif current_mask_number == 4 and current_stage_number >= 4:
		small_neutral_mask.hide()
		small_happy_mask.hide()
		small_sad_clown_mask.hide()
		small_wolf_mask.hide()
		big_neutral_mask.hide()
		big_happy_mask.hide()
		big_sad_clown_mask.hide()
		big_wolf_mask.show()
	set_active_collisions(current_mask_number)

func set_active_collisions(mask_number) -> void:
	for collision_shape in collisions:
		collision_shape.disabled = true
	if mask_number == 1:
		collisions[0].disabled = false
		collisions[3].disabled = false
		print(collisions[0], collisions[3])
	elif mask_number == 2:
		collisions[1].disabled = false
		collisions[4].disabled = false
		print(collisions[1], collisions[4])
	elif mask_number == 3:
		collisions[2].disabled = false
		collisions[5].disabled = false
		print(collisions[2], collisions[5])
