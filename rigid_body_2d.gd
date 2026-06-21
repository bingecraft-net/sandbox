extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var thrust = 4
@export var top_speed = 384
@export var brake = 3
@export var steer = 3

var cargo = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var throttle = Input.get_axis("ui_up", "ui_down")
	if throttle != 0:
		var velocity_correction = throttle * Vector2.UP.rotated($TileMapLayer.rotation) * top_speed - linear_velocity
		if velocity_correction.length() > thrust:
			apply_central_impulse(velocity_correction.normalized() * thrust)
		else:
			apply_central_impulse(velocity_correction)
	elif linear_velocity.length() >= brake:
		apply_central_impulse(-linear_velocity.normalized() * brake)
	else:
		apply_central_impulse(-linear_velocity)
	
	var steer_input = Input.get_axis("ui_left", "ui_right")
	$TileMapLayer.rotation += steer_input * delta * steer
	if $TileMapLayer.rotation > 2 * PI:
		$TileMapLayer.rotation -= 2 * PI
	elif $TileMapLayer.rotation < 0 :
		$TileMapLayer.rotation += 2 * PI
