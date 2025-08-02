extends Control

signal card_picked()

func _ready() -> void:
	focus_entered.connect(gain_focus)
	focus_exited.connect(lose_focus)
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(lose_focus)

func set_card_label(_name:String) -> void:
	$Panel/Label.text = _name

func _unhandled_key_input(event: InputEvent) -> void:	
	if event.is_action("ui_accept") and has_focus():
		card_picked.emit()

func gain_focus() -> void:
	create_tween().tween_property($Panel, "position", Vector2(0, -20), 0.2)

func lose_focus() -> void:
	create_tween().tween_property($Panel, "position", Vector2(0, 0), 0.2)
