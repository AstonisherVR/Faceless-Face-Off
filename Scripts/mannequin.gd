extends Node2D

enum Stages {STAGE_0, STAGE_1_1, STAGE_1_2, STAGE_2, STAGE_3, STAGE_KILL} # These are the stages that the enemy has.
var char_levels : Array

# I like to export the variables 
#so that when I press a dot next to the variable "kill_timer." 
#Godot will show me a list of all the things that I can do. 
@export var mannequin_stand_sprite: Sprite2D
@export var mannequin_forawrd_sprite: Sprite2D
@export var movement_timer: Timer
@export var kill_timer: Timer
@export var test_kill_label: Label
@export var marker_points: Array[Marker2D] = []

@export var agression_level := 1	# This is how agressive the enemy is.
var current_stage := Stages.STAGE_0

func set_z_ordering(number):
	z_index = number

func _ready() -> void:
	set_z_ordering(-1)
	#set_sprite(0)
	#position = marker_points[0].position
	#movement_timer.start()

func _process(delta: float) -> void:
	pass

#func _on_movement_timer_timeout() -> void:

	# This function triggers when the timer is done, and handles everything related to the movement
	if (agression_level >= randi()%20+1):
		char_pos[extra_arg_0] +=1
		update_ai_pos(extra_arg_0)


	#if movement_chance > 190:
		#position = marker_points[].position
		#kill_timer.start()
	#else:
		#kill_value = 0
		#kill_timer.stop()
	##if enemy_ai_pos == 4:
		##set_sprite(1)
		##set_z_ordering(1)
	##else:
		##set_sprite(0)
		##set_z_ordering(-1)
	##movement_timer.start()
#
#func _on_kill_timer_timeout() -> void:
	#if kill_value == 100.0:
		#kill_player()
	#else:
		#kill_value += 1
#
#func kill_player():
	#test_kill_label.text = "Dead. GG"
#
#func set_sprite(number):
	#if number == 0:
		#mannequin_stand_sprite.show()
		#mannequin_forawrd_sprite.hide()
	#elif number == 1:
		#mannequin_stand_sprite.hide()
		#mannequin_forawrd_sprite.show()
#
