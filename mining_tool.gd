extends Sprite2D

signal action(pos: Vector2, radius: float, delta: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		pos += Vector2.LEFT
	
	if Input.is_action_pressed("ui_up"):
		pos += Vector2.UP
	
	if Input.is_action_pressed("ui_right"):
		pos += Vector2.RIGHT
	
	if Input.is_action_pressed("ui_down"):
		pos += Vector2.DOWN

	if pos != Vector2.ZERO:
		pos = pos.normalized()
		position = pos * 16
		
	if Input.is_action_just_pressed("ui_accept"):
		action.emit(global_position, 32, -0.1)
