extends Node2D
var lerfv:float=0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lerfv+=delta
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
#	$Control/CanvasLayer/CanvasModulate.color=lerp(Color(0, 0, 0, 1), Color(1, 1, 1, 1),2)

	get_tree().change_scene_to_file("res://maps/test_map01.tscn")
	pass # Replace with function body.


func _on_optionsbutton_pressed() -> void:
	pass # Replace with function body.

