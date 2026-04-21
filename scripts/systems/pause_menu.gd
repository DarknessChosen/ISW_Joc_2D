extends CanvasLayer

@onready var resume_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton
@onready var settings_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SettingsButton
@onready var main_menu_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton

@onready var settings_panel: PanelContainer = $SettingsPanel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

	visible = false
	settings_panel.visible = false
	
	$Dim.color = Color(0, 0, 0, 0.35)
	$Dim.mouse_filter = Control.MOUSE_FILTER_IGNORE

func open() -> void:
	visible = true
	settings_panel.visible = false

func close() -> void:
	visible = false
	settings_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"):
		_on_resume_button_pressed()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	close()

func _on_restart_button_pressed() -> void:
	close()
	GameManager.restart_current_level()

func _on_settings_button_pressed() -> void:
	settings_panel.visible = not settings_panel.visible

func _on_main_menu_button_pressed() -> void:
	close()
	GameManager.go_to_main_menu()
