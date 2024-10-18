extends Node2D


# I like to export the variables 
# so that when I press a dot next to the variable "movement_timer." 
# GoDot will show me a list of all the things that I can do. 
enum Stages {STAGE_0, STAGE_1_1, STAGE_1_2, STAGE_2, STAGE_3, STAGE_KILL}	 # These are the stages of the enemy.

@export var mannequin_stand_sprite: Sprite2D
@export var mannequin_forawrd_sprite: Sprite2D
@export var movement_timer: Timer
@export var kill_countdown: Timer
@export var marker_points: Array[Marker2D] = []	# Those are the positions of wwhere the enemy can go.
@export var agression_level := 1	# This is how agressive the enemy is. Will change durning the night.
@export var current_stage := Stages.STAGE_0

func _ready() -> void:
	set_z_ordering(-1)
	movement_timer.start()
	set_sprite(0)

func _physics_process(delta: float) -> void:
	print(kill_countdown.time_left)
	
func _on_movement_timer_timeout() -> void: # When the timer is done, the enemy has a chance to move.
	update_ai_pos()
	movement_timer.start()

func _on_kill_countdown_timeout() -> void:
	current_stage = Stages.STAGE_KILL

func update_ai_pos():
	if (agression_level >= randi()%20+1):
		match current_stage:
			Stages.STAGE_0:
				ai_move()
				set_sprite(0)
				set_z_ordering(-1)
			Stages.STAGE_1_1:
				ai_move()
			Stages.STAGE_1_2:
				ai_move()
			Stages.STAGE_2:
				ai_move()
				set_sprite(1)
				set_z_ordering(1)
			Stages.STAGE_3:
				if kill_countdown.time_left == 0:
					kill_countdown.start()
			Stages.STAGE_KILL:
				kill_player()

func ai_move():
	current_stage += 1
	if marker_points[current_stage]:
		position = marker_points[current_stage].position
	print(marker_points[current_stage])

func kill_player():
	pass

func set_sprite(number):
	if number == 0:
		mannequin_stand_sprite.show()
		mannequin_forawrd_sprite.hide()
	elif number == 1:
		mannequin_stand_sprite.hide()
		mannequin_forawrd_sprite.show()

func set_z_ordering(number):
	z_index = number
