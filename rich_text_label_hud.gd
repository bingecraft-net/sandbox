extends RichTextLabel

@export var ship : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text_lines = []
	text_lines.append("Ship:")
	text_lines.append("  Speed: %.0f" % ship.linear_velocity.length())
	text_lines.append("  Heading: %.0f" % (ship.get_node("TileMapLayer").rotation_degrees))
	text_lines.append("  Location: %.0v" % (ship.position / 16))
	text_lines.append("  Cargo:")
	for key in ship.cargo:
		text_lines.append("    %s: %s" % [lookup.get(key) if key in lookup else key, ship.cargo.get(key)])
	
	text = "[font_size=24]%s[/font_size]" % "\n".join(text_lines)


var lookup = {
	Vector2i(0, 0): "Ore (Dense)",
	Vector2i(1, 0): "Ore",
	Vector2i(2, 0): "Ore (Trace)",
	Vector2i(3, 0): "Medium",
}
