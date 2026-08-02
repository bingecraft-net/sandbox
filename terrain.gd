extends Node2D

var atlas_coords_by_name = {
	"Empty": Vector2i(0, 0),
	"Fill": Vector2i(1, 0),
}

var chunks = {}
var cell_size = 16
var chunk_size = 16
var render_size = 5


func world_to_chunk_coords(world_coords: Vector2) -> Vector2i:
	return (world_coords / cell_size / chunk_size - Vector2.ONE / 2).snapped(Vector2.ONE)


func load_chunks(world_coords: Vector2) -> void:
	var top_left_chunk_coords = world_to_chunk_coords(world_coords) - render_size * Vector2i.ONE / 2
	for index in range(render_size * render_size):
		load_chunk(top_left_chunk_coords + Vector2i(index % render_size, index / render_size))


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
	var magnitude = cell_coords.length()
	if magnitude < 128:
		name = "Fill"
	return atlas_coords_by_name.get(name)
	
