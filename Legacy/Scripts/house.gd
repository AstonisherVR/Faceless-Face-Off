extends Node2D

@export_category("Music")
@export var music_calm: AudioStreamPlayer2D
@export var music_intense: AudioStreamPlayer2D 
@onready var wind_1: AudioStreamPlayer2D = $"Wind 1"
@onready var wind_2: AudioStreamPlayer2D = $"Wind 2"

@export var music_fade_in_duration := 3.0
@export var music_fade_out_duration := 3.0

@export_category("SFX")
@onready var drone: AudioStreamPlayer2D = $Drone
@export var drone_timer: Timer

@export_category("General")
@export var house_animated_sprite_2d: AnimatedSprite2D
@export var player_camera: Camera2D

var music_on := true
var door_stage: int

func _ready() -> void:
	var rng_scary_sfx_wait_time = randi_range(50, 120)
	drone_timer.wait_time = rng_scary_sfx_wait_time
	drone_timer.start()
	house_animated_sprite_2d.frame = door_stage

func _process(_delta: float) -> void:
	update_music_status()
	update_camera()

func update_camera() -> void:
	player_camera.position = -get_global_mouse_position()

func change_door() -> void:
	door_stage += 1
	house_animated_sprite_2d.frame = door_stage

func update_music_status() -> void:
	if music_on:
		if OldGlobals.current_gameplay_stage != 2:
			if !music_calm.playing:
				music_calm.play()
		elif !music_intense.playing:
				music_intense.play()
				music_calm.volume_db -= 1
	else:
		music_calm.stop()

func _on_drone_timer_timeout() -> void:
	print("drone")
	var rng_scary_sfx_wait_time = randi_range(50, 120)
	drone_timer.wait_time = rng_scary_sfx_wait_time
	drone.pitch_scale = randf_range(0.8, 0.975)
	drone.play()
	drone_timer.start()
