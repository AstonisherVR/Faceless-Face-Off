extends Node2D

@export_category("Music")
@export var music_calm: AudioStreamPlayer2D
@export var music_intense: AudioStreamPlayer2D 
@export var house_animated_sprite_2d: AnimatedSprite2D
@export var player_camera: Camera2D

var music_on := true
var door_stage: int

func _ready() -> void:
	house_animated_sprite_2d.frame = door_stage


func _process(delta: float) -> void:
	update_music_status()
	update_camera()

func update_camera() -> void:
	player_camera.position = -get_global_mouse_position()

func change_door() -> void:
	door_stage += 1
	house_animated_sprite_2d.frame = door_stage

func update_music_status() -> void:
	if music_on:
		if !music_calm.playing:
			music_calm.play()
	else:
		music_calm.stop()
