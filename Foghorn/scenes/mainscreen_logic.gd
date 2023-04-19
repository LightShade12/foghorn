extends Node2D
var lerfv:float=0;

signal level_changed(level_name)
@export var level_name: String = "level"

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
	#var tween = get_tree().create_tween()
	#tween.tween_property($Control/OverlayLayer/Overlay, "modulate", Color(0.0, 0.0, 1.0, 1.0), 2).set_trans(Tween.TRANS_LINEAR)
	level_changed.emit(level_name)


func _on_optionsbutton_pressed() -> void:
	pass # Replace with function body.

