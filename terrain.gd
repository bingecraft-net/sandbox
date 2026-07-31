extends Node2D

@export
var atlas_coords_by_name = {
	"Empty": Vector2i(0, 0),
	"Fill": Vector2i(1, 0),
	"Atmosphere": Vector2i(2, 0),
	
	"Air": Vector2i(0, 1),
	"Ore": Vector2i(1, 1),
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
			var atlas_coords = sample_subterrain(cell_coords)
			$SubTerrain.set_cell(cell_coords, 0, atlas_coords)
			if atlas_coords == atlas_coords_by_name.get("Fill"):
				atlas_coords = sample_supterrain(cell_coords)
				$SupTerrain.set_cell(cell_coords, 0, atlas_coords)
		chunks[chunk_coords] = 0
		
		
func sample_subterrain(cell_coords: Vector2) -> Vector2i:
	var name = "Empty"
	var magnitude = cell_coords.length()
	if magnitude + 16 * sin(8 * cell_coords.angle()) < 128:
		name = "Fill"
	elif magnitude < 128 + 64:
		name = "Atmosphere"
	return atlas_coords_by_name.get(name)

var ore_noise = FastNoiseLite.new()
var ore_iso = 0.2

func sample_supterrain(cell_coords: Vector2) -> Vector2i:
	var name = "Air"
	if ore_noise.get_noise_2d(cell_coords.x, cell_coords.y) >= ore_iso:
		name = "Ore"
	
	return atlas_coords_by_name.get(name)
	
