extends Node2D

@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	character_body.velocity = input * 10000  # multiply by speed
	character_body.move_and_slide()


func _physics_process(delta: float) -> void:
	camera.position = character_body.position
