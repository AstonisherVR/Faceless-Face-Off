extends Node2D

enum Stages {STAGE_0, STAGE_1_1, STAGE_1_2, STAGE_2, STAGE_3, STAGE_KILL} # These are the stages that the enemy has.
var char_levels : Array

# I like to export the variables 
# so that when I press a dot next to the variable "movement_timer." 
# GoDot will show me a list of all the things that I can do. 
@export var mannequin_stand_sprite: Sprite2D
@export var mannequin_forawrd_sprite: Sprite2D
@export var movement_timer: Timer
@export var test_kill_label: Label
@export var marker_points: Array[Marker2D] = []

@export var agression_level := 1	# This is how agressive the enemy is.
@export var current_stage := Stages.STAGE_0

func _ready() -> void:
	set_z_ordering(-1)
	movement_timer.start()
	set_sprite(0)

func _process(delta: float) -> void:
	pass

func _on_movement_timer_timeout() -> void: # When the timer is done, the enemy has a chance to move.
	update_ai_pos()
	movement_timer.start()

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
			Stages.STAGE_3:
				set_sprite(1)
				set_z_ordering(1)
			Stages.STAGE_KILL:
				kill_player()

func ai_move():
	current_stage += 1
	if marker_points[current_stage]:
		position = marker_points[current_stage].position
	print(marker_points[current_stage])

func kill_player():
	test_kill_label.text = "Dead. GG"

func set_sprite(number):
	if number == 0:
		mannequin_stand_sprite.show()
		mannequin_forawrd_sprite.hide()
	elif number == 1:
		mannequin_stand_sprite.hide()
		mannequin_forawrd_sprite.show()

func set_z_ordering(number):
	z_index = number

#func _char_timer_timeout(extra_arg_0 : int):
	## This function triggers when one of the character timers is done, and handles
	## everything related to character movement
	#if (char_levels[extra_arg_0] >= randi()%20+1):
		#char_pos[extra_arg_0] +=1
		#update_ai_pos(extra_arg_0)


#func ai_move(from_room : int, to_room : int, character : int, checknextroom : bool = false, newstate : int = 1):
	## (1) This function handles the movement from one room to another or changing the characters
	## state in a room (handled by newstate), while also playing the boot_static animation
	## (2) You can also have the animatronic check the next room it's going to, to see if it's empty
	## if it is, it'll go into the room, otherwise it won't
	#
	#if(checknextroom == true):
		#if(room_updater.room_content_array[to_room]==[0,0,0,0,0,0]):
			#pass
		#else:
			#char_pos[character]-=1
			#return
	#
	#room_updater.room_content_array[from_room][character]=0
	#room_updater.room_content_array[to_room][character]=newstate
	#if cam_elements.curr_cam ==  from_room or cam_elements.curr_cam ==  to_room:
		#cam_elements.tree_state_machine.start("static_boot")
		#cam_elements.animtree.advance(0)	# this fixes a problem where the static plays 1 frame too late
	#room_updater.update_rooms([from_room,to_room])



#func update_ai_pos(animatronic : int):
	## This function updates the characters position based on the 'char_pos' value
	#match animatronic:
		#0:
			#match char_pos[0]:
				#0:
					#ai_move(2,0,0)
				#1:
					#ai_move(0,1,0)
				#2:
					#ai_move(1,2,0)
				#3: 
					#char_pos[0] = 0
					#update_ai_pos(0)
		#1:
			#match char_pos[1]:
				#0:
					#ai_move(3,0,1)
				#1:
					#ai_move(0,1,1)
				#2:
					#ai_move(1,3,1)
				#3:
					#char_pos[1] = 0
					#update_ai_pos(1)
