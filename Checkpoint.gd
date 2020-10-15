extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state: bool = false
var knownState: bool = false

onready var activeSprite = $activated
onready var disabledSprite = $disabled

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func activate():
	activeSprite.visible = true
	disabledSprite.visible = false

func deactivate():
	activeSprite.visible = false
	disabledSprite.visible = true

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		state = true
		body.checkpoint(self)

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		state = false
