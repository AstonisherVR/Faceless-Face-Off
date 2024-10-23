extends Node2D

@export var animated_panel: AnimatedSprite2D
@export var progress_bar: ProgressBar
@export var score_label: Label
@export var reach_label: Label
@export var lever: TextureButton

var desired_score := 10
var current_score: int

func _ready():
	reach_label.text = "Goal: " + str(desired_score)
	score_label.text = "Score: 0"
	start_power()

func _process(delta):
	if visible:
		start_power()
		if Input.is_action_pressed("L_Click"):
			var mouse_pos = get_global_mouse_position()
			var lever_pos = lever.get_global_position()
			var angle = atan2(mouse_pos.y - lever_pos.y, mouse_pos.x - lever_pos.x)
			lever.rotation_degrees = rad_to_deg(angle)
	else:
		power_down()

func start_power():
	score_label.text = "Score: " + str(current_score)
	progress_bar.value = 0 
	animated_panel.frame = 0
	progress_bar.max_value = 100

func power_down():
	animated_panel.frame = 0
	progress_bar.value = 0

func check_desired_score():
	if current_score>= desired_score:
		match Globals.current_gameplay_stage:
			Globals.Gameplay_Stages.CALM:
				Globals.current_gameplay_stage = Globals.Gameplay_Stages.BEGGINING
			Globals.Gameplay_Stages.BEGGINING:
				Globals.current_gameplay_stage = Globals.Gameplay_Stages.FINAL
			Globals.Gameplay_Stages.FINAL:
				print("you win")
