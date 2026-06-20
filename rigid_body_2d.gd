extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var acceleration = 16
@export var top_speed = 384
@export var brake = 1
@export var steer = 4

var last_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var v = Input.get_axis("ui_up", "ui_down")
	if v != 0:
		var linear_acceleration = v * Vector2.UP.rotated($TileMapLayer.rotation)
		linear_velocity += linear_acceleration.normalized() * acceleration
		linear_velocity += linear_velocity.normalized() * min(0, top_speed - linear_velocity.length())
	elif linear_velocity.length() >= brake:
		linear_velocity -= linear_velocity.normalized() * brake
	else:
		linear_velocity = Vector2.ZERO
	
	var h = Input.get_axis("ui_left", "ui_right")
	$TileMapLayer.rotation += h * delta * steer
	if $TileMapLayer.rotation > 2 * PI:
		$TileMapLayer.rotation -= 2 * PI
	elif $TileMapLayer.rotation < 0 :
		$TileMapLayer.rotation += 2 * PI
