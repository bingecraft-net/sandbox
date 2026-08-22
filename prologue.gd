extends Node2D

var index = 0

var prologue = [
	"Your amazing life starts on Earth",
	"There is not much to be said about you",
	"Your dreams are about people and places very far away",
]

var call_to_action = "Press LMB"

func advance():
	if index >= len(prologue):
		hide()
		return
	$RichTextLabel.text = format(prologue[index] + "\n\n" + call_to_action)
	index += 1

func format(s:String):
	return "[font_size=32]%s[/font_size]" % s
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	advance()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LMB"):
		advance()
