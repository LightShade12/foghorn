extends CharacterBody3D
class_name character

var h_accel=6
var h_velocity=Vector3()
var movement=Vector3()
var mouse_sens=0.09
var SPEED =10
var jump=7.5
var gravity_vec=Vector3()
var full_contact: bool=false
var normal_accel =6
var air_accel= 1
var hp:int=100;

@onready var head=$head
@onready var groundcheck: RayCast3D=$ground_check

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity=20
