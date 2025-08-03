class_name Bomb extends Node

static var instance:Bomb

signal time_up()
signal time_added(time:float)

var time_left:float = 61.0

func _ready() -> void:
	instance = self
	$"..".lap_finished.connect(add_time.unbind(1).bind(20))

func _process(delta: float) -> void:
	if time_left >= 0.0:
		time_left -= delta
		if time_left < 0.0:
			time_up.emit()

static func add_time(time:float) -> void:
	instance.time_left += time
	instance.time_added.emit(time)
	instance.get_node("AudioStreamPlayer").play()
