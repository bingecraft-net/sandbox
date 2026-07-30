extends Node2D

func _process(delta: float) -> void:
	$Terrain.load_chunks($Ship/RigidBody2D.position)
