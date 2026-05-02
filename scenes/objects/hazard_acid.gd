extends Area2D

func _ready() -> void:
	# Conectăm automat senzorul care detectează când intră cineva în zonă
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Verificăm dacă cel care a călcat în acid este un jucător 
	# (ignorăm dacă o cutie cade în el, de exemplu)
	if body.is_in_group("players"):
		
		# Aici repornim nivelul instantaneu
		var level = get_tree().current_scene
		if level.has_method("request_restart"):
		# Amânăm cu o fracțiune de secundă apelarea funcției voastre
			level.request_restart.call_deferred()
