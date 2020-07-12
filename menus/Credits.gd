extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_level0_pressed():
	get_tree().change_scene("res://world1.tscn")


func _on_level1_pressed():
	get_tree().change_scene("res://world2.tscn")


func _on_level2_pressed():
	get_tree().change_scene("res://world3.tscn")


func _on_level3_pressed():
	get_tree().change_scene("res://world4.tscn")
