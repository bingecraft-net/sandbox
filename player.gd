extends Node2D

@export var speed = 1

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
	
	if Input.is_action_just_pressed("ui_zoom_in"):
		$RigidBody2D/Camera2D.zoom = $RigidBody2D/Camera2D.zoom * 2
	
	if Input.is_action_just_pressed("ui_zoom_out"):
		$RigidBody2D/Camera2D.zoom = $RigidBody2D/Camera2D.zoom / 2

	$RigidBody2D.linear_velocity = linear_velocity * speed
