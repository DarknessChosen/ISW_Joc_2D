extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	print("Hazard touched by: ", body.name)

	if body.is_in_group("players"):
		var level = get_tree().current_scene
		if level.has_method("request_restart"):
			level.request_restart()
