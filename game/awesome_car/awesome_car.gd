extends CharacterBody3D


@export var max_speed = 100.0
@export var acceleration = 1.0
@export var break_force = 2.0

var current_speed = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity += get_gravity() * delta
	
	var friction = 0.001
	var grip = lerp(0.3, 1.0, (max_speed - current_speed) / max_speed)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("accelerate"):
		var real_acceleration = acceleration * (max_speed - current_speed) / max_speed
		current_speed = move_toward(current_speed, max_speed, real_acceleration)
	elif Input.is_action_pressed("break"):
		var real_break_force = break_force * (max_speed - current_speed) / max_speed
		current_speed = move_toward(current_speed, 0.0, real_break_force)
	else:
		current_speed = move_toward(current_speed, 0, acceleration / 5.0)
		
	current_speed *= 1.0 - friction
	var turning = Input.get_axis("left", "right")
	rotate_y(-turning * delta * current_speed / 10.0 * grip)
	
	var direction := transform.basis * Vector3.FORWARD
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	move_and_slide()
