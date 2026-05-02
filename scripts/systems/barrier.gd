extends StaticBody2D

# Această funcție va fi apelată de buton
func open_barrier() -> void:
	# Cea mai simplă metodă: bariera dispare cu totul din nivel
	queue_free()
