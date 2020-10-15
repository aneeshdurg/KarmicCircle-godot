extends KinematicBody2D

var popup_active = false

var vel : Vector2 = Vector2()
var grounded : bool = false
var in_water: int = 0

enum Animals {
	Human,
	Fish,
	Bird,
}

enum CausesOfDeath {
	Drowning,
	Suffocating,
	Falling,
}

var Sprites = {}

var humanProps = {
	animal = Animals.Human,
	
	maxspeed = 400,
	
	speed_on_land = 200,
	jump_force_on_land = 16000,
	gravity_on_land = 800,

	speed_in_water = 100,
	jump_force_in_water = 0,
	gravity_in_water = 400,

	can_jump_in_air = false,
	can_jump_in_water = false,
	breathes_air = true,
}

var fishProps = {
	animal = Animals.Fish,
	
	maxspeed = 400,
	
	speed_on_land = 100,
	jump_force_on_land = 50,
	gravity_on_land = 800,

	speed_in_water = 200,
	jump_force_in_water = 200,
	gravity_in_water = 100,

	can_jump_in_air = false,
	can_jump_in_water = true,
	breathes_air = false,
}

const suffocation_dps : int = 20

var curr_props = humanProps
var sprite = null
var CP = null
var hp : float = 100

var cause = null

func setSprite(props):
	for k in Sprites:
		Sprites[k].visible = false
	sprite = Sprites[curr_props.animal]
	sprite.visible = true
	
func getSpeed(props):
	if in_water:
		return props.speed_in_water
	return props.speed_on_land

func getJump(props):
	if in_water:
		return props.jump_force_in_water
	return props.jump_force_on_land

func getGravity(props):
	if in_water:
		return props.gravity_in_water
	return props.gravity_on_land

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Sprites[Animals.Human] = $HumanSprite
	Sprites[Animals.Fish] = $FishSprite
	setSprite(curr_props)

func _physics_process (delta):
	if popup_active:
		return
	# reset horizontal velocity
	vel.x = 0

	# movement inputs
	if Input.is_action_pressed("move_left"):
		vel.x -= getSpeed(curr_props)
		sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		vel.x += getSpeed(curr_props)
		sprite.flip_h = false
	else:
		vel.x = 0
	vel.x = clamp(vel.x, -1 * curr_props.maxspeed, curr_props.maxspeed)

	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	# gravity
	vel.y += getGravity(curr_props) * delta

	var check_ground = curr_props.can_jump_in_air || is_on_floor();
	if in_water && !is_on_floor():
		check_ground = curr_props.can_jump_in_water;

	# jump input
	if Input.is_action_pressed("jump") and check_ground:
		if !in_water:
			vel.y -= max(
				(abs(vel.x) / getSpeed(curr_props)) * getJump(curr_props),
				 getJump(curr_props) / 2
			) * delta;
		else:
			vel.y -= getJump(curr_props) * delta;
	
	# status effects
	
	if (in_water && curr_props.breathes_air) || (!in_water && !curr_props.breathes_air):
		hp -= suffocation_dps * delta
		hp = max(hp, 0)
		get_node("UI/Health").text = str(ceil(hp)) + "/100"
		if in_water:
			cause = CausesOfDeath.Drowning
		else:
			cause = CausesOfDeath.Suffocating
	
	if hp == 0:
		kill(cause)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func enter_water():
	in_water += 1
	if in_water > 1:
		return

func exit_water():
	in_water -= 1
	if in_water > 0:
		return

func checkpoint(cp):
	if (CP):
		CP.deactivate()
	CP = cp
	CP.activate()

func setCollision(props):
	if props.animal == Animals.Human:
		$CollisionShape2D.rotation = 0
		$CollisionShape2D.get_shape().set_height(23)
		$CollisionShape2D.get_shape().set_radius(5.73)
	elif props.animal == Animals.Fish:
		$CollisionShape2D.get_shape().set_height(23)
		$CollisionShape2D.get_shape().set_radius(5.73)
		$CollisionShape2D.rotation = PI / 2

func kill(death_cause):
	if death_cause == CausesOfDeath.Drowning:
		curr_props = fishProps
	else:
		curr_props = humanProps
		
	# TODO dying animation? Popup?
	var death_msg = "You died! You will reincarnate as a "
	if curr_props.animal == Animals.Human:
		death_msg += "human."
	elif curr_props.animal == Animals.Fish:
		death_msg += "fish."
		

	popup_active = true
	Death.animate(death_msg)
	
	yield(get_tree().create_timer(0.75), "timeout")
	
	cause = null
	get_node("UI/Health").text = "100/100"
	position = CP.position
	

	hp = 100
	setSprite(curr_props)
	setCollision(curr_props)
	popup_active = false
	yield(Death, "DeathAnimationDone")