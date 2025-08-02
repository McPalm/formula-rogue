extends Placeable

func _ready() -> void:
	$Area3D.body_entered.connect(area_body_entered)

func area_body_entered(body:Node3D) -> void:
	if body is RigidBody3D:
		explode(body)

func explode(body:RigidBody3D) -> void:
	$AudioStreamPlayer3D.play()
	$Sprite3D.queue_free()
	var vector_to_body = body.global_position - global_position
	body.apply_force(vector_to_body.normalized() * 700 + Vector3.UP * 500)
	await $AudioStreamPlayer3D.finished
	queue_free()
