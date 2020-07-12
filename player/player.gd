extends RigidBody

export var force : float = 10
export var speed  : float = 10
onready var bichillo : RigidBody = get_parent().get_node("bichillo")
onready var bichillo_anim : AnimationPlayer = bichillo.get_node("AnimationPlayer")
onready var box : StaticBody = get_parent().get_node("box") 
onready var box_pos : Position3D = box.get_node("box_pos")

var gravity : = Vector3()
var gravity_changed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity = Vector3(0,-force,0)
	pass # Replace with function body.

func onetime_pressed() -> Vector3:
	if Input.is_action_just_pressed("west"):
		if gravity != Vector3(0,0,-force):
			gravity_changed = true
		gravity = Vector3(0,0,-force)
	if Input.is_action_just_pressed("east"):
		if gravity != Vector3(0,0,force):
			gravity_changed = true
		gravity = Vector3(0,0,force)
	if Input.is_action_just_pressed("up"):
		if gravity != Vector3(0,force,0):
			gravity_changed = true
		gravity = Vector3(0,force,0)
	if Input.is_action_just_pressed("down"):
		if gravity != Vector3(0,-force,0):
			gravity_changed = true
		gravity = Vector3(0,-force,0)
	if Input.is_action_just_pressed("north"):
		if gravity != Vector3(force,0,0):
			gravity_changed = true
		gravity = Vector3(force,0,0)
	if Input.is_action_just_pressed("south"):
		if gravity != Vector3(-force,0,0):
			gravity_changed = true
		gravity = Vector3(-force,0,0)
	return gravity

func letit_pressed() -> Vector3:
	if Input.is_action_pressed("west"):
		gravity = Vector3(0,0,-force)
	if Input.is_action_pressed("east"):
		gravity = Vector3(0,0,force)
	if Input.is_action_pressed("up"):
		gravity = Vector3(0,force,0)
	if Input.is_action_pressed("north"):
		gravity = Vector3(force,0,0)
	if Input.is_action_pressed("south"):
		gravity = Vector3(-force,0,0)
	if not Input.is_action_pressed("west") and not Input.is_action_pressed("east") and not Input.is_action_pressed("north") and not Input.is_action_pressed("south") and not Input.is_action_pressed("up"):
		gravity = Vector3(0,-force,0)
	return gravity

func turn_bichillo() -> void:
	#WEST
	if gravity == Vector3(0,0,-force):
		rotation_degrees = Vector3(0,0,0)
		rotation_degrees.x = 90
		axis_lock_angular_x = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#EAST
	if gravity == Vector3(0,0,force):
		rotation_degrees = Vector3(0,0,0)
		rotation_degrees.x = -90
		axis_lock_angular_x = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#UP
	if gravity == Vector3(0,force,0):
		rotation_degrees.z = 180
		axis_lock_angular_z = true
		rotation_degrees.x = 0
		axis_lock_angular_x = true
	#DOWN
	if gravity == Vector3(0,-force,0):
		rotation_degrees.z = 0
		axis_lock_angular_z = true
		rotation_degrees.x = 0
		axis_lock_angular_x = true
	#NORTH
	if gravity == Vector3(force,0,0):
		rotation_degrees = Vector3(0,0,90)
		axis_lock_angular_z = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#SOUTH
	if gravity == Vector3(-force,0,0):
		rotation_degrees = Vector3(0,0,-90)
		axis_lock_angular_z = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true

func unloock_axis() -> void:
	axis_lock_angular_x = false
	axis_lock_angular_y = false
	axis_lock_angular_z = false

func is_near_floor() -> bool:
	var near : bool = false
	
	return near

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#add_central_force(letit_pressed())
	#linear_velocity = get_direction_run()
	if gravity_changed:
		#linear_velocity = Vector3(0,0,0)
		bichillo_anim.play("parado")
		#Girar el bicho
		turn_bichillo()
		gravity_changed = false
	elif is_near_floor():
		bichillo_anim.play("andando")
		linear_velocity = get_direction_run()
	add_central_force(onetime_pressed())
	#apply_central_impulse(onetime_pressed())
	
	
func get_direction_run() -> Vector3:
	#Hacerlo en función de la dirección de la gravedad
	#Devolver una velocidad solo si toca el suelo correspondiente a la gravedad
	var pos_ooc : Vector3 = self.translation
	var direction : Vector3 = pos_ooc - box_pos.translation
	direction = direction * Vector3(1,0,1)
	return direction.normalized()*speed

func _on_player_body_entered(body: Node) -> void:
	print("entra algo... " + str(body.name))
	if body.is_in_group("wall"):
		print(body.name)
	elif body.is_in_group("box"):
		print("FIN")
		print(body.name)
	elif body.is_in_group("bomb"):
		print("PIERDES")
