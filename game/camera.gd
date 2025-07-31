extends Camera3D

@export var focus:Node3D
@export var car:Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fov = lerpf(60, 90, car.speed / car.top_speed)
	position.x = car.drift / -7.0
	look_at(focus.global_position, car.global_basis.y)
	
