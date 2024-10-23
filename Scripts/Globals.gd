extends Node

signal gameplay_stage_changed(current_gameplay_stage)

enum Gameplay_Stages {CALM, BEGGINING, FINAL}
var current_gameplay_stage := Gameplay_Stages.CALM

func _input(event: InputEvent):
	#if event.is_action_pressed("ui_cancel") and get_tree().current_scene.name != "main_menu.tscn":
	print_debug(get_tree().current_scene.name)
		#get_tree().change_scene_to_file("res://Scenes/UI Scenes/main_menu.tscn")
