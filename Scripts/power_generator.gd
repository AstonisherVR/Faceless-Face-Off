extends Node2D

@export var animated_panel: AnimatedSprite2D
@export var progress_bar: ProgressBar
@export var score_label: Label

@export var is_active := false
@export var reach_label: Label

var desired_score := 10
var current_score: int
var hit_time := 1000.0
var hit_window_start: float
var hit_window_end: float
var time_cooldown := 0.45

func _ready():
	reach_label.text = "Goal: " + str(desired_score)
	start_power()

func start_power():
	animated_panel.frame = 0
	score_label.text = "Score: " + str(current_score)
	is_active = true
	hit_window_start = Time.get_ticks_msec()  # Gets the current time in milliseconds
	hit_window_end = hit_window_start + hit_time
	progress_bar.value = 0  # Reset progress bar
	progress_bar.max_value = hit_time

# Called every frame
func _process(delta):
	#camera.position = Vector2.ZERO
	if visible:
		if is_active:
			var current_time = Time.get_ticks_msec()
			progress_bar.value = current_time - hit_window_start 
			if Input.is_action_just_pressed("ui_accept"):
				check_hit()
			#print(current_time)
			#elif progress_bar.value >= hit_time:
				#check_hit()
	else:
		await visible == true

# This checks if the hit was successful.
func check_hit():
	var current_time = Time.get_ticks_msec()  # Get current time in milliseconds
	if current_time >= hit_window_start and current_time <= hit_window_end:
		animated_panel.frame = 1
		current_score += 1 
		is_active = false
		score_label.text = "Score: " + str(current_score)
		await get_tree().create_timer(time_cooldown).timeout 
		start_power()
	else:
		current_score -= 1
		animated_panel.frame = 2
		is_active = false
		score_label.text = "Score: " + str(current_score)
		await get_tree().create_timer(time_cooldown).timeout 
		start_power()

## Function to play success sound
#func play_success_sound():
	##var success_sound = preload("res://sounds/success.wav")  # Path to your success sound
	#var audio_player = AudioStreamPlayer.new()
	#audio_player.stream = success_sound
	#add_child(audio_player)
	#audio_player.play()
#
## Function to play failure sound
#func play_failure_sound():
	##var failure_sound = preload("res://sounds/failure.wav")  # Path to your failure sound
	#var audio_player = AudioStreamPlayer.new()
	#audio_player.stream = failure_sound
	#add_child(audio_player)
	#audio_player.play()
