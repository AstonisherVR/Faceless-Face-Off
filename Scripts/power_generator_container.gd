extends Node2D

@export var generator_button: TextureButton
@export var power_generator: Node2D
@export var power_generator_animation_player: AnimationPlayer
@export var power_generator_sprites: Sprite2D
@export var mannequin_enemy: CharacterBody2D
@export var player: CharacterBody2D

var is_power_generator_up: bool = false
var tweener: Tween

##func _process(delta):
	#print((MouseMovementGlobal.relative))
func _ready():
	#print("ready")
	power_generator.visible = false
	power_generator_sprites.visible = false

func _on_generator_texture_button_pressed() -> void:
	#power_generator.visible = true
	#print("click")
	if is_power_generator_up == false:
		power_generator_sprites.visible = true
		power_generator_animation_player.play("Power Generator Lift")
		generator_button.visible = true
		player.handle = false
	else:
		power_generator_animation_player.play_backwards("Power Generator Lift")
		generator_button.disabled = true
		power_generator.visible = false
		power_generator_sprites.visible = true
		player.handle = true

func _on_power_generator_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Power Generator Lift":
		if is_power_generator_up == false:
			is_power_generator_up = true
			power_generator_sprites.visible = false
			power_generator.visible = true
			generator_button.release_focus()
		else:
			is_power_generator_up = false
			power_generator.visible = false
			generator_button.disabled = false
			power_generator_sprites.visible = false
			generator_button.release_focus()
			if mannequin_enemy.current_stage == mannequin_enemy.Stages.STAGE_3:
				mannequin_enemy.stinger.pitch_scale = randf_range(0.9, 1.1)
				mannequin_enemy.stinger.play()

func _on_generator_texture_button_mouse_entered() -> void:
	#print("m entered")
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(generator_button, "modulate:a", 0.5, 0.3)

func _on_generator_texture_button_mouse_exited() -> void:
	#print("m exited")
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(generator_button, "modulate:a", 0.2, 0.3)
