extends Node2D

@export var grid_size: int = 64
@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var dt: float = 0.125

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var grid: Array[Array] = []
var next_grid: Array[Array] = []
var crs: CoordinateReferenceSystem = CoordinateReferenceSystem.new(grid_size)


func _ready() -> void:
	for x in range(grid_size):
		grid.append([])
		next_grid.append([])
		for y in range(grid_size):
			var sample = noise.get_noise_2d(x, y)
			var energy_density = 4 * clamp(sample, 0, 1)
			var value = Cell.new(energy_density, 0.)
			grid[x].append(value)
			next_grid[x].append(Cell.new())


func _process(delta: float) -> void:
	for x in range(grid_size):
		for y in range(grid_size):
			var current_value: Cell = grid[x][y]
			var e = current_value.energy_density
			var m = current_value.mass_density
			
			var e_laplacian = 0.

			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor_x = (x + dx + grid_size) % grid_size
					var neighbor_y = (y + dy + grid_size) % grid_size
					var neighbor_value = grid[neighbor_x][neighbor_y]
					e_laplacian += (neighbor_value.energy_density - e)

			e += e_laplacian * dt * delta

			if abs(e - 1.) < 0.01:
				e -= 0.01
				m += 0.01

			var next_value: Cell = next_grid[x][y]
			next_value.energy_density = e
			next_value.mass_density = m

			var coords = crs.forward(x, y)
			var atlas_coords = classify(next_value)
			tile_map_layer.set_cell(coords, 0, atlas_coords)

	var	old_grid = grid
	grid = next_grid
	next_grid = old_grid


class CoordinateReferenceSystem:
	var grid_size: int
		
	func _init(s: int = 1):
		grid_size = s
		
	func forward(x: float, y: float) -> Vector2i:
		return Vector2i(x, y) - Vector2i.ONE * grid_size / 2


func classify(value: Cell) -> Vector2i:
	var e = value.energy_density
	var m = value.mass_density
	return Vector2i(
		0 if e <= 0 else 1 if e <= 1. else 2,
		0 if m <= 0 else 1 if m <= .1 else 2,
	)
