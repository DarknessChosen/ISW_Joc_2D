extends PanelContainer

signal close_requested

@onready var master_slider: HSlider = find_child("MasterSlider", true, false)
@onready var close_button: Button = find_child("CloseButton", true, false)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	if master_slider:
		master_slider.min_value = 0
		master_slider.max_value = 100
		master_slider.step = 1
		master_slider.value = GameManager.master_volume_percent
		master_slider.value_changed.connect(_on_master_slider_value_changed)

	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func _on_master_slider_value_changed(value: float) -> void:
	GameManager.set_master_volume_percent(value)

func _on_close_pressed() -> void:
	visible = false
	close_requested.emit()
