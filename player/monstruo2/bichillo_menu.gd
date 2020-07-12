extends RigidBody


export(bool) var humor setget set_humor

func set_humor(tranquilo):
	if(tranquilo):
		set_chill_texture()
	else:
		set_berseker_texture()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_chill_texture():
	#var m=$Armaduramitado/Skeleton/mitadomochito
	#m.get_surface_material(0).albedo_texture=load("res://player/monstruo2/Cuerpo.color.messed.jpg")
	pass
	
func set_berseker_texture():
	#var m=$Armaduramitado/Skeleton/mitadomochito
	#m.get_surface_material(0).albedo_texture=load("res://player/monstruo2/Cuerpo.color.messed.bad.jpg")
	pass
