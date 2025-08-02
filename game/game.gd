extends Node3D
var checkpoints:Array[Vector3]
@onready var car:Node3D = $AwesomeCar
var current_cp:int = 0
var current_lap:int = 0

signal lap_finished(next_lap)

func _ready() -> void:
	generate_checkpoints()
	place_car()

func generate_checkpoints() -> void:
	checkpoints = []
	for cp in $"Stage/stage02_spire/Checkpoint-master".get_children():
		checkpoints.append(cp.global_position)

func place_car() -> void:
	var spawn = (checkpoints[current_cp] + checkpoints[current_cp-1]) / 2 + Vector3.UP
	car.global_position = spawn
	car.get_node("RigidBody3D").global_position = spawn
	car.get_node("RigidBody3D").linear_velocity = Vector3.ZERO
	car.look_at(checkpoints[current_cp], Vector3.UP)

func _process(_delta: float) -> void:
	var distance_to_current_cp = (car.global_position - checkpoints[current_cp]).length_squared()
	var distance_to_next_cp =  (car.global_position - checkpoints[(current_cp+1) % checkpoints.size()]).length_squared()
	if distance_to_next_cp < distance_to_current_cp:
		current_cp = (current_cp + 1) % checkpoints.size()
		if current_cp == 0:
			new_lap()
	if player_is_off_course():
		place_car()
	if Input.is_action_just_pressed("Reset"):
		place_car()

func new_lap() -> void:
	current_lap += 1
	lap_finished.emit(current_lap)

func player_is_off_course() -> bool:
	var tolerance = 60.0 * 60.0
	var distance_to_last_cp = (car.global_position - checkpoints[current_cp]).length_squared()
	return distance_to_last_cp > tolerance
