extends Node2D

@export var speed = 1000

@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var camera: Camera2D = $Camera2D

signal on_mode_change

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	character_body.velocity = input * speed * pow(1.1, -camera.zoom.length())
	character_body.move_and_slide()
	
	var zoom = Input.get_axis("zoom out", "zoom in")
	camera.zoom *= pow(2, delta * zoom)
	
	if Input.is_action_just_pressed("toggle mode"):
		on_mode_change.emit()
		

func _physics_process(delta: float) -> void:
	camera.position = character_body.position
