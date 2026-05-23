extends Node2D

@export var speed = 1

signal mine_down(pos: Vector2, radius: float, delta: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var linear_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		linear_velocity += Vector2.LEFT
	
	if Input.is_action_pressed("ui_up"):
		linear_velocity += Vector2.UP
	
	if Input.is_action_pressed("ui_right"):
		linear_velocity += Vector2.RIGHT
	
	if Input.is_action_pressed("ui_down"):
		linear_velocity += Vector2.DOWN
	
	if Input.is_action_just_pressed("ui_left"):
		mine_down.emit($RigidBody2D.global_position + Vector2.LEFT * 32, 32, -0.1)
	
	if Input.is_action_just_pressed("ui_down"):
		mine_down.emit($RigidBody2D.global_position + Vector2.DOWN * 32, 32, -0.1)
	
	if Input.is_action_just_pressed("ui_right"):
		mine_down.emit($RigidBody2D.global_position + Vector2.RIGHT * 32, 32, -0.1)
	
	if Input.is_action_just_pressed("ui_up"):
		mine_down.emit($RigidBody2D.global_position + Vector2.UP * 32, 32, -0.1)
	
	$RigidBody2D.linear_velocity = linear_velocity * speed
