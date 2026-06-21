extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		set_cell(Vector2i(-1, -2), 0, Vector2i(1, 0))
		set_cell(Vector2i(0, -2), 0, Vector2i(2, 0))
	else:
		set_cell(Vector2i(-1, -2))
		set_cell(Vector2i(0, -2))
