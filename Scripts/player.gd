extends CharacterBody2D

#TODO ADD A GODDAM GAMEPLAY LOOP

signal item_used(item_name: String)
signal item_switched(item: Items)

enum Items {FLASHLIGHT, HAMMER, MIRROR, DOG_WHISTLE}

@export_group("Item References")
@export var item_collisions: Array[CollisionShape2D]
@export var flashlight: Node2D
@export var hammer: Node2D
@export var mirror: Node2D
@export var dog_whistle: Node2D

@export_group("Game Components")
@export var mannequin_enemy: Node2D
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
var last_mouse_position := Vector2.ZERO
var mouse_still_time: float

func _ready() -> void:
	set_visible_item(selected_item)
	set_active_collisions()

func _process(delta: float) -> void:
	update_camera()
	handle_item_selection()
	handle_item_behavior()
	handle_mouse_stillness(delta)

func update_camera() -> void:
	camera.position = -get_global_mouse_position()

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
	var is_action = Input.is_action_pressed("R_Click") or Input.is_action_pressed("L_Click")
	match selected_item:
		Items.FLASHLIGHT:
			handle_flashlight(mouse_pos, is_action)
		Items.HAMMER:
			handle_hammer(mouse_pos, is_action)
		Items.MIRROR:
			handle_mirror(mouse_pos)
		Items.DOG_WHISTLE:
			handle_dog_whistle(mouse_pos, is_action)

func handle_flashlight(mouse_pos: Vector2, is_action: bool) -> void:
	flashlight.position = mouse_pos
	flashlight.visible = is_action
	if flashlight_area.overlaps_area(mannequin_enemy) and is_action:
		mannequin_enemy.flashlight_shined()

func handle_hammer(mouse_pos: Vector2, is_action: bool) -> void:
	hammer.position = mouse_pos
	if Input.is_action_just_pressed("R_Click") or Input.is_action_just_pressed("L_Click"):
		items_animation.play("Hammer Boink")
		if hammer_area.overlaps_area(mannequin_enemy):
			mannequin_enemy.hammer_hit()

func handle_mirror(mouse_pos: Vector2) -> void:
	mirror.position = mouse_pos
	if mirror_area.overlaps_area(mannequin_enemy):
		mannequin_enemy.reflection_shown()

func handle_dog_whistle(mouse_pos: Vector2, is_action: bool) -> void:
	dog_whistle.position = mouse_pos
	dog_whistle_sfx.playing = is_action
	
	if is_action and mannequin_enemy.current_mask == mannequin_enemy.Masks.WOLF_MASK:
		mannequin_enemy.apply_damage(2)

func handle_mouse_stillness(delta: float) -> void:
	var current_mouse_pos = get_global_mouse_position()
	if current_mouse_pos == last_mouse_position:
		mouse_still_time += delta
		if mouse_still_time >= 1.0 and mannequin_enemy.current_mask == mannequin_enemy.Masks.NO_MASK:
			mannequin_enemy.apply_damage(1)
	else:
		mouse_still_time = 0.0
	last_mouse_position = current_mouse_pos

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
#
#func interact_with_enemy() -> void:
	#match selected_item:
		#Items.FLASHLIGHT:
			#if flashlight_area.overlaps_area(mannequin_enemy) and Input.is_action_pressed("R_Click"):
				#mannequin_enemy.flashlight_shined()
		#Items.HAMMER:
			#if hammer_area.overlaps_area(mannequin_enemy) and Input.is_action_just_pressed("R_Click"):
				#mannequin_enemy.hammer_hit()
		#Items.MIRROR:
			#if mirror_area.overlaps_area(mannequin_enemy):
				#mannequin_enemy.reflection_shown()
		#Items.DOG_WHISTLE:
			#if mannequin_enemy.current_mask == mannequin_enemy.Masks.WOLF_MASK:
				#mannequin_enemy.apply_damage(2)
#
#func _on_flashlight_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Happy Masks"):
		#mannequin_enemy.flashlight_shined() # Apply damage
		#print(mannequin_enemy.current_state)
#
#func _on_hammer_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Neutral Masks"):
		#mannequin_enemy.hammer_hit() # Apply damage
		#print(mannequin_enemy.current_state)
#
#func _on_mirror_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Sad Masks"):
		#mannequin_enemy.reflection_shown() # Apply damage
		#print(mannequin_enemy.current_state)
