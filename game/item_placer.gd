extends Node3D

@onready var game = $".."

func place_mine(qty:int) -> void:
	for n in qty:
		place_entity(load("res://game/placeables/landmine.tscn").instantiate())

func place_ramp(qty:int) -> void:
	for n in qty:
		place_entity(load("res://game/placeables/ramp.tscn").instantiate())

func place_barrel(qty:int) -> void:
	for n in qty:
		place_entity(load("res://game/placeables/barrel.tscn").instantiate())

func place_time_bonus(qty:int) -> void:
	for n in qty:
		place_entity(load("res://game/placeables/time_bonus.tscn").instantiate())

func place_entity(entity:Placeable) -> void:
	add_child(entity)
	var place_info = random_postion_along_track()
	entity.look_at_from_position(Vector3.ZERO, place_info.facing)
	entity.place_at(place_info.position)


func random_postion_along_track() -> Dictionary:
	var rng = randi_range(10, game.checkpoints.size() - 2)
	var touple = {}
	var offset = Vector3(randf_range(-20, 20), 0., randf_range(-20, 20))
	touple.position = game.checkpoints[rng] + offset
	touple.facing = game.checkpoints[rng+1] - game.checkpoints[rng]
	return touple
