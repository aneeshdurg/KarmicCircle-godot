extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation = $AnimationPlayer
onready var black = $Control/Black

func change_scene(path, delay=0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation.play("Fade")
	yield(animation, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation.play_backwards("Fade")
