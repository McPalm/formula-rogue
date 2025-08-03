## Based on https://www.youtube.com/watch?v=tksVdsr02yQ&ab_channel=Ragdev
extends Node3D

@onready var body:RigidBody3D = $RigidBody3D
@onready var model:Node3D = $MeshInstance3D

@export var top_speed:float = 80
@export var reverse_speed:float = 30.0
@export var acceleration:float = 50.0
@export var turn_speed:float = 1.0
@export var grip = 3.0
@export var downforceMultiplier:float = 0.1

var drift = 0.0
var speed = 0.0
var grounded:bool = false
var turn_input:float = 0.0
var burning_tire:bool = false
var offroad:bool = true

var disabled:bool = false

func _ready() -> void:
	body.top_level = true

func _physics_process(_delta: float) -> void:
	_face_ground_probably(_delta)
	check_offroad()
	global_position = body.global_position
	if grounded:
		var current_acceleration = acceleration * (top_speed - speed) / top_speed
		if speed < 0.0:
			current_acceleration = acceleration * (reverse_speed + speed) / reverse_speed
		if disabled:
			current_acceleration = 0.0
		var input_force = current_acceleration if Input.is_action_pressed("accelerate") else 0.0
		body.apply_central_force(	global_basis * Vector3.FORWARD * input_force)
		if offroad:
			body.linear_velocity *= 0.99
	var relative_velocity = body.linear_velocity * global_basis
	drift = relative_velocity.x
	speed = -relative_velocity.z
	if grounded:
		var current_grip = grip * 3 if abs(drift) < 7.5 else grip
		if Input.is_action_pressed("break"):
			current_grip = grip / 2.0
		body.apply_central_force(global_basis * Vector3.LEFT * drift * current_grip)
		#body.apply_central_force(global_basis * Vector3.FORWARD * abs(drift) * current_grip * 0.1)
	if body.linear_velocity.length_squared() > .5:
		_rotate_car(_delta)
	## downwards force
	body.apply_force(global_basis * Vector3.DOWN * absf(speed) * downforceMultiplier)
	if disabled:
		body.linear_velocity *= 0.99
		if body.linear_velocity.length() < 2.0:
			body.linear_velocity = Vector3.ZERO
	
func _face_ground_probably(_delta:float) -> void:
	var normal = Vector3.ZERO
	var hits = 0
	for ray in [$GroundCheck, $GroundCheck2, $GroundCheck3, $GroundCheck4]:
		if ray.is_colliding():
			hits += 1
			normal += ray.get_collision_normal()
	grounded = hits > 0
	if hits > 0:
		var n = normal / hits
		var target_transform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(target_transform, 0.25)

## https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func check_offroad() -> void:
	if $GroundCheck2.is_colliding():
		var collider = $GroundCheck2.get_collider()
		if collider is CollisionObject3D:
			offroad = collider.get_collision_layer_value(2)
			return
	offroad = false

func _rotate_car(_delta:float) -> void:
	var turn_axis = Input.get_axis("left", "right")
	if disabled:
		turn_axis = 0.0
	if not grounded:
		set_tire_angle(-turn_axis * 0.3)
	if Input.is_action_pressed("break"):
		turn_axis *= 2.0
		turn_axis += drift / 40.0
	elif not turn_axis:
		turn_axis = drift / 10.0
	if grounded:
		turn_input = move_toward(turn_input, turn_axis, _delta * grip)
		set_tire_angle(-turn_input * 0.3)
	## Turn based on input
	var new_basis = global_basis.rotated(global_transform.basis.y, -turn_input)
	var turn_cap = speed / 10.0
	turn_cap = clampf(turn_cap, -1, 1)
	global_basis = global_basis.slerp(new_basis, turn_speed * _delta * turn_cap)
	global_transform = global_transform.orthonormalized()
	## tilt car
	var t = -drift * grip / 200
	t = clampf(t, -1, 1)
	if grounded:
		burning_tire = abs(t) > .5
		model.rotation.z = lerp(model.rotation.z, t, 10 * _delta)
	else:
		burning_tire = false
	$MeshInstance3D/right_front_particle.emitting = burning_tire and t < 0.0
	$MeshInstance3D/right_rear_particle.emitting = burning_tire and t < 0.0
	$MeshInstance3D/left_front_particle.emitting = burning_tire and t > 0.0
	$MeshInstance3D/left_rear_particle.emitting = burning_tire and t > 0.0

func set_tire_angle(_angle:float) -> void:
	model.get_node("rally_car_02/car_body/wheel_front_left").rotation.z = _angle
	model.get_node("rally_car_02/car_body/wheel_front_right").rotation.z = _angle

func SetRain(enable:bool):
	$RainParticles.emitting = enable
