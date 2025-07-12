extends Node
class_name MouseInput

var relative : Vector2

var lastFrame : float
var lastMouseMove : float

func _process(delta):
	if lastMouseMove < lastFrame:
		relative = Vector2.ZERO
	lastFrame += delta

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		lastMouseMove = lastFrame
		relative = event.relative
