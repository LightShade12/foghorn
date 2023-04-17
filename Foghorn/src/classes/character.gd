extends CharacterBody3D
class_name character

"""
The character is a base class that "living things" should inherit from. Character currently isn't well implemented, but its intended to abstract away and house most commonly used functions, variables and classes. It will make creation of new entities in game faster and easier.-Subham
"""
#Class variables
var mouse_sensitivity:float=0.09

var health_points:int=100;

var current_move_speed:float=0; #current speed

var jump_velocity:float=5.5#is overriden in player.gd

var default_acceleration:float =6
var air_acceleration:float= 1
var horizontal_acceleration:float=6

var horizontal_velocity:Vector3=Vector3()

var crouch_move_speed:float=2;
var walk_move_speed:float=3;
var sprint_move_speed:float=6;

var current_bob_frequency:float =1;
var crouch_bob_frequency:float=2;
var walk_bob_frequency:float=3.5;
var sprint_bob_frequency:float=4.5;

var gravity_vector:Vector3=Vector3()
var gravity_scale:float=20

var b_full_contact: bool=false

@onready var node_head:Node3D=$head
@onready var node_groundcheck: RayCast3D=$ground_check

