extends Area2D

@export var door_path: NodePath

var pressed_bodies: int = 0
var door_node: Node = null

@onready var visual: Polygon2D = $Polygon2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if door_path != NodePath():
		door_node = get_node_or_null(door_path)

	_update_button_visual()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("players"):
		return

	pressed_bodies += 1
	_update_button_visual()

	# Apăsarea reală a butonului se trimite doar când trece de la 0 la 1
	if pressed_bodies == 1:
		if door_node and door_node.has_method("press_button"):
			door_node.press_button(self)

func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("players"):
		return

	pressed_bodies = max(pressed_bodies - 1, 0)
	_update_button_visual()

	# Eliberarea reală a butonului se trimite doar când trece de la 1 la 0
	if pressed_bodies == 0:
		if door_node and door_node.has_method("release_button"):
			door_node.release_button(self)

func _update_button_visual() -> void:
	if pressed_bodies > 0:
		visual.color = Color(0.984, 0.902, 0.2, 1.0)
		# AM ADĂUGAT AICI: Mută desenul în jos cu 4 pixeli pentru iluzia de apăsare
		visual.position.y = 4 
	else:
		visual.color = Color(1.0, 0.0, 0.118, 1.0)
		# AM ADĂUGAT AICI: Ridică desenul înapoi la poziția zero când jucătorul pleacă
		visual.position.y = 0
