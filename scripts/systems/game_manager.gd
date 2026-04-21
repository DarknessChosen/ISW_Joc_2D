extends Node

const SAVE_PATH := "user://save_data.json"
const MAIN_MENU_PATH := "res://scenes/ui/MainMenu.tscn"

const LEVEL_ORDER: Array[String] = [
	"res://scenes/levels/Level01.tscn",
	"res://scenes/levels/Level02.tscn"
]

var completed_levels: Array[String] = []
var master_volume_percent: float = 100.0

func _ready() -> void:
	load_progress()
	apply_audio_settings()

func save_progress() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	var data := {
		"completed_levels": completed_levels,
		"master_volume_percent": master_volume_percent
	}

	file.store_string(JSON.stringify(data))

func load_progress() -> void:
	completed_levels.clear()
	master_volume_percent = 100.0

	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var text := file.get_as_text()
	var json := JSON.new()

	if json.parse(text) != OK:
		return

	var data = json.data
	if typeof(data) == TYPE_DICTIONARY:
		if data.has("completed_levels"):
			for level in data["completed_levels"]:
				completed_levels.append(str(level))

		if data.has("master_volume_percent"):
			master_volume_percent = float(data["master_volume_percent"])

func apply_audio_settings() -> void:
	if master_volume_percent <= 0.0:
		AudioServer.set_bus_volume_db(0, -80.0)
	else:
		AudioServer.set_bus_volume_db(0, linear_to_db(master_volume_percent / 100.0))

func set_master_volume_percent(value: float) -> void:
	master_volume_percent = clampf(value, 0.0, 100.0)
	apply_audio_settings()
	save_progress()

func mark_level_completed(level_path: String) -> void:
	if not completed_levels.has(level_path):
		completed_levels.append(level_path)
		save_progress()

func is_level_completed(level_path: String) -> bool:
	return completed_levels.has(level_path)

func is_level_unlocked(level_path: String) -> bool:
	var index := LEVEL_ORDER.find(level_path)

	if index == -1:
		return true

	if index == 0:
		return true

	return completed_levels.has(LEVEL_ORDER[index - 1])

func get_first_playable_level() -> String:
	for level_path in LEVEL_ORDER:
		if is_level_unlocked(level_path) and not is_level_completed(level_path):
			return level_path

	if LEVEL_ORDER.size() > 0:
		return LEVEL_ORDER[0]

	return ""

func go_to_level(level_path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(level_path)

func restart_current_level() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func go_to_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)

func quit_game() -> void:
	get_tree().quit()

func reset_progress() -> void:
	completed_levels.clear()
	master_volume_percent = 100.0
	apply_audio_settings()
	save_progress()
