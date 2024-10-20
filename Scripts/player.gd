extends CharacterBody2D

enum Items {FLASHLIGHT, HAMMER, MIRROR, DOG_WHISTLE}
var selected_item := Items.FLASHLIGHT

@export var mannequin_enemy: Node2D
@export var dog_whistle_sfx: AudioStreamPlayer2D
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
		dog_whistle_sfx.playing = false
		set_visible_item(selected_item)
		if Input.is_action_pressed("R_Click") or Input.is_action_pressed("L_Click"): 
			flashlight.show()
			flashlight.position = get_global_mouse_position()
		else:
			flashlight.hide()
		#interact_with_enemy(mannequin_enemy)

	elif selected_item == Items.HAMMER:
		dog_whistle_sfx.playing = false
		set_visible_item(selected_item)
		hammer.position = get_global_mouse_position()
		if Input.is_action_just_pressed("R_Click") or Input.is_action_just_pressed("L_Click"): 
			items_animation.play("Hammer Boink")
			#hammer_sfx.play()
		#interact_with_enemy(mannequin_enemy)

	elif selected_item == Items.MIRROR:
		dog_whistle_sfx.playing = false
		set_visible_item(selected_item)
		mirror.position = get_global_mouse_position()
		#interact_with_enemy(mannequin_enemy)

	elif selected_item == Items.DOG_WHISTLE:
		set_visible_item(selected_item)
		dog_whistle.position = get_global_mouse_position()
		if Input.is_action_pressed("R_Click") or Input.is_action_pressed("L_Click"): 
			dog_whistle_sfx.playing = true
		else:
			dog_whistle_sfx.playing = false 
		interact_with_enemy(mannequin_enemy)

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

func interact_with_enemy(enemy):
	match enemy.current_mask:
		#enemy.Masks.NO_MASK:
			#enemy.no_movement_detected()
		#enemy.Masks.NEUTRAL_MASK:
			#enemy.hammer_hit()
		#enemy.Masks.HAPPY_MASK:
			#enemy.flashed()
		#enemy.Masks.SAD_MASK:
			#enemy.reflection_shown()
		enemy.Masks.WOLF_MASK:
			if dog_whistle_sfx.playing == true:
				enemy.whistle_used()

func _on_flashlight_area_2d_area_entered(area: Area2D) -> void:
	print(area.is_in_group("Neutral Masks"))
