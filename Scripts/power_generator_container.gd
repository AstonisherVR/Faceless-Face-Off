extends Node2D

@export var generator_button: TextureButton
@export var power_generator: Node2D
@export var power_generator_animation_player: AnimationPlayer
@export var power_generator_sprites: Sprite2D
@export var mannequin_enemy: CharacterBody2D
@export var player: CharacterBody2D

var is_power_generator_up: bool = false
var tweener: Tween

func _ready():
	power_generator.visible = false
	power_generator_sprites.visible = false

func _on_generator_texture_button_pressed() -> void:
	if is_power_generator_up == false:
		raise_generator()
	else:
		lower_generator()

func raise_generator() -> void:
	power_generator_sprites.visible = true
	power_generator_animation_player.play("Power Generator Lift")
	generator_button.visible = true

	# Disable all player items
	player.handle = false
	for item in player.items:
		item.visible = false
	player.dog_whistle_sfx.playing = false

func lower_generator() -> void:
	power_generator_animation_player.play_backwards("Power Generator Lift")
	generator_button.disabled = true
	power_generator.visible = false
	power_generator_sprites.visible = true
	player.handle = true

func _on_power_generator_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Power Generator Lift":
		if is_power_generator_up == false:
			handle_generator_raised()
		else:
			handle_generator_lowered()

func handle_generator_raised() -> void:
	is_power_generator_up = true
	power_generator_sprites.visible = false
	power_generator.visible = true
	mannequin_enemy.current_damage_taking_state = mannequin_enemy.Damage_States.GENERATOR_UP_DAMAGE
	mannequin_enemy.should_be_taking_damage_now = true
	generator_button.release_focus()

func handle_generator_lowered() -> void:
	is_power_generator_up = false
	power_generator.visible = false
	generator_button.disabled = false
	power_generator_sprites.visible = false
	mannequin_enemy.current_damage_taking_state = mannequin_enemy.Damage_States.NO_DAMAGE
	mannequin_enemy.should_be_taking_damage_now = false
	generator_button.release_focus()

	# Make only the last selected item visible
	player.items[player.selected_item].visible = true

	if mannequin_enemy.current_stage == mannequin_enemy.Stages.STAGE_3:
		mannequin_enemy.stinger.pitch_scale = randf_range(0.9, 1.1)
		mannequin_enemy.stinger.play()

func _on_generator_texture_button_mouse_entered() -> void:
	update_button_opacity(0.5)

func _on_generator_texture_button_mouse_exited() -> void:
	update_button_opacity(0.2)

func update_button_opacity(target_alpha: float) -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(generator_button, "modulate:a", target_alpha, 0.3)
