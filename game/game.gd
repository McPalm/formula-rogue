extends Node3D
var checkpoints:Array[Vector3]
@onready var car:Node3D = $AwesomeCar
var current_cp:int = 0
var current_lap:int = 0

signal lap_finished(next_lap)
signal on_game_over()
signal on_win()
signal on_reset()

func _ready() -> void:
	generate_checkpoints()
	place_car()
	await get_tree().create_timer(0.5).timeout
	place_car()
	$ItemPlacer.place_time_bonus(18)
	get_tree().paused = true
	$Bomb.time_up.connect(game_over)
	await $UI/Countdown.start_countdown()
	$music.play()

func set_ice_physics(_active:bool) -> void:
	$AwesomeCar.grip = 2.0 if _active else 8.0
	$AwesomeCar.turn_speed = 2.0 if _active else 1.0
	$AwesomeCar.SetRain(_active)

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
		on_reset.emit()
		place_car()
	if Input.is_action_just_pressed("Reset"):
		place_car()

func new_lap() -> void:
	set_ice_physics(false)
	current_lap += 1
	$UI/PickYourModifier.open()
	$ItemPlacer.place_time_bonus(18)
	lap_finished.emit(current_lap)
	if current_lap == 10:
		win()

func player_is_off_course() -> bool:
	var tolerance = 60.0 * 60.0
	var distance_to_last_cp = (car.global_position - checkpoints[current_cp]).length_squared()
	return distance_to_last_cp > tolerance


func game_over() -> void:
	$AwesomeCar.disabled = true
	on_game_over.emit()

func win() -> void:
	on_win.emit()
	$AwesomeCar.disabled = true
	$Bomb.queue_free()
