extends Area2D

@export var linked_barrier: StaticBody2D
var is_pressed: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not is_pressed and body.is_in_group("players"):
		is_pressed = true
		
		# Aici e modificarea: coborâm ColorRect-ul în loc de Sprite2D
		$ColorRect.position.y += 3 
		
		if linked_barrier != null:
			linked_barrier.open_barrier()
