extends RigidBody2D


var cargo = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var linear_thrust = 4
@export var linear_speed_max = 384
@export var linear_brake = 3
@export var torque = 4
@export var angular_speed_max = PI

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	var throttle = Input.get_axis("ui_up", "ui_down")
	if throttle != 0:
		var velocity_correction = throttle * Vector2.UP.rotated(rotation) * linear_speed_max - linear_velocity
		if velocity_correction.length() > linear_thrust:
			apply_central_impulse(velocity_correction.normalized() * linear_thrust)
		else:
			apply_central_impulse(velocity_correction)
	elif linear_velocity.length() >= linear_brake:
		apply_central_impulse(-linear_velocity.normalized() * linear_brake)
	else:
		apply_central_impulse(-linear_velocity)
	
	var steer_input = Input.get_axis("ui_left", "ui_right")
	var torque_correction = steer_input * angular_speed_max - angular_velocity
	if torque_correction != 0: 
		var inertia = 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia
		apply_torque(sign(torque_correction) * inertia * torque)
	elif abs(angular_velocity) < 0.01:
		angular_velocity = 0
