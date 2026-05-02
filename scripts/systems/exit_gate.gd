extends Area2D

@export_enum("fire", "water") var gate_type: String = "fire"

var players_inside_area: Array[Node] = []
var docked_player: Node = null

@onready var visual: Polygon2D = $Polygon2D
@onready var prompt_label: Label = $PromptLabel

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_visual()
	_update_prompt()

func _process(_delta: float) -> void:
	var valid_player := _get_valid_player_inside_area()
	if valid_player == null:
		return

	var interact_action := str(valid_player.get("down_action"))

	if Input.is_action_just_pressed(interact_action):
		# Dacă nimeni nu este "docked", playerul intră în poartă
		if docked_player == null:
			docked_player = valid_player

			if valid_player.has_method("enter_exit_gate"):
				valid_player.enter_exit_gate(self)

			_update_visual()
			_update_prompt()
			_notify_level_state_changed()
			return

		# Dacă același player este deja "docked", iese din poartă
		if docked_player == valid_player:
			if valid_player.has_method("leave_exit_gate"):
				valid_player.leave_exit_gate()

			docked_player = null
			_update_visual()
			_update_prompt()
			_notify_level_state_changed()
			return

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("players"):
		return
	if body.get("player_type") != gate_type:
		return

	if not players_inside_area.has(body):
		players_inside_area.append(body)

	_update_prompt()

func _on_body_exited(body: Node) -> void:
	if players_inside_area.has(body):
		players_inside_area.erase(body)

	# Dacă playerul docked a ieșit cumva din area, îl scoatem și din dock state
	if docked_player == body:
		if body.has_method("leave_exit_gate"):
			body.leave_exit_gate()
		docked_player = null
		_notify_level_state_changed()

	_update_visual()
	_update_prompt()

func has_docked_player() -> bool:
	return docked_player != null and is_instance_valid(docked_player)

func _notify_level_state_changed() -> void:
	var level = get_tree().current_scene
	if level != null and level.has_method("check_level_complete"):
		level.check_level_complete()

func _update_visual() -> void:
	if gate_type == "fire":
		if has_docked_player():
			visual.color = Color(1.0, 0.5, 0.3, 0.55)
		else:
			visual.color = Color(0.978, 0.475, 0.783, 0.651)
	else:
		if has_docked_player():
			visual.color = Color(0.3, 0.6, 1.0, 0.55)
		else:
			visual.color = Color(0.327, 0.631, 0.212, 0.576)

func _update_prompt() -> void:
	var valid_player := _get_valid_player_inside_area()

	if has_docked_player():
		if valid_player != null and docked_player == valid_player:
			prompt_label.text = "Press %s to leave gate" % _action_to_text(str(valid_player.get("down_action")))
			prompt_label.visible = true
		else:
			prompt_label.text = "Player ready"
			prompt_label.visible = true
		return

	if valid_player == null:
		prompt_label.visible = false
		return

	prompt_label.text = "Press %s to enter gate" % _action_to_text(str(valid_player.get("down_action")))
	prompt_label.visible = true

func _get_valid_player_inside_area() -> Node:
	for body in players_inside_area:
		if not is_instance_valid(body):
			continue
		if not body.is_in_group("players"):
			continue
		if body.get("player_type") != gate_type:
			continue
		return body
	return null

func _action_to_text(action_name: String) -> String:
	match action_name:
		"p1_down":
			return "S"
		"p2_down":
			return "↓"
		_:
			return action_name
