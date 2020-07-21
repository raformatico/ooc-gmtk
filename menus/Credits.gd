extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_level0_pressed():
	get_tree().change_scene("res://world1.tscn")


func _on_level1_pressed():
	get_tree().change_scene("res://world2.tscn")


func _on_level2_pressed():
	get_tree().change_scene("res://world3.tscn")


func _on_level3_pressed():
	get_tree().change_scene("res://world4.tscn")


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://Menu.tscn")
