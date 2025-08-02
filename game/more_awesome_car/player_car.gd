#Based on https://youtu.be/5m7nBj98rx4
extends VehicleBody3D

@export var MAX_STEER = 0.8
@export var ENGINE_POWER = 600

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D
@export var Camera_Follow_Speed := 20.0

var look_at_camera

var last_checkpoint
signal hit_checkpoint(checkpoint)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at_camera = global_position
	hit_checkpoint.connect(setLastCheckpoint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("Quit")):get_tree().quit()
	if(Input.is_action_just_pressed("Reset")):rotation = Vector3.ZERO #replace with unstuck
	steering = move_toward(steering,Input.get_axis("right","left")* MAX_STEER, delta* 2.5)
	engine_force = Input.get_axis("break","accelerate") * ENGINE_POWER #applied per traction wheel
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position,delta * Camera_Follow_Speed)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform,delta * 5.0)
	look_at_camera = look_at_camera.lerp(global_position + linear_velocity,delta * 5.0)
	camera_3d.look_at(look_at_camera)

func setLastCheckpoint(new_checkpoint):
	last_checkpoint = new_checkpoint
	print("Checkpoint set")
	
func Unstuck():
	global_transform = last_checkpoint.global_transform
	print("Returned to last checkpoint")
