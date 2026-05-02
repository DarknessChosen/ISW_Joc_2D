extends Area2D

func _ready() -> void:
	# Conectăm senzorul de atingere
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Pepenele poate fi cules DOAR de Player1
	if body.name == "Player2":
		print("Player 2 a luat pepenele!")
		queue_free()
