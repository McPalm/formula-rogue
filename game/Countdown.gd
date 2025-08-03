extends Control

func start_countdown() -> void:
	show()
	$ReadySetGo.play()
	$Timer.start()
	$Label.text = "3"
	await $Timer.timeout
	$Label.text = "2"
	await $Timer.timeout
	$Label.text = "1"
	await $Timer.timeout
	get_tree().paused = false
	$Label.text = "GO!"
	await $Timer.timeout
	hide()
	$Timer.stop()
