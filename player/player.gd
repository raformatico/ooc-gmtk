extends RigidBody

export var force : float = 5
export var speed  : float = 10

export var move_enabled : bool = true

export(bool) var humor setget set_humor

func set_humor(tranquilo):
	if(tranquilo):
		set_chill_texture()
	else:
		set_berseker_texture()


onready var bichillo : RigidBody = get_parent().get_node("bichillo")
onready var bichillo_anim : AnimationPlayer = bichillo.get_node("AnimationPlayer")
onready var box : StaticBody = get_parent().get_node("box") 
onready var box_pos : Position3D = box.get_node("box_pos")
onready var stage1 : GridMap = get_parent().get_node("stage1")
onready var escape_points = get_parent().get_node("escape_points")

onready var malla : MeshInstance = get_parent().get_node("bichillo/Armaduramitado/Skeleton/mitadomochito")

enum {NORTH, SOUTH, WEST, EAST, UP, DOWN}

export var changes_of_state : int = 3

const DIST_MIN : float = 1.2

var gravity : = Vector3()
var gravity_changed : bool = false
var near_floor : bool = true
var gravity_direction : int = DOWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity = Vector3(0,-force,0)
	pass # Replace with function body.

func onetime_pressed() -> Vector3:
	if Input.is_action_just_pressed("west"):
		if gravity != Vector3(0,0,-force):
			gravity_changed = true
			gravity_direction = WEST
		gravity = Vector3(0,0,-force)
	if Input.is_action_just_pressed("east"):
		if gravity != Vector3(0,0,force):
			gravity_changed = true
			gravity_direction = EAST
		gravity = Vector3(0,0,force)
	if Input.is_action_just_pressed("up"):
		if gravity != Vector3(0,force,0):
			gravity_changed = true
			gravity_direction = UP
		gravity = Vector3(0,force,0)
	if Input.is_action_just_pressed("down"):
		if gravity != Vector3(0,-force,0):
			gravity_changed = true
			gravity_direction = DOWN
		gravity = Vector3(0,-force,0)
	if Input.is_action_just_pressed("north"):
		if gravity != Vector3(force,0,0):
			gravity_changed = true
			gravity_direction = NORTH
		gravity = Vector3(force,0,0)
	if Input.is_action_just_pressed("south"):
		if gravity != Vector3(-force,0,0):
			gravity_changed = true
			gravity_direction = SOUTH
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
	#var transform_i = transform
	#var transform_f
	#WEST
	if gravity_direction == WEST:
		rotation_degrees = Vector3(0,0,0)
		rotation_degrees.x = 90
		axis_lock_angular_x = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#EAST
	if gravity_direction == EAST:
		rotation_degrees = Vector3(0,0,0)
		rotation_degrees.x = -90
		axis_lock_angular_x = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#UP
	if gravity_direction == UP:
		rotation_degrees.z = 180
		axis_lock_angular_z = true
		rotation_degrees.x = 0
		axis_lock_angular_x = true
	#DOWN
	if gravity_direction == DOWN:
		rotation_degrees.z = 0
		axis_lock_angular_z = true
		rotation_degrees.x = 0
		axis_lock_angular_x = true
	#NORTH
	if gravity_direction == NORTH:
		rotation_degrees = Vector3(0,0,90)
		axis_lock_angular_z = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#SOUTH
	if gravity_direction == SOUTH:
		rotation_degrees = Vector3(0,0,-90)
		axis_lock_angular_z = true
		rotation_degrees.y = 0
		axis_lock_angular_y = true
	#var transfor_f = transform
	#var a = Quat(transform_i.basis)
	#var b = Quat(transform_f.basis)
	#var c = a.slerp(b,0.5)
	#transform.basis = Basis(c)
	#https://docs.godotengine.org/es/stable/tutorials/3d/using_transforms.html
	#ADD TWEEN PARA HACER MAS SMOOTH LA ROTACIÓN
	
func unloock_axis() -> void:
	axis_lock_angular_x = false
	axis_lock_angular_y = false
	axis_lock_angular_z = false

