extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text = "[font_size=24][color=#FFFFFF]%.2v[/color][/font_size]" % position
	
	var control = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if control != Vector2.ZERO:
		position += speed * delta * control.normalized()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, Color.RED)
