extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 64

@onready var cells: Node2D = $Cells

var cell_fab = load("res://scenes/cell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cell = cell_fab.instantiate()
	cell.noise = noise
	cell.grid_size = grid_size
	cell.offset = Vector2i.ONE * grid_size / -2
	cell.position = Vector2i.ONE * grid_size * 16 / -2
	cells.add_child(cell)
