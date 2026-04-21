extends Area2D

@export_enum("fire", "water") var gate_type: String = "fire"

var players_inside: Array[Node] = []
var gate_completed: bool = false

@onready var visual: Polygon2D = $Polygon2D
@onready var prompt_label: Label = $PromptLabel

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_visual()
	_update_prompt()

func _process(_delta: float) -> void:
	if gate_completed:
		return

	for body in players_inside:
		if not is_instance_valid(body):
			continue

		if not body.is_in_group("players"):
			continue

		if body.get("player_type") != gate_type:
			continue

		var interact_action = body.get("down_action")
		if interact_action != null and Input.is_action_just_pressed(interact_action):
			gate_completed = true

			if body.has_method("exit_level"):
				body.exit_level()

			_update_visual()
			_update_prompt()
			_notify_level()
			return

func _on_body_entered(body: Node) -> void:
	if gate_completed:
		return

	if not body.is_in_group("players"):
		return

	if body.get("player_type") != gate_type:
		return

	if not players_inside.has(body):
		players_inside.append(body)

	_update_prompt()

func _on_body_exited(body: Node) -> void:
	if players_inside.has(body):
		players_inside.erase(body)

	_update_prompt()

func is_gate_completed() -> bool:
	return gate_completed

func _notify_level() -> void:
	var level = get_tree().current_scene
	if level.has_method("check_level_complete"):
		level.check_level_complete()

func _update_visual() -> void:
	if gate_type == "fire":
		visual.color = Color(1.0, 0.5, 0.3, 0.35 if gate_completed else 1.0)
	else:
		visual.color = Color(0.3, 0.6, 1.0, 0.35 if gate_completed else 1.0)

func _update_prompt() -> void:
	if gate_completed:
		prompt_label.visible = false
		return

	var valid_player := _get_valid_player_inside()
	if valid_player == null:
		prompt_label.visible = false
		return

	var interact_action = str(valid_player.get("down_action"))
	prompt_label.text = "Press %s to exit" % _action_to_text(interact_action)
	prompt_label.visible = true

func _get_valid_player_inside() -> Node:
	for body in players_inside:
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
