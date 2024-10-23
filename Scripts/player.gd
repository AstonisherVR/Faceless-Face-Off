extends CharacterBody2D

#TODO FIXME Fix the enemy AI

enum Items {FLASHLIGHT, HAMMER, MIRROR, DOG_WHISTLE}

@export_group("Items")
@export var item_collisions: Array[CollisionShape2D]
@export var items: Array[Node2D]
@export var mannequin_enemy: CharacterBody2D
@export var items_animation: AnimationPlayer

@export_group("Audio")
@export var flashlight_audio: Array[AudioStreamPlayer2D]
@export var dog_whistle_sfx: AudioStreamPlayer2D
@export var hammer_audio: Array[AudioStreamPlayer2D]

@export_group("Interaction Areas")
@export var item_areas: Array[Area2D]

var handle := false
var selected_item := Items.FLASHLIGHT

func _ready() -> void:
	handle = true
	update_item_state()

func _process(delta: float) -> void:
	if handle == true:
		handle_item_selection()
		handle_item_behavior()

func handle_item_selection() -> void:
	for i in range(4):
		if Input.is_action_just_pressed("Item_" + str(i + 1)):
			switch_to_item(i)

func update_item_state() -> void:
	for i in range(items.size()):
		items[i].visible = i == selected_item
	set_active_collisions()

func switch_to_item(new_item: Items) -> void:
	selected_item = new_item
	update_item_state()
	dog_whistle_sfx.playing = false
	mannequin_enemy.should_be_taking_damage_now = false

func handle_item_behavior() -> void:
	var mouse_pos = get_global_mouse_position()
	var is_holding = Input.is_action_pressed("R_Click") or Input.is_action_pressed("L_Click")
	var is_clicking = Input.is_action_just_pressed("R_Click") or Input.is_action_just_pressed("L_Click")
	items[selected_item].position = mouse_pos
	match selected_item:
		Items.FLASHLIGHT:
			items[Items.FLASHLIGHT].visible = is_holding
			if is_clicking:
				flashlight_audio.pick_random().play()
		Items.HAMMER:
			if is_clicking:
				items_animation.play("Hammer Boink")
				if mannequin_enemy.should_be_taking_damage_now:
					hammer_audio.pick_random().play()
		Items.DOG_WHISTLE:
			dog_whistle_sfx.playing = is_holding
			if dog_whistle_sfx.playing:
				mannequin_enemy.should_be_taking_damage_now = true
			else:
				mannequin_enemy.should_be_taking_damage_now = false  # Changed from true to false

func _on_flashlight_area_2d_area_entered(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = true

func _on_flashlight_area_2d_area_exited(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = false

func _on_hammer_area_2d_area_entered(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = true

func _on_hammer_area_2d_area_exited(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = false

func _on_mirror_area_2d_area_entered(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = true

func _on_mirror_area_2d_area_exited(area: Area2D) -> void:
	mannequin_enemy.should_be_taking_damage_now = false

func set_active_collisions() -> void:
	for collision_shape in item_collisions:
		collision_shape.disabled = true
	if selected_item < item_collisions.size():
		item_collisions[selected_item].disabled = false
