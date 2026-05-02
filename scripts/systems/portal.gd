extends Area2D

# Variabila magică care ne lasă să alegem destinația din panoul Inspector
@export var destination_point: Marker2D

func _ready() -> void:
	# Conectăm senzorul de atingere
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Dacă cel care intră în portal este un jucător...
	if body.is_in_group("players"):
		# ...și dacă am setat o destinație din editor...
		if destination_point != null:
			# ...îl teleportăm instantaneu acolo!
			body.global_position = destination_point.global_position
