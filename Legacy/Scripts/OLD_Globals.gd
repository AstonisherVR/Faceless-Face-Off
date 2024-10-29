extends Node

signal gameplay_stage_changed()

enum Gameplay_Stages {STAGE_0, STAGE_1, STAGE_2, STAGE_3_FINAL}
var current_gameplay_stage := Gameplay_Stages.STAGE_0

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		current_gameplay_stage = Gameplay_Stages.STAGE_0
		get_tree().change_scene_to_file("res://Scenes/UI Scenes/main_menu.tscn")

#$"House/Distortion & Blur".shader_parameter.blur_amount = 0

#current_gameplay_stage = Gameplay_Stages.STAGE_0
#var current_scene = get_tree().current_scene
#if current_scene and current_scene.name != "main_menu.tscn":
	#get_tree().change_scene_to_file("res://Scenes/UI Scenes/main_menu.tscn")

#TODO When the scene is main_menu, make it so that it cant reload
