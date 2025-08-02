class_name Placeable extends Node3D

func place_at(_position:Vector3) -> void:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(_position + Vector3.UP * 20.0, _position + Vector3.DOWN * 20.0)
	var result = space_state.intersect_ray(query)
	if result:
		global_position = result.position
	else:
		global_position = _position
		queue_free()
		
