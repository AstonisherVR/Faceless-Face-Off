extends Node2D

# Variables to manage the timing and state
var is_active = false
var hit_time = 1000.0  # Time window for hitting the space bar in milliseconds
var hit_window_start = 0.0
var hit_window_end = 0.0
var score = 0  # Player's score
@export var progress_bar: ProgressBar  # Reference to the ProgressBar node

# Called when the node enters the scene tree for the first time
func _ready():
	start_generator()

# Function to start the generator
func start_generator():
	is_active = true
	hit_window_start = Time.get_ticks_msec()  # Get current time in milliseconds
	hit_window_end = hit_window_start + hit_time
	$Label.text = "Press Space!"
	progress_bar.value = 0  # Reset progress bar
	progress_bar.max_value = hit_time  # Set max value for progress bar

# Called every frame
func _process(delta):
	if is_active:
		# Update progress bar
		var current_time = Time.get_ticks_msec()
		progress_bar.value = current_time - hit_window_start  # Update progress

		if Input.is_action_just_pressed("ui_accept"):  # "ui_accept" is typically mapped to the space bar
			check_hit()

# Function to check if the hit was successful
func check_hit():
	var current_time = Time.get_ticks_msec()  # Get current time in milliseconds
	if current_time >= hit_window_start and current_time <= hit_window_end:
		$Label.text = "Success!"
		score += 1  # Increase score
		#play_success_sound()  # Play success sound
		is_active = false
		# Restart generator after a short delay
		await get_tree().create_timer(1.0).timeout  # Corrected syntax
		start_generator()
	else:
		$Label.text = "Missed! Try Again."
		#play_failure_sound()  # Play failure sound
		is_active = false
		# Restart generator after a short delay
		await get_tree().create_timer(1.0).timeout  # Corrected syntax
		start_generator()

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
