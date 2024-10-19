extends Node2D

enum Items {FLASHLIGHT, HAMMER, OTHER}
var selected_item := Items.FLASHLIGHT

@export var camera: Camera2D
@export var flashlight: Node2D
@export var hammer: Node2D
@export var items_animation: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position = -get_global_mouse_position()
	handle_items()

func handle_items():
	if Input.is_action_just_pressed("Item_One"):
		selected_item = Items.FLASHLIGHT
	if Input.is_action_just_pressed("Item_Two"):
		selected_item = Items.HAMMER
	if Input.is_action_just_pressed("Item_Three"):
		selected_item = Items.OTHER

	if selected_item == Items.FLASHLIGHT:
		hammer.hide()
		if Input.is_action_pressed("R_Click"): 
			flashlight.show()
			flashlight.position = get_global_mouse_position()
		else:
			flashlight.hide()
	elif selected_item == Items.HAMMER:
		hammer.show()
		hammer.position = get_global_mouse_position()
		if Input.is_action_just_pressed("R_Click"): 
			items_animation.play("Hammer Boink")
			#hammer_sfx.play()
	#elif selected_item == Items.OTHER:
		#hammer.hide()
