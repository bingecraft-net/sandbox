extends Node2D

@export var gravity_constant: float = 0.01
@export var grid_size: int = 64
@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var grid: Array[Array] = []
var crs: CoordinateReferenceSystem = CoordinateReferenceSystem.new()


func _ready() -> void:
	crs.grid_size = grid_size
	for x in range(grid_size):
		grid.append([])
		for y in range(grid_size):
			var energy_density = noise.get_noise_2d(x, y) + 1
			var value = Cell.new(energy_density, 0.)
			grid[x].append(value)

			var coords = crs.forward(x, y)
			var atlas_coords = classify(value)
			tile_map_layer.set_cell(coords, 0, atlas_coords)


func _process(delta: float) -> void:
	var next_grid: Array[Array] = []
	for x in range(grid_size):
		next_grid.append([])
		for y in range(grid_size):
			var current_value: Cell = grid[x][y]
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor_x = (x + dx + grid_size) % grid_size
					var neighbor_y = (y + dy + grid_size) % grid_size
					var neighbor_value = grid[neighbor_x][neighbor_y]

			if current_value.energy_density > 1. and current_value.energy_density < 1.01:
				next_grid[x].append(Cell.new(current_value.energy_density - 1, current_value.mass_density + 1))
			else:
				next_grid[x].append(current_value)

			var coords = crs.forward(x, y)
			var atlas_coords = classify(current_value)
			tile_map_layer.set_cell(coords, 0, atlas_coords)
	
	grid = next_grid


class CoordinateReferenceSystem:
	var grid_size: int
	func forward(x: float, y: float) -> Vector2i:
		return Vector2i(x, y) - Vector2i.ONE * grid_size / 2


func classify(value: Cell) -> Vector2i:
	var e = value.energy_density * 4
	var m = value.mass_density
	if m > 0:
		return Vector2i.DOWN * 2
	if e > 0:
		return Vector2i.DOWN + Vector2i.RIGHT * min(7, int(e))
	return Vector2i.ZERO
