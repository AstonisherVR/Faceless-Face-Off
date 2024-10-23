extends CharacterBody2D

#TODO ADD A GODDAM GAMEPLAY LOOP
#TODO FIXME Fix the enemy AI

enum Items {FLASHLIGHT, HAMMER, MIRROR, DOG_WHISTLE}

@export_group("Item References")
@export var item_collisions: Array[CollisionShape2D]
@export var flashlight: Node2D
@export var hammer: Node2D
@export var mirror: Node2D
@export var dog_whistle: Node2D

@export_group("Game Components")
@export var mannequin_enemy: CharacterBody2D
@export var camera: Camera2D
@export var items_animation: AnimationPlayer

@export_group("Audio")
@export var dog_whistle_sfx: AudioStreamPlayer2D

@export_group("Interaction Areas")
@export var flashlight_area: Area2D
@export var hammer_area: Area2D
@export var mirror_area: Area2D

# State variables
var selected_item := Items.FLASHLIGHT

func _ready() -> void:
	set_visible_item(selected_item)
	set_active_collisions()

func _process(delta: float) -> void:
	handle_item_selection()
	handle_item_behavior()

func handle_item_selection() -> void:
	if Input.is_action_just_pressed("Item_One"):
		switch_to_item(Items.FLASHLIGHT)
	elif Input.is_action_just_pressed("Item_Two"):
		switch_to_item(Items.HAMMER)
	elif Input.is_action_just_pressed("Item_Three"):
		switch_to_item(Items.MIRROR)
	elif Input.is_action_just_pressed("Item_Four"):
		switch_to_item(Items.DOG_WHISTLE)

func switch_to_item(new_item: Items) -> void:
	selected_item = new_item
	set_visible_item(selected_item)
	set_active_collisions()
	dog_whistle_sfx.playing = false

func handle_item_behavior() -> void:
	var mouse_pos = get_global_mouse_position()
	var is_mouse_holding = Input.is_action_pressed("R_Click") or Input.is_action_pressed("L_Click")
	var is_mouse_clicking = Input.is_action_just_pressed("R_Click") or Input.is_action_just_pressed("L_Click")
	#mannequin_enemy.no_movement_detected()
	match selected_item:
		Items.FLASHLIGHT:
			flashlight.position = mouse_pos
			flashlight.visible = is_mouse_holding
		Items.HAMMER:
				hammer.position = mouse_pos
				if is_mouse_clicking:
					items_animation.play("Hammer Boink")
		Items.MIRROR:
			mirror.position = mouse_pos
		Items.DOG_WHISTLE:
			dog_whistle.position = mouse_pos
			dog_whistle_sfx.playing = is_mouse_holding
			if is_mouse_clicking and mannequin_enemy.current_mask == mannequin_enemy.Masks.WOLF_MASK:
				mannequin_enemy.should_be_taking_damage_now = true
				mannequin_enemy.stun_enemy()
			else:
				mannequin_enemy.should_be_taking_damage_now = true
#func handle_mouse_stillness(delta: float) -> void:

func _on_flashlight_area_2d_area_entered(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = true
	if mannequin_enemy.current_mask == mannequin_enemy.Masks.HAPPY_MASK:
		mannequin_enemy.stun_enemy()

func _on_flashlight_area_2d_area_exited(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = false

func _on_hammer_area_2d_area_entered(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = true
	if mannequin_enemy.current_mask == mannequin_enemy.Masks.NEUTRAL_MASK:
		mannequin_enemy.stun_enemy()

func _on_hammer_area_2d_area_exited(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = false

func _on_mirror_area_2d_area_entered(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = true
	if mannequin_enemy.current_mask == mannequin_enemy.Masks.SAD_MASK:
		mannequin_enemy.stun_enemy()

func _on_mirror_area_2d_area_exited(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = false

func set_visible_item(item: Items) -> void:
	flashlight.visible = item == Items.FLASHLIGHT
	hammer.visible = item == Items.HAMMER
	mirror.visible = item == Items.MIRROR
	dog_whistle.visible = item == Items.DOG_WHISTLE

func set_active_collisions() -> void:
	for collision_shape in item_collisions:
		collision_shape.disabled = true
	if selected_item < item_collisions.size():
		item_collisions[selected_item].disabled = false
