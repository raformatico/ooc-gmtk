extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer=$"../Timer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var format_string = "%2d"	
	var actual_string = format_string % [timer.get_time_left()]
	$Label.text=actual_string
