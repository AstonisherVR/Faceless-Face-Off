extends Node2D

@export var animated_panel: AnimatedSprite2D
@export var progress_bar: ProgressBar
@export var score_label: Label
@export var reach_label: Label
@export var lever: Sprite2D
@export var lever_point : Marker2D

var current_rotation_num := 0
var desired_score := 100
var current_score: int

func _ready():
	progress_bar.max_value = desired_score
	reach_label.text = "Goal: " + str(desired_score)
	score_label.text = "Score: 0"
	start_power()

func _process(delta):
	#print(lever_point.rotation_degrees)
	if visible:
		start_power()
		if Input.is_action_pressed("L_Click"):
			var mouse_pos = get_global_mouse_position()
			lever_point.look_at(mouse_pos)
		check_desired_score()
	else:
		power_down()

func start_power():
	score_label.text = "Score: " + str(current_score)
	progress_bar.value = 0 
	animated_panel.frame = 0
	progress_bar.max_value = 100

func power_down():
	animated_panel.frame = 0

func check_desired_score():
	var current_rotation = int(lever_point.rotation_degrees) / 360
	if current_rotation > current_rotation_num:
		current_rotation_num = current_rotation
		var old_score = current_score
		current_score += 100
	progress_bar.value = current_score

	if current_score >= desired_score:
		animated_panel.frame = 1
		match Globals.current_gameplay_stage:
			Globals.Gameplay_Stages.CALM:
				Globals.current_gameplay_stage = Globals.Gameplay_Stages.BEGGINING
				Globals.gameplay_stage_changed.emit()
			Globals.Gameplay_Stages.BEGGINING:
				Globals.gameplay_stage_changed.emit()
				Globals.current_gameplay_stage = Globals.Gameplay_Stages.FINAL
			Globals.Gameplay_Stages.FINAL:
				Globals.gameplay_stage_changed.emit()
				print("you win")
