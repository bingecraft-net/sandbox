extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var ship : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var brush_diameter = 5
	var tl = ship.position / 16 - Vector2.ONE * brush_diameter / 2 + Vector2.ONE / 2
	for index in range(brush_diameter * brush_diameter):
		var coords = tl + Vector2(index % brush_diameter, index / brush_diameter)
		var atlas_coords = 	$TileMapLayer.get_cell_atlas_coords(coords)
		if atlas_coords != Vector2i(-1, -1):
			var amount = ship.cargo.get(atlas_coords)
			if not amount:
				amount = 0
			ship.cargo.set(atlas_coords, amount + 1)
			$TileMapLayer.set_cell(coords)
