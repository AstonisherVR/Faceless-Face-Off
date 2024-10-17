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


func _on_flashlight_area_2d_area_entered(area: Area2D) -> void:
	print("Flashing Enemy Head")

#
#func _on_flashlight_area_2d_area_exited(area: Area2D) -> void:
	#if !area.is_in_group("Enemy"):
		#print("Not Flashing Enemy Head")
