extends Node

static var add:int = 0

signal started()

func _read_add() -> void:
	create_tween().tween_property($"../music", "volume_db", -60, 1.0)
	$"AudioStreamPlayer".stream = get_stream()
	$"AudioStreamPlayer".play()
	started.emit()
	await $"AudioStreamPlayer".finished
	create_tween().tween_property($"../music", "volume_db", 0, 1.0)

func get_stream() -> AudioStream:
	add += 1
	if add % 2 == 0:
		return load("res://RACING GAME SFX/VA/e-melons commercial.wav")
	else:
		return load("res://RACING GAME SFX/VA/problems.wav")
