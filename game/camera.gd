extends Node3D

@export var focus:Node3D
@export var car:Node3D
@export var camera:Camera3D

func _ready() -> void:
	camera.top_level = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera.fov = lerpf(60, 90, car.speed / car.top_speed)
	position.x = car.drift / -7.0
	look_at(focus.global_position, Vector3.UP) #.global_basis.y)
	camera.global_basis = camera.global_basis.slerp(global_basis, 0.3)
	if not car.disabled:
		camera.global_position = camera.global_position.lerp(global_position, 0.3)
