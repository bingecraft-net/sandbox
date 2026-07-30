extends TileMapLayer


var atlas_coords_names = {
	Vector2i(1, 1): "Hydrogen2",
	Vector2i(2, 2): "Helium4",
}
var atlas_coords = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in atlas_coords_names:
		atlas_coords.set(atlas_coords_names.get(key), key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
