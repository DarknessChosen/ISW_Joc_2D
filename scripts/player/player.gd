extends CharacterBody2D

@export var move_left_action: StringName = &"p1_left"
@export var move_right_action: StringName = &"p1_right"
@export var jump_action: StringName = &"p1_jump"
@export var down_action: StringName = &"p1_down"
@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 250.0
@export var jump_velocity: float = -450.0
@export var death_y: float = 1200.0
@export_enum("fire", "water") var player_type: String = "fire"

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_exited_level: bool = false
var is_in_exit_gate: bool = false
var current_exit_gate: Node = null

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if player_type == "fire":
		$Sprite2D.modulate = Color(1.0, 0.4, 0.4)
	elif player_type == "water":
		$Sprite2D.modulate = Color(0.4, 0.6, 1.0)

func _physics_process(delta: float) -> void:
	if has_exited_level or is_in_exit_gate:
		return

	if global_position.y > death_y:
		var level = get_tree().current_scene
		if level.has_method("request_restart"):
			level.request_restart()
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis(move_left_action, move_right_action)

	if direction != 0.0:
		velocity.x = direction * speed
		$Sprite2D.flip_h = direction < 0
	else:
		velocity.x = 0.0

	move_and_slide()

func exit_level() -> void:
	if has_exited_level:
		return

	has_exited_level = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	
func enter_exit_gate(gate: Node) -> void:
	is_in_exit_gate = true
	current_exit_gate = gate
	velocity = Vector2.ZERO
	sprite.visible = false

func leave_exit_gate() -> void:
	is_in_exit_gate = false
	current_exit_gate = null
	sprite.visible = true
