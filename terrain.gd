extends Node2D

@export
var atlas_coords_by_name = {
	"Empty": Vector2i(0, 0),
	"Fill": Vector2i(1, 0),
	"Atmosphere": Vector2i(0, 1),
}

var chunks = {}
var cell_size = 16
var chunk_size = 16
var render_size = 5


func load_chunks(world_coords: Vector2) -> void:
	var top_left_cell_coords = Vector2i((world_coords / cell_size / chunk_size - Vector2.ONE / 2).snapped(Vector2.ONE))
	for index in range(render_size * render_size):
		var local_cell_coords = Vector2i(index % render_size, index / render_size)
		var chunk_coords = top_left_cell_coords + local_cell_coords - render_size * Vector2i.ONE / 2
		load_chunk(chunk_coords)


func load_chunk(chunk_coords: Vector2i) -> void:
	if chunk_coords not in chunks:
		for index in range(chunk_size * chunk_size):
			var local_cell_coords = Vector2i(index % chunk_size, index / chunk_size)
			var cell_coords = chunk_size * chunk_coords + local_cell_coords
			var atlas_coords = sample(cell_coords)
			$SubTerrain.set_cell(cell_coords, 0, atlas_coords)
		chunks[chunk_coords] = 0
		
		
func sample(cell_coords: Vector2) -> Vector2i:
	var name = "Empty"
	var magnitude = cell_coords.length() + 16 * sin(8 * cell_coords.angle())
	if magnitude < 64:
		name = "Fill"
	elif magnitude < 128:
		name = "Atmosphere"
	return atlas_coords_by_name.get(name)
