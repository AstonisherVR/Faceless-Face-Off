extends Node2D

@onready var house_animated_sprite_2d: AnimatedSprite2D = $HouseAnimatedSprite2D
var door_stage: int

func _ready() -> void:
	house_animated_sprite_2d.frame = door_stage

func change_door():
	door_stage += 1
	house_animated_sprite_2d.frame = door_stage
