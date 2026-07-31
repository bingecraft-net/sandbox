extends RigidBody2D


@export var magnitude = 1

func _process(delta: float) -> void:
	$RichTextLabel.text = "[font_size=24][color=#FFFFFF]%.2v[/color][/font_size]" % position
	
	var control = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if control != Vector2.ZERO:
		apply_central_force(control.normalized() * magnitude * delta)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, Color.RED)
