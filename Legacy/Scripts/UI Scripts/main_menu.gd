extends Control

@export var info_panel: Panel 

@export var fullscreen_check_box: CheckBox
@export var music_check_box: CheckBox
@export var sfx_check_box: CheckBox

@export var light: Sprite2D
@export var light_buzz_sfx: AudioStreamPlayer2D
@export var light_die_sfx: AudioStreamPlayer2D
@export var wind: AudioStreamPlayer2D

@export var start_button: Button 
@export var exit_button: Button 
@export var prev_button: Button 
@export var next_button: Button
@export var back_to_main_menu_button: Button

@export var example_item_sprites: Array[Sprite2D]
@export var example_mask_sprites: Array[Sprite2D]

@export var main_menu_stuff: Node2D

@export var cont1: VBoxContainer
@export var cont2: VBoxContainer

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("Sfx")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	light_buzz_sfx.pitch_scale = randf_range(1.0, 0.95)
	light_buzz_sfx.play()
	wind.play()
	info_panel.hide()
	music_check_box.button_pressed = true
	sfx_check_box.button_pressed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _on_start_button_pressed() -> void:
	light_die_sfx.playing = true
	info_panel.hide()
	fullscreen_check_box.hide()
	music_check_box.hide()
	sfx_check_box.hide()
	start_button.hide()
	exit_button.hide()
	prev_button.hide()
	next_button.hide()
	back_to_main_menu_button.hide()
	main_menu_stuff.hide()
	cont1.hide()
	cont2.hide()
	light.hide()
	light_buzz_sfx.stop()
	await get_tree().create_timer(3).timeout
	
	get_tree().change_scene_to_file("res://Legacy/Scenes/game.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_music_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(MUSIC_BUS_ID, false)
	else:
		AudioServer.set_bus_mute(MUSIC_BUS_ID, true)

func _on_sfx_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(SFX_BUS_ID, false)
	else:
		AudioServer.set_bus_mute(SFX_BUS_ID, true)

func _on_how_to_play_button_pressed() -> void:
	main_menu_stuff.hide()
	info_panel.show()
	cont2.hide()
	cont1.show()
	for sprites in example_item_sprites:
		sprites.show()
	for sprites in example_mask_sprites:
		sprites.hide()
	prev_button.hide()
	next_button.show()

func _on_back_to_main_menu_button_pressed() -> void:
	main_menu_stuff.show()
	info_panel.hide()

func _on_next_button_pressed() -> void:
	for sprites in example_item_sprites:
		sprites.hide()
	for sprites in example_mask_sprites:
		sprites.show()
	cont1.hide()
	cont2.show()
	prev_button.show()
	next_button.hide()

func _on_prev_button_pressed() -> void:
	for sprites in example_item_sprites:
		sprites.show()
	for sprites in example_mask_sprites:
		sprites.hide()
	cont1.show()
	cont2.hide()
	prev_button.hide()
	next_button.show()

func _on_light_die_audio_stream_player_2d_finished() -> void:
	if light_die_sfx.playing == true:
		light_buzz_sfx.play()

func _on_wind_audio_stream_player_2d_finished() -> void:
	wind.play()
	
