extends RigidBody2D


@export var magnitude = 1

var max_speed = 0

func _process(delta: float) -> void:
	$RichTextLabel.text = "[font_size=24][color=#FFFFFF]Position: %.2v\nMax speed: %.2f[/color][/font_size]" % [position, max_speed]
	
	var control = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if control != Vector2.ZERO:
		apply_central_force(control.normalized() * magnitude * delta)
	
	max_speed = max(linear_velocity.length(), max_speed)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, Color.RED)
