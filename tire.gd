extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var normal = Vector2.RIGHT.rotated(rotation)
	var counter = sin(linear_velocity.dot(normal)) * 100
	
	apply_central_force(mass * counter * normal.rotated(-PI / 2))

func _draw() -> void:
	draw_arc(-Vector2.RIGHT * 16, 8, PI / 2, 3 * PI / 2, 5, Color.GREEN)
	draw_arc(Vector2.RIGHT * 16, 8, - PI / 2, PI / 2, 5, Color.GREEN)
