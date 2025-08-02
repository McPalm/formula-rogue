extends Control

func _ready() -> void:
	$HFlowContainer/Card1.card_picked.connect(pick_card.bind(0))
	$HFlowContainer/Card2.card_picked.connect(pick_card.bind(1))
	$HFlowContainer/Card3.card_picked.connect(pick_card.bind(2))
	$HFlowContainer/Card1.set_card_label("Landmines x 10")
	$HFlowContainer/Card2.set_card_label("Barrels x 20")
	$HFlowContainer/Card3.set_card_label("Ice Physics 1 Lap")

func open() -> void:
	show()
	get_tree().paused = true
	$HFlowContainer/Card2.grab_focus()

func pick_card(index:int) -> void:
	match index:
		0:
			$"../../ItemPlacer".place_mine(10)
		1:
			$"../../ItemPlacer".place_barrel(20)
		2:
			$"../..".set_ice_physics(true)
	hide()
	$"../Countdown".start_countdown()
