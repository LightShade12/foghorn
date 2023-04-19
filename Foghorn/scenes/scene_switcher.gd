extends Node

var time_start = Time.get_unix_time_from_system()
var next_level = null
@onready var current_level = $mainscreen
@onready var anim = $AnimationPlayer

func _ready():
	timenow("ready")
	current_level.connect("level_changed", handle_level_changed)
	timenow("control after handlling level change")

func timenow(msg: String) -> void:
	#print(
	#	str(Time.get_datetime_dict_from_system()["minute"])+
	#	":"+str(Time.get_datetime_dict_from_system()["second"])+
	#	" "+msg
	#	)
	print(
		str(Time.get_unix_time_from_system() - time_start) + " Elapsed. " + msg
	)
	
func handle_level_changed(current_level_name: String):
	timenow("inside handle level change")
	anim.play("fade_in")
	print("Level Changed, Current level name is ", current_level_name)
	match current_level_name:
		"mainscreen":
			print("loading next level")
			next_level = preload("res://maps/test_map01.tscn").instantiate()
			get_tree().get_root().add_child(next_level)
			timenow("loaded map01 scene and added to root")
		_:
			return

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			current_level.free()
			current_level = next_level
			timenow("Free the current level")
			next_level = null
			anim.play("fade_out")
