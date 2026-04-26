extends CharacterBody2D

# Acțiunile de input (setate din Inspector pentru fiecare jucător)
@export var move_left_action: StringName = &"p1_left"
@export var move_right_action: StringName = &"p1_right"
@export var jump_action: StringName = &"p1_jump"
@export var down_action: StringName = &"p1_down"

# Variabila care va reține sprite-ul activ (nu folosim @onready aici deoarece îl alegem în _ready)
var sprite: AnimatedSprite2D

# Setări de mișcare și tip de jucător
@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var death_y: float = 1200.0
@export_enum("fire", "water") var player_type: String = "fire"

# Variabile de stare și fizică
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_exited_level: bool = false
var is_in_exit_gate: bool = false
var current_exit_gate: Node = null

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# 1. Ne asigurăm că ambele sprite-uri sunt ascunse la început
	if has_node("SpriteFire"):
		$SpriteFire.visible = false
	if has_node("SpriteWater"):
		$SpriteWater.visible = false
	
	# 2. Alegem sprite-ul corect în funcție de tipul jucătorului setat în Inspector
	if player_type == "fire" and has_node("SpriteFire"):
		sprite = $SpriteFire
	elif player_type == "water" and has_node("SpriteWater"):
		sprite = $SpriteWater
	
	# 3. Facem vizibil doar sprite-ul ales și ne asigurăm că are culorile originale
	if sprite:
		sprite.visible = true
		sprite.modulate = Color(1, 1, 1) # Resetăm la culoarea albă (originală)

func _physics_process(delta: float) -> void:
	# Oprim mișcarea dacă jucătorul a ieșit din nivel sau e în poartă
	if has_exited_level or is_in_exit_gate:
		return

	# Verificăm dacă jucătorul a căzut sub limita de moarte
	if global_position.y > death_y:
		var level = get_tree().current_scene
		if level.has_method("request_restart"):
			level.request_restart()
		return

	# Aplicăm gravitația
	if not is_on_floor():
		velocity.y += gravity * delta
		
		# ANIMAȚIE: Săritură sau Cădere
		if sprite:
			if velocity.y < 0:
				sprite.play("jump")
			else:
				if sprite.sprite_frames and sprite.sprite_frames.has_animation("fall"):
					sprite.play("fall")
				else:
					sprite.play("jump")

	# Logică Săritură
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = jump_velocity

	# Mișcare orizontală
	var direction := Input.get_axis(move_left_action, move_right_action)

	if direction != 0.0:
		velocity.x = direction * speed
		
		# ANIMAȚIE: Alergare și întoarcerea personajului
		if sprite:
			sprite.flip_h = direction < 0
			if is_on_floor():
				sprite.play("run")
	else:
		velocity.x = 0.0
		
		# ANIMAȚIE: Stau pe loc (Idle)
		if sprite and is_on_floor():
			sprite.play("idle")

	move_and_slide()

# Funcții pentru sistemul de Exit Gates (păstrate intacte)
func exit_level() -> void:
	if has_exited_level:
		return

	has_exited_level = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	if sprite:
		sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	
func enter_exit_gate(gate: Node) -> void:
	is_in_exit_gate = true
	current_exit_gate = gate
	velocity = Vector2.ZERO
	if sprite:
		sprite.visible = false

func leave_exit_gate() -> void:
	is_in_exit_gate = false
	current_exit_gate = null
	if sprite:
		sprite.visible = true
