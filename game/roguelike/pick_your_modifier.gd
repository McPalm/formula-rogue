extends Control

var effects:Array[StringName] = [&"Mines", &"Add Read", &"Barrels"]
var possible_effects:Array[StringName] = [&"Mines", &"Add Read", &"Add Read", &"Barrels", &"Ramps", &"Ice", &"Chat"]

func _ready() -> void:
	$HFlowContainer/Card1.card_picked.connect(pick_card.bind(0))
	$HFlowContainer/Card2.card_picked.connect(pick_card.bind(1))
	$HFlowContainer/Card3.card_picked.connect(pick_card.bind(2))

func set_card(index:int, effect:StringName) -> void:
	effects[index] = effect
	var _card:Card
	match index:
		0:
			_card = $HFlowContainer/Card1
		1:
			_card = $HFlowContainer/Card2
		2:
			_card = $HFlowContainer/Card3
	_card.set_card_label(label_for(effect))

func open() -> void:
	show()
	get_tree().paused = true
	for n in 3:
		set_card(n, possible_effects.pick_random())
	$HFlowContainer/Card2.grab_focus()

func pick_card(index:int) -> void:
	run_effect(effects[index])
	hide()
	$"../Countdown".start_countdown()

func run_effect(effect:StringName) -> void:
	match effect:
		&"Mines":
			$"../../ItemPlacer".place_mine(10)
		&"Add Read":
			possible_effects.erase(&"Add Read")
			await get_tree().create_timer(5.0).timeout
			$"../../AddRead"._read_add()
		&"Barrels":
			$"../../ItemPlacer".place_barrel(15)
		&"Ramps":
			$"../../ItemPlacer".place_ramp(7)
		&"Ice":
			$"../..".set_ice_physics(true)
		&"Chat":
			$"../TwitchChat"._open_chat()
			possible_effects.erase(&"Chat")

func label_for(effect:StringName) -> String:
	match effect:
		&"Mines":
			return "Mines x10"
		&"Add Read":
			return "Word from our Sponsors"
		&"Barrels":
			return "Barrels x 15"
		&"Ramps":
			return "Ramps x 7"
		&"Ice":
			return "Rainy Weather"
		&"Chat":
			return "Audience Interaction"
	return "Missingno"
