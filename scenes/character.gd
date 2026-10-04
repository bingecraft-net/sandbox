extends Node3D

@onready var character_body: CharacterBody3D = $CharacterBody3D
@onready var camera: Camera3D = $Camera3D

func _process(delta: float) -> void:
	var throttle = Input.get_axis("ui_up", "ui_down")
	var steer = Input.get_axis("ui_left", "ui_right")
	character_body.velocity = character_body.transform.basis.z * throttle * 5
	character_body.rotate(Vector3.DOWN, steer * delta * 2)
	character_body.move_and_slide()

func _physics_process(delta: float) -> void:
	camera.position = character_body.position
	camera.rotation = character_body.rotation
