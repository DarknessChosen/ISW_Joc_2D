extends Node2D

var is_restarting: bool = false

func request_restart() -> void:
	if is_restarting:
		return
	
	is_restarting = true
	print("Restart requested")

	for player in get_tree().get_nodes_in_group("players"):
		if player is CharacterBody2D:
			player.set_physics_process(false)
			player.velocity = Vector2.ZERO

	await get_tree().create_timer(0.01).timeout
	get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		request_restart()
