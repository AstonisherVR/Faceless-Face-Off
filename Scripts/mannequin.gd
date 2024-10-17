extends Node2D

@onready var mannequin_stand_sprite: Sprite2D = $"Mannequin Stand"
@onready var mannequin_forawrd_sprite: Sprite2D = $"Mannequin Forawrd"
@onready var movement_timer: Timer = $"Movement Timer"
@onready var kill_timer: Timer = $"Kill Timer"
@export var marker_points: Array[Marker2D] = []
@export var test_kill_label: Label

var can_kill := false
var kill_value: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_ordering(-1)
	change_sprites(0)
	position = marker_points[0].position
	movement_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(kill_value)

func _on_movement_timer_timeout() -> void:
	var enemy_ai_pos = randi_range(0, 4)
	if enemy_ai_pos != 0:
		kill_timer.start()
	else:
		kill_value = 0
		kill_timer.stop()
	position = marker_points[enemy_ai_pos].position
	if enemy_ai_pos == 4:
		change_sprites(1)
		change_ordering(1)
	else:
		change_sprites(0)
		change_ordering(-1)
	movement_timer.start()

func _on_kill_timer_timeout() -> void:
	if kill_value == 100.0:
		kill_player()
	else:
		kill_value += 1

func kill_player():
	test_kill_label.text = "Dead. GG"
	
func change_sprites(number):
	if number == 0:
		mannequin_stand_sprite.show()
		mannequin_forawrd_sprite.hide()
	elif number == 1:
		mannequin_stand_sprite.hide()
		mannequin_forawrd_sprite.show()

func change_ordering(number):
	z_index = 0
