extends Control

@onready var start_button: Button = $"Start Button"
@onready var exit_button: Button = $"Exit Button"
@onready var fullscreen_check_box: CheckBox = $"Fullscreen CheckBox"
@onready var music_check_box: CheckBox = $"Music CheckBox"
@onready var sfx_check_box: CheckBox = $"SFX CheckBox"

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
