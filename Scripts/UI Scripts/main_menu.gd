extends Control

@onready var start_button: Button = $"Start Button"
@onready var exit_button: Button = $"Exit Button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
