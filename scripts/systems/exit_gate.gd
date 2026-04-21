extends Area2D

@export_enum("fire", "water") var gate_type: String = "fire"

var players_inside: Array[Node] = []

@onready var visual: Polygon2D = $Polygon2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_visual()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("players"):
		return

	if body.get("player_type") != gate_type:
		return

	if not players_inside.has(body):
		players_inside.append(body)

	_notify_level()

func _on_body_exited(body: Node) -> void:
	if players_inside.has(body):
		players_inside.erase(body)

	_notify_level()

func has_correct_player() -> bool:
	return players_inside.size() > 0

func _notify_level() -> void:
	var level = get_tree().current_scene
	if level.has_method("check_level_complete"):
		level.check_level_complete()

func _update_visual() -> void:
	if gate_type == "fire":
		visual.color = Color(1.0, 0.5, 0.3)
	else:
		visual.color = Color(0.3, 0.6, 1.0)
