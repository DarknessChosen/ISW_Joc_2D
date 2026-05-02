extends Control

@onready var menu_box: VBoxContainer = $CenterContainer/VBoxContainer

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton
@onready var level_select_button: Button = $CenterContainer/VBoxContainer/LevelSelectButton
@onready var settings_button: Button = $CenterContainer/VBoxContainer/SettingsButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/ExitButton

@onready var level_select_panel: PanelContainer = $LevelSelectPanel
@onready var level_list: VBoxContainer = $LevelSelectPanel/MarginContainer/VBoxContainer/ScrollContainer/LevelList
@onready var back_button: Button = $LevelSelectPanel/MarginContainer/VBoxContainer/BackButton

@onready var settings_panel: PanelContainer = $SettingsPanel

func _ready() -> void:
	get_tree().paused = false

	start_button.pressed.connect(_on_start_button_pressed)
	level_select_button.pressed.connect(_on_level_select_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	if settings_panel.has_signal("close_requested"):
		settings_panel.close_requested.connect(_show_main)

	# foarte important
	$Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CenterContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CenterContainer/VBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CenterContainer/VBoxContainer/TitleLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$LevelSelectPanel/MarginContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$LevelSelectPanel/MarginContainer/VBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$LevelSelectPanel/MarginContainer/VBoxContainer/LevelSelectTitle.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_show_main()

func _show_main() -> void:
	menu_box.visible = true
	level_select_panel.visible = false
	settings_panel.visible = false

func _show_level_select() -> void:
	menu_box.visible = false
	settings_panel.visible = false
	level_select_panel.visible = true
	level_select_panel.move_to_front()
	_build_level_list()

func _show_settings() -> void:
	menu_box.visible = false
	level_select_panel.visible = false
	settings_panel.visible = true
	settings_panel.move_to_front()

func _build_level_list() -> void:
	for child in level_list.get_children():
		child.queue_free()

	if GameManager.LEVEL_ORDER.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No levels configured."
		level_list.add_child(empty_label)
		return

	for i in range(GameManager.LEVEL_ORDER.size()):
		var level_path: String = GameManager.LEVEL_ORDER[i]
		var button := Button.new()

		var unlocked := GameManager.is_level_unlocked(level_path)
		var completed := GameManager.is_level_completed(level_path)

		var label := "Level %02d" % (i + 1)

		if completed:
			label += "  "
		elif not unlocked:
			label += "  "

		button.text = label
		button.disabled = not unlocked
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_level_button_pressed.bind(level_path))

		level_list.add_child(button)

func _on_start_button_pressed() -> void:
	var target := GameManager.get_first_playable_level()
	if target != "":
		GameManager.go_to_level(target)

func _on_level_select_button_pressed() -> void:
	_show_level_select()

func _on_settings_button_pressed() -> void:
	_show_settings()

func _on_exit_button_pressed() -> void:
	GameManager.quit_game()

func _on_back_button_pressed() -> void:
	_show_main()

func _on_level_button_pressed(level_path: String) -> void:
	GameManager.go_to_level(level_path)
