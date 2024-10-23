extends Node2D

@export var animated_panel: AnimatedSprite2D
@export var progress_bar: ProgressBar
@export var score_label: Label
@export var reach_label: Label
@export var lever: Sprite2D
@export var lever_point : Marker2D
@onready var timer: Timer = $Timer

var current_rotation_num := 0
var desired_score := 10
var current_score: int

func _ready():
	reset_machine(1)

func _process(delta):
	#print(lever_point.rotation_degrees)
	if visible:
		progress_bar.value = current_score
		score_label.text = "Score: " + str(current_score)
		if Input.is_action_pressed("L_Click"):
			var mouse_pos = get_global_mouse_position()
			lever_point.look_at(mouse_pos)
		check_desired_score()
	else:
		power_down()

func power_down():
	animated_panel.frame = 0

func check_desired_score():
	var current_rotation = int(lever_point.rotation_degrees) / 360
	if current_rotation > current_rotation_num:
		current_rotation_num = current_rotation
		var old_score = current_score
		current_score += 1
		progress_bar.value = current_score
	elif current_score >= desired_score:
		animated_panel.frame = 1
		if timer.is_stopped():
			timer.start()

func _on_timer_timeout() -> void:
	print("timer")
	progress_next_stage()

func progress_next_stage():
	print("progr")
	match Globals.current_gameplay_stage:
		Globals.Gameplay_Stages.STAGE_0:
			reset_machine(5)
			Globals.gameplay_stage_changed.emit()
			Globals.current_gameplay_stage += 1
		Globals.Gameplay_Stages.STAGE_1:
			reset_machine(4)
		Globals.Gameplay_Stages.STAGE_2:
			reset_machine(2)
		Globals.Gameplay_Stages.STAGE_3_FINAL:
			#get_tree().change_scene_to_file("res://Scenes/UI Scenes/main_menu.tscn")
			print("you win")

func reset_machine(incr_amount):
	print("reset")
	current_score = 0
	desired_score *= incr_amount
	progress_bar.max_value = desired_score
	reach_label.text = "Goal: " + str(desired_score)
	score_label.text = "Score: 0"
	animated_panel.frame = 0
