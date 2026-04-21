extends StaticBody2D

var active_buttons: Array[Node] = []

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: Polygon2D = $Polygon2D

func _ready() -> void:
	_apply_state()

func press_button(button: Node) -> void:
	if not active_buttons.has(button):
		active_buttons.append(button)
	_apply_state()

func release_button(button: Node) -> void:
	active_buttons.erase(button)
	_apply_state()

func _apply_state() -> void:
	var is_open := active_buttons.size() > 0
	collision_shape.set_deferred("disabled", is_open)
	visual.visible = not is_open
