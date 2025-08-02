extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in get_child_count():
		var area:Area3D = get_child(n).get_child(1)
		area.body_entered.connect(touch_point.bind(n))

func touch_point(body:Node3D, p:int) -> void:
	if body is RigidBody3D:
		print(p)
