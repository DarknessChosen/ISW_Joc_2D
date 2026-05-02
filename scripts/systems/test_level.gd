extends Node2D

# Aici am pus calea exactă către Nivelul 3 ca setare din fabrică
@export_file("*.tscn") var next_level_path: String = "res://scenes/levels/Level03.tscn"

var is_restarting: bool = false
var is_completing: bool = false

@onready var pause_menu: CanvasLayer = get_node_or_null("PauseMenu")

func _ready() -> void:
	get_tree().paused = false

	if pause_menu != null and pause_menu.has_method("close"):
		pause_menu.close()

	var player1 = get_node_or_null("Player1")
	var player2 = get_node_or_null("Player2")

	if player1 != null and player2 != null:
		player1.add_collision_exception_with(player2)
		player2.add_collision_exception_with(player1)

func request_restart() -> void:
	if is_restarting or is_completing:
		return

	is_restarting = true
	_disable_players()
	call_deferred("_do_restart")

func _do_restart() -> void:
	GameManager.restart_current_level()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
	elif event.is_action_pressed("restart") and not get_tree().paused:
		request_restart()

func _toggle_pause() -> void:
	if is_restarting or is_completing:
		return

	var should_pause := not get_tree().paused
	get_tree().paused = should_pause

	if pause_menu != null:
		if should_pause:
			pause_menu.open()
		else:
			pause_menu.close()

func check_level_complete() -> void:
	if is_restarting or is_completing:
		return

	var fire_gate := get_node_or_null("FireExit")
	var water_gate := get_node_or_null("WaterExit")

	if fire_gate == null or water_gate == null:
		return

	# Verificăm dacă ambii jucători sunt în ușile lor
	if fire_gate.has_method("has_docked_player") and water_gate.has_method("has_docked_player"):
		if fire_gate.has_docked_player() and water_gate.has_docked_player():
			is_completing = true
			GameManager.mark_level_completed(scene_file_path)
			_disable_players()
			call_deferred("_go_to_next_level")

func _go_to_next_level() -> void:
	await get_tree().create_timer(0.35).timeout

	if next_level_path != "":
		GameManager.go_to_level(next_level_path)
	else:
		GameManager.go_to_main_menu()

func _disable_players() -> void:
	for player in get_tree().get_nodes_in_group("players"):
		if player is CharacterBody2D:
			player.set_physics_process(false)
			player.velocity = Vector2.ZERO
