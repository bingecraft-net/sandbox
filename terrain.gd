extends Node2D

@export var size = 1
@export var detail = 1
@export var noise = FastNoiseLite.new()
@export var iso = 0.

var resource_chunk: Resource = load("res://terrain_chunk.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(-size * scale.x / 2, 0)

	for index in range(size * size):
		var x = index % size
		@warning_ignore("integer_division")
		var y = index / size
		var chunk: Node2D = resource_chunk.instantiate()
		chunk.position = Vector2(x, y)
		chunk.detail = detail
		chunk.noise = noise
		chunk.iso = iso
		add_child(chunk)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
