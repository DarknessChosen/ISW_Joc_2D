extends Node2D

@export_file("*.tscn") var next_level_path: String = ""

var is_restarting: bool = false
var is_completing: bool = false

func request_restart() -> void:
	if is_restarting or is_completing:
		return

	is_restarting = true
	print("Restart requested")

	_disable_players()
	call_deferred("_do_restart")

func _do_restart() -> void:
	get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		request_restart()

func check_level_complete() -> void:
	if is_restarting or is_completing:
		return

	var fire_gate := get_node_or_null("FireExit")
	var water_gate := get_node_or_null("WaterExit")

	if fire_gate == null or water_gate == null:
		return

	if fire_gate.has_method("is_gate_completed") and water_gate.has_method("is_gate_completed"):
		if fire_gate.is_gate_completed() and water_gate.is_gate_completed():
			is_completing = true
			print("LEVEL COMPLETE")
			_disable_players()
			call_deferred("_go_to_next_level")

func _go_to_next_level() -> void:
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("No next level set.")

func _disable_players() -> void:
	for player in get_tree().get_nodes_in_group("players"):
		if player is CharacterBody2D:
			player.set_physics_process(false)
			player.velocity = Vector2.ZERO
			
