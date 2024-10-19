extends Node2D

enum Items {FLASHLIGHT, HAMMER, MIRROR, DOG_WHISTLE}
var selected_item := Items.FLASHLIGHT

@export var camera: Camera2D
@export var flashlight: Node2D
@export var hammer: Node2D
@export var mirror: Node2D
@export var dog_whistle: Node2D
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
		selected_item = Items.MIRROR
	if Input.is_action_just_pressed("Item_Four"):
		selected_item = Items.DOG_WHISTLE

	if selected_item == Items.FLASHLIGHT:
		set_visible_item(selected_item)
		if Input.is_action_pressed("R_Click") or Input.is_action_pressed("L_Click"): 
			flashlight.show()
			flashlight.position = get_global_mouse_position()
		else:
			flashlight.hide()
	elif selected_item == Items.HAMMER:
		set_visible_item(selected_item)
		hammer.position = get_global_mouse_position()
		if Input.is_action_just_pressed("R_Click") or Input.is_action_pressed("L_Click"): 
			items_animation.play("Hammer Boink")
			#hammer_sfx.play()
	elif selected_item == Items.MIRROR:
		set_visible_item(selected_item)
		mirror.position = get_global_mouse_position()
	elif selected_item == Items.DOG_WHISTLE:
		set_visible_item(selected_item)
		dog_whistle.position = get_global_mouse_position()

func set_visible_item(number):
	if number == 0:
		flashlight.show()
		hammer.hide()
		mirror.hide()
		dog_whistle.hide()
	elif number == 1:
		flashlight.hide()
		hammer.show()
		mirror.hide()
		dog_whistle.hide()
	elif number == 2:
		flashlight.hide()
		hammer.hide()
		mirror.show()
		dog_whistle.hide()
	elif number == 3:
		flashlight.hide()
		hammer.hide()
		mirror.hide()
		dog_whistle.show()
