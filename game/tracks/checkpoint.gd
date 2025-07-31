extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D.body_entered.connect(_body_entered)
	

func _body_entered(body:PhysicsBody3D) -> void:
	print(body)
