extends Area2D

@export_enum("fire", "water") var hazard_type: String = "fire"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	var polygon := $Polygon2D
	if hazard_type == "fire":
		polygon.color = Color(1.0, 0.132, 0.842, 1.0)
	elif hazard_type == "water":
		polygon.color = Color(0.131, 0.519, 0.101, 1.0)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("players"):
		return

	var body_type = body.get("player_type")

	if body_type == null:
		return

	# Dacă intră în hazardul lui, supraviețuiește
	if body_type == hazard_type:
		return

	# Dacă intră în hazardul opus, moare
	var level = get_tree().current_scene
	if level.has_method("request_restart"):
		level.request_restart()
