extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Credits_pressed():
	get_tree().change_scene("res://menus/Credits.tscn")


func _on_Play2_pressed():
	get_tree().change_scene("res://menus/ElegirFase.tscn")
