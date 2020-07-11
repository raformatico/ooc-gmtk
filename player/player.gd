extends RigidBody

export var force : float = 10

var gravity : = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity = Vector3(0,-force,0)
	pass # Replace with function body.

func onetime_pressed() -> Vector3:
	if Input.is_action_just_pressed("west"):
		gravity = Vector3(0,0,-force)
	if Input.is_action_just_pressed("east"):
		gravity = Vector3(0,0,force)
	if Input.is_action_just_pressed("up"):
		gravity = Vector3(0,force,0)
	if Input.is_action_just_pressed("down"):
		gravity = Vector3(0,-force,0)
	if Input.is_action_just_pressed("north"):
		gravity = Vector3(force,0,0)
	if Input.is_action_just_pressed("south"):
		gravity = Vector3(-force,0,0)
	return gravity

func letit_pressed() -> Vector3:
	gravity = Vector3(0,0,0)
	if Input.is_action_pressed("west"):
		gravity += Vector3(0,0,-force)
	if Input.is_action_pressed("east"):
		gravity += Vector3(0,0,force)
	if Input.is_action_pressed("up"):
		gravity += Vector3(0,force,0)
	if Input.is_action_pressed("north"):
		gravity += Vector3(force,0,0)
	if Input.is_action_pressed("south"):
		gravity += Vector3(-force,0,0)
	if not Input.is_action_pressed("west") and not Input.is_action_pressed("east") and not Input.is_action_pressed("north") and not Input.is_action_pressed("south") and not Input.is_action_pressed("up"):
		gravity = Vector3(0,-force,0)
	return gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#add_central_force(letit_pressed())
	add_central_force(onetime_pressed())
	#apply_central_impulse(onetime_pressed())
	
	


func _on_player_body_entered(body: Node) -> void:
	print("entra algo... " + str(body.name))
	if body.is_in_group("wall"):
		print(body.name)
	elif body.is_in_group("box"):
		print("FIN")
		print(body.name)
	elif body.is_in_group("bomb"):
		print("PIERDES")
