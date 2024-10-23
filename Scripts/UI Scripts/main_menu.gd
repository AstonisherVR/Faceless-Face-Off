extends Control

@export var start_button: Button 
@export var exit_button: Button 
@export var fullscreen_check_box: CheckBox
@export var music_check_box: CheckBox
@export var sfx_check_box: CheckBox 

@export var panel: Panel 
@export var main_menu_stuff: Node2D
@onready var cont: VBoxContainer

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("Sfx")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_check_box.button_pressed = true
	sfx_check_box.button_pressed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

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
	panel.show()

func _on_back_to_main_menu_button_pressed() -> void:
	main_menu_stuff.show()
	panel.hide()


func _on_next_button_pressed() -> void:
	cont.hide()
