extends Node2D

@export var test_kill_label: Label
var can_kill := false
@onready var movement_timer: Timer = $"Movement Timer"
@export var marker_points: Array[Marker2D] = []
@onready var kill_timer: Timer = $"Kill Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_movement_timer_timeout() -> void:
	var enemy_ai_pos = randi_range(1, 3)
	if enemy_ai_pos != 0:
		can_kill = true
	position = marker_points[0].position
	movement_timer.start()
	if can_kill == true:
		kill_timer.start()

func _on_kill_timer_timeout() -> void:
	kill_player()

func kill_player():
	test_kill_label.text = "Dead. GG"
