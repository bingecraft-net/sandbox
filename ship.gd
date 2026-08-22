extends Node2D


@export var thrust = 1
@export var turn = 1

func _ready() -> void:
	for child in get_children():
		if child.name == "Tire":
			print("ship hull found tire")

func _process(delta: float) -> void:
	$Node2D/RichTextLabel.text = "[font_size=24][color=#FFFFFF]%s[/color][/font_size]" % status()
	
	var throttle = Input.get_axis("ui_down", "ui_up")
	var steer  = Input.get_axis("ui_left", "ui_right")
	
	if throttle != 0:
		var normal = Vector2.RIGHT.rotated($Tire.rotation)
		$Tire.apply_central_force(normal * throttle * thrust * delta)
	
	if steer != 0:
		$Tire.apply_torque(steer * turn)
		
func status() -> String:
	return "Position: %.2v\nHeading: %.2f\nSpeed: %.2f" % [$Hull.position, $Hull.rotation_degrees, $Hull.linear_velocity.length()]
