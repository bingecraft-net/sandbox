extends Node2D

@export var grid_size: int = 64
@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var timer: Timer = $Timer

var grid: Array[Array] = []
var next_grid: Array[Array] = []
var crs: CoordinateReferenceSystem = CoordinateReferenceSystem.new(grid_size)


func _ready() -> void:
	for x in range(grid_size):
		grid.push_back([])
		next_grid.push_back([])
		for y in range(grid_size):
			var value = Cell.new()
			var sample = noise.get_noise_2d(x, y)
			value.energy_density = 4 * clamp(sample, 0, 1)
			grid[x].push_back(value)
			next_grid[x].push_back(Cell.new())


func _on_timer_timeout() -> void:
	tick()

func tick():
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
					e_laplacian += (neighbor_value.energy_density - e) / 8.

			e += e_laplacian * timer.wait_time

			# energy condenses into matter
			if e > 1.:
				e -= timer.wait_time * .1
				m += timer.wait_time * .1
			
			# matter dissociates into energy
			if e > 1.01:
				e += timer.wait_time * .1
				m -= timer.wait_time * .1

			var next_value: Cell = next_grid[x][y]
			next_value.energy_density = e
			next_value.mass_density = m

			var coords = crs.forward(x, y)
			var atlas_coords = next_value.classify()
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


class Cell:
	var energy_density: float = 0.0
	var mass_density: float = 0.0
	
	func classify() -> Vector2i:
		var e = energy_density
		var m = mass_density
		return Vector2i(
			0 if e <= 0 else 1 if e <= .875 else 2 if e <= 1.01 else 3 ,
			0 if m <= 0 else 1 if m <= .3 else 2,
		)
