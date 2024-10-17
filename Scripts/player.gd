extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var flashlight: Node2D = $Flashlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position = -get_global_mouse_position()
	if Input.is_action_pressed("R_Click"): 
		flashlight.show()
		flashlight.position = get_global_mouse_position() 
	else:
		flashlight.hide()
