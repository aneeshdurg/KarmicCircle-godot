extends StaticBody2D

export var button: NodePath
export var defaultLocked : bool = true

onready var blocked = $blocked
onready var collider = $collider
var locked = defaultLocked

func unlock():
	locked = false
	collider.set_deferred("disabled", true)
	blocked.modulate = Color(1, 1, 1, 0.5)

func lock():
	locked = true
	collider.set_deferred("disabled", false)
	blocked.modulate = Color(1, 1, 1, 1)

func buttonpress():
	if locked:
		unlock()
	else:
		lock()

# Called when the node enters the scene tree for the first time.
func _ready():
	if !defaultLocked:
		unlock()
	get_node(button).connect("ButtonPressed", self, "buttonpress")
