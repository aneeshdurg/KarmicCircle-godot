extends StaticBody2D

export var button: NodePath

func buttonpress():
	print("unlocked!")
	$collider.set_deferred("disabled", true)
	$blocked.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("connecting to ", button)
	get_node(button).connect("ButtonPressed", self, "buttonpress")
