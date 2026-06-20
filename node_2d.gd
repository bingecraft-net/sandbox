extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var cargo = {}

var lookup = {
	Vector2i(0, 0): "Dense ore",
	Vector2i(1, 0): "Ore",
	Vector2i(2, 0): "Trace ore",
	Vector2i(3, 0): "Medium",
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var brush_diameter = 3
	var mining_tool = $RigidBody2D.position + 16 * Vector2.DOWN.rotated($RigidBody2D/TileMapLayer.rotation)
	var tl = mining_tool / 16 - Vector2.ONE * brush_diameter / 2
	for index in range(brush_diameter * brush_diameter):
		var coords = tl + Vector2(index % brush_diameter, index / brush_diameter)
		var atlas_coords = 	$TileMapLayer.get_cell_atlas_coords(coords)
		if atlas_coords != Vector2i(-1, -1):
			var amount = cargo.get(atlas_coords)
			if not amount:
				amount = 0
			cargo.set(atlas_coords, amount + 1)
			$TileMapLayer.set_cell(coords)
	
	var text_lines = []
	text_lines.append("Speed: %.0f" % $RigidBody2D.linear_velocity.length())
	text_lines.append("Heading: %.0f" % ($RigidBody2D/TileMapLayer.rotation_degrees))
	
	text_lines.append("Inventory:")
	for key in cargo:
		text_lines.append("  %s: %s" % [lookup.get(key) if key in lookup else key, cargo.get(key)])
	
	$RigidBody2D/RichTextLabel.text = "\n".join(text_lines)
