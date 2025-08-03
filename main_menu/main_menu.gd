extends Node3D

func _ready() -> void:
	$RallyCarDriveThrough.play("RallyCarDriveThrough")
	await $CanvasLayer/HammyIntro.completed
	$CanvasLayer/Control.show()
	$CanvasLayer/Control/VBoxContainer/Button.grab_focus()

func play_the_game() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")
