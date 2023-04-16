extends Node2D
var lerfv:float=0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lerfv+=1*delta
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	$Control/CanvasLayer/CanvasModulate.color[3]=lerpf(1,0,lerfv)

#	get_tree().change_scene_to_file("res://maps/test_map01.tscn")
	pass # Replace with function body.