func is_near_floor() -> bool:
	var near : bool = false
	var distance : float
	var pos : Position3D
	var plane : Plane
	if near_floor == true and gravity_changed == false:
		unloock_axis()
		near = near_floor
	else:
		#WEST
		if gravity_direction == WEST:
			pos = stage1.get_node("p_west")
			plane = Plane(Vector3(0,0,1),pos.translation.z)
		#EAST
		if gravity_direction == EAST:
			pos = stage1.get_node("p_east")
			plane = Plane(Vector3(0,0,1),pos.translation.z)
		#UP
		if gravity_direction == UP:
			pos = stage1.get_node("p_up")
			plane = Plane(Vector3(0,1,0),pos.translation.y)
		#DOWN
		if gravity_direction == DOWN:
			pos = stage1.get_node("p_down")
			plane = Plane(Vector3(0,1,0),pos.translation.y)
		#NORTH
		if gravity_direction == NORTH:
			pos = stage1.get_node("p_north")
			plane = Plane(Vector3(-1,0,0),pos.translation.x)
		#SOUTH
		if gravity_direction == SOUTH:
			pos = stage1.get_node("p_south")
			plane = Plane(Vector3(-1,0,0),pos.translation.x)
		if abs(plane.distance_to(translation)) < DIST_MIN:
			near = true
	return near

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_direction_run() -> Vector3:
	#Hacerlo en función de la dirección de la gravedad
	#Devolver una velocidad solo si toca el suelo correspondiente a la gravedad
	var pos_ooc : Vector3 = self.translation
	var direction : Vector3 = pos_ooc - box_pos.translation
	var normal : Vector3
	var escape_pos : Position3D
	#WEST
	if gravity_direction == WEST:
		escape_pos = escape_points.get_node("esc_west")
		direction = escape_pos.translation - pos_ooc
		normal = Vector3(1,1,0)
	#EAST
	if gravity_direction == EAST:
		escape_pos = escape_points.get_node("esc_east")
		direction = escape_pos.translation - pos_ooc
		normal = Vector3(1,1,0)
	#UP
	if gravity_direction == UP:
		escape_pos = escape_points.get_node("esc_up")
		direction = escape_pos.translation - pos_ooc
		normal = Vector3(1,0,1)
	#DOWN
	if gravity_direction == DOWN:
		escape_pos = escape_points.get_node("esc_down")
		direction = escape_pos.translation - pos_ooc
		normal = Vector3(1,0,1)
	#NORTH
	if gravity_direction == NORTH:
		escape_pos = escape_points.get_node("esc_north")
		direction = escape_pos.translation - pos_ooc
		normal = Vector3(0,1,1)
	#SOUTH
	if gravity_direction == SOUTH:
		escape_pos = escape_points.get_node("esc_south")
		direction = escape_pos.translation - pos_ooc
		normal = Vector3(0,1,1)
	#direction = pos_ooc - box_pos.translation
	direction = direction * normal
	direction = direction.normalized()
	#self.look_at(escape_pos.translation,Vector3(0,1,0))
	"""if direction.x == 0:
		transform.basis.y = Vector3(0,direction.y,0)
		transform.basis.z = Vector3(0,0,direction.z)
	elif direction.y == 0:
		transform.basis.x = Vector3(direction.x,0,0)
		transform.basis.z = Vector3(0,0,direction.z)
	elif direction.z == 0:
		transform.basis.y = Vector3(0,direction.y,0)
		transform.basis.x = Vector3(direction.x,0,0)"""
	return direction*speed

func _physics_process(delta: float) -> void:
	#add_central_force(letit_pressed())
	#linear_velocity = get_direction_run()
	if gravity_changed:
		if changes_of_state == 0:
			end_game()
		#linear_velocity = Vector3(0,0,0)
		bichillo_anim.play("parado")
		#Girar el bicho
		turn_bichillo()
		near_floor = false
		gravity_changed = false
		changes_of_state -= 1
	elif is_near_floor():
		#bichillo_anim.play("andando")
		bichillo_anim.play("parado")
		if move_enabled:
			linear_velocity = get_direction_run()
	add_central_force(onetime_pressed())
	#apply_central_impulse(onetime_pressed())


func _on_bichillo_body_entered(body: Node) -> void:
	print("entra algo... " + str(body.name))
	if body.is_in_group("wall"):
		print(body.name)
	elif body.is_in_group("bot"):
		win()
	elif body.is_in_group("bomb"):
		print("PIERDES")

func win() -> void:
	print("YOU WIN")

func end_game() -> void:
	print("GAME OVER")
	get_tree().paused = true

func _on_Timer_timeout() -> void:
	end_game()


func set_chill_texture():
	var m=$Armaduramitado/Skeleton/mitadomochito
	m.get_surface_material(0).albedo_texture=load("res://player/monstruo2/Cuerpo.color.messed.jpg")
	
func set_berseker_texture():
	var m=$Armaduramitado/Skeleton/mitadomochito
	m.get_surface_material(0).albedo_texture=load("res://player/monstruo2/Cuerpo.color.messed.bad.jpg")
