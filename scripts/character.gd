extends Node2D

@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var camera: Camera2D = $Camera2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	character_body.velocity = input * 10000
	character_body.move_and_slide()


func _physics_process(delta: float) -> void:
	camera.position = character_body.position
