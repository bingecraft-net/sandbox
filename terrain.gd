extends Node2D

@export var size = 1
@export var detail = 1
@export var noise = FastNoiseLite.new()
@export var iso = 0.

var resource_chunk: Resource = load("res://terrain_chunk.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(size):
		var chunk: Node2D = resource_chunk.instantiate()
		chunk.position = Vector2(-chunk.scale.x / 2, y)
		chunk.detail = detail
		chunk.noise = noise
		chunk.iso = iso
		player_mine_down.connect(chunk._on_player_mine_down)
		add_child(chunk)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

signal player_mine_down(pos: Vector2, radius: float, delta: float)

func _on_player_mine_down(pos: Vector2, radius: float, delta: float) -> void:
	player_mine_down.emit(pos, radius, delta)
