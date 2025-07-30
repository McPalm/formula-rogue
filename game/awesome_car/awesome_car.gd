## Based on https://www.youtube.com/watch?v=tksVdsr02yQ&ab_channel=Ragdev
extends Node3D

@onready var body:RigidBody3D = $RigidBody3D
@onready var model:Node3D = $MeshInstance3D

@export var acceleration:float
@export var turn_speed:float = 5.0
@export var grip = 3.0


var drift = 0.0
var speed = 0.0

func _physics_process(_delta: float) -> void:
	global_position = body.global_position
	var input_force = Input.get_axis("break", "accelerate") * acceleration
	body.apply_central_force(model.global_basis * Vector3.FORWARD * input_force)
	var relative_velocity = body.linear_velocity * global_basis
	drift = relative_velocity.x
	speed = -relative_velocity.z
	body.apply_central_force(model.global_basis * Vector3.LEFT * drift * grip)
	if body.linear_velocity.length_squared() > .5:
		_rotate_car(_delta)

func _rotate_car(_delta:float) -> void:
	var turn_axis = Input.get_axis("left", "right")
	## Turn based on input
	var new_basis = global_basis.rotated(global_transform.basis.y, -turn_axis)
	global_basis = global_basis.slerp(new_basis, turn_speed * _delta)
	global_transform = global_transform.orthonormalized()
	## tilt car
	var t = -drift / 27
	model.rotation.z = lerp(model.rotation.z, t, 10 * _delta)
