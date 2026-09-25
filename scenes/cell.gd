extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 128
@export var valleyness: float = 0.5
@export var offset: Vector2i = Vector2i.ZERO

@onready var map: TileMapLayer = $TileMapLayer
@onready var label: Label = $CanvasLayer/LayerLabel
@onready var valleyness_slider: HSlider = $CanvasLayer/ValleynessSlider
@onready var valleyness_label: Label = $CanvasLayer/ValleynessLabel
@onready var frequency_slider: HSlider = $CanvasLayer/FrequencySlider
@onready var frequency_label: Label = $CanvasLayer/FrequencyLabel
@onready var lacunarity_slider: HSlider = $CanvasLayer/LacunaritySlider
@onready var lacunarity_label: Label = $CanvasLayer/LacunarityLabel
@onready var mass_gain_slider: HSlider = $CanvasLayer/MassGainSlider
@onready var mass_gain_label: Label = $CanvasLayer/MassGainLabel

var elapsed = 0
var mass = Array()
var mode = true
var MASS_GAIN := 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frequency_slider.value_changed.connect(_on_frequency_slider_value_changed)
	valleyness_slider.value_changed.connect(_on_valleyness_slider_value_changed)
	lacunarity_slider.value_changed.connect(_on_lacunarity_slider_value_changed)
	for x in range(grid_size):
		mass.push_back([])
		for y in range(grid_size):
			mass[x].push_back(.5 * randf())

func _process(delta: float) -> void:
	elapsed += delta
	label.text = "Layer: %s" % ("mass (1)" if mode else "base (0)")
	valleyness_label.text = "Valleyness (%.2f)" % valleyness
	frequency_label.text = "Frequency (%.4f)" % noise.frequency
	lacunarity_label.text = "Lacunarity (%.2f)" % noise.fractal_lacunarity
	mass_gain_label.text = "Mass gain (%.2f)" % MASS_GAIN


	for x in range(grid_size):
		for y in range(grid_size):
			var magnitude = 0.
			if mode:
				magnitude = 15.0 * smoothstep(0., 1.0, mass[x][y])
			else:
				magnitude = 15.0 * smoothstep(0., 1.0, 1. - sample(x, y, elapsed))
			map.set_cell(Vector2i(x, y), 0, floor(magnitude) * Vector2i.RIGHT)


func sample(x: float, y: float, time: float) -> float:
	var a = noise.get_noise_3d((x + offset.x), (y + offset.y), time)
	return pow(abs(sin(PI * a)), valleyness)


func _on_node_2d_character_on_mode_change() -> void:
	mode = not mode


func _on_valleyness_slider_value_changed(value: float) -> void:
	valleyness = pow(2, value - 6)


func _on_frequency_slider_value_changed(value: float) -> void:
	noise.frequency = pow(1.002, value) - 1


func _on_lacunarity_slider_value_changed(value: float) -> void:
	noise.fractal_lacunarity = value / 2.5
	
func _on_mass_gain_slider_value_changed(value: float) -> void:
	MASS_GAIN = value / 10.


func _on_timer_timeout() -> void:
	for frame in range(2):
		for x in range(frame, grid_size, 2):
			for y in range(frame, grid_size, 2):
				var x0 = x
				var x1 = (x + 1) % grid_size
				var y0 = y
				var y1 = (y + 1) % grid_size
				
				var m00 = mass[x0][y0]
				var m10 = mass[x1][y0]
				var m11 = mass[x1][y1]
				var m01 = mass[x0][y1]
				
				var a00 = sample(x0, y0, elapsed)
				var a10 = sample(x1, y0, elapsed)
				var a11 = sample(x1, y1, elapsed)
				var a01 = sample(x0, y1, elapsed)
				
				var mean = (m00 + m10 + m11 + m01 + a00 + a10 + a11 + a01) / 4.
				
				m00 += (mean - m00 - a00) * MASS_GAIN
				m10 += (mean - m10 - a10) * MASS_GAIN
				m11 += (mean - m11 - a11) * MASS_GAIN
				m01 += (mean - m01 - a01) * MASS_GAIN
				
				mass[x0][y0] = m00
				mass[x1][y0] = m10
				mass[x1][y1] = m11
				mass[x0][y1] = m01
				
