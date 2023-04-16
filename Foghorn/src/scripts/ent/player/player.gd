"""
BUGS:
1.Pressing move forward and move left i.e any diagonal movement causes movement vector to gain cumulative length and thus player moves faster than normal while using diagonal movements
2.Player can press jump twice rapidly to make mid air jump(double jump); this is unintended and undesirable
3.Bad collision when falling near ledges;contact surface;causes sudden snappy fall
"""

extends character
class_name player

@onready var node_fps_camera=$head/Camera3D
@onready var node_player_collision=$CollisionShape3D
@onready var node_player_collision_foot=$footcollision
@onready var node_animationplayer_cambob=$AnimationPlayer#for camera bobbing
@export var camera_environment_file: Environment;

var movement_vector=Vector3()
var is_sprinting:bool=false
var crouching_speed:float=20
var standing_height_metres:float=1.7
var crouch_height_metres=0.85
var camera_bob_frequency=walk_bob_frequency

var camera_tilt_recover_speed = 0.4  #The speed which the camera will rotate back

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	jump_velocity=7;#override
	if camera_environment_file!=null:
		$head/Camera3D.set_environment(camera_environment_file)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sensitivity))
		node_head.rotate_x(deg_to_rad(-event.relative.y*mouse_sensitivity))
		node_head.rotation.x=clamp(node_head.rotation.x,deg_to_rad(-89),deg_to_rad(89))


func _process(_delta: float) -> void:
	current_move_speed=walk_move_speed
	if Input.is_action_pressed("press_sprint"):
		is_sprinting=true
	if Input.is_action_pressed("press_quit"):
		get_tree().quit()


func _physics_process(delta: float) -> void:

	movement_vector=Vector3()#reset movement_vector length

	if node_groundcheck.is_colliding():
		b_full_contact=true
	else:
		b_full_contact=false

	#jump handling
	if not is_on_floor():
		gravity_vector+=Vector3.DOWN*gravity_scale*delta
		horizontal_acceleration=air_acceleration
	elif is_on_floor() and b_full_contact:
		gravity_vector=-get_floor_normal()*gravity_scale
		horizontal_acceleration=default_acceleration
	else:
		gravity_vector=-get_floor_normal()
		horizontal_acceleration=default_acceleration

	if Input.is_action_just_pressed("press_jump") and (is_on_floor() or node_groundcheck.is_colliding()):
		gravity_vector=Vector3.UP*jump_velocity

	#crouch handling
	if Input.is_action_pressed("press_crouch"):
		node_player_collision_foot.transform.origin.y+=crouching_speed*delta
		node_player_collision.shape.height-=crouching_speed*delta
		camera_bob_frequency=crouch_bob_frequency
		current_move_speed=crouch_move_speed

	else:
		node_player_collision_foot.transform.origin.y-=crouching_speed*delta
		node_player_collision.shape.height+=crouching_speed*delta

	node_player_collision.shape.height=clamp(node_player_collision.shape.height,crouch_height_metres,standing_height_metres)
	node_player_collision_foot.transform.origin.y=clamp(node_player_collision.transform.origin.y,0.422,1)

	# movement handling//USE "ELIF" IF DIAGONAL current_move_speed IS HIGH
	if Input.is_action_pressed("move_front"):
		movement_vector-=transform.basis.z

	elif Input.is_action_pressed("move_back"):
		movement_vector+=transform.basis.z

	if Input.is_action_pressed("move_right"):
		node_fps_camera.rotate_z(deg_to_rad(-camera_tilt_recover_speed))
		movement_vector+=transform.basis.x

	elif Input.is_action_pressed("move_left"):
		node_fps_camera.rotate_z(deg_to_rad(camera_tilt_recover_speed))
		movement_vector-=transform.basis.x
	#Returning the camera angle back to zero. The 0.5 has the camera rotate back at a slower rate.
	if not Input.is_action_pressed("move_left"):
		if node_fps_camera.rotation.z > 0:
			node_fps_camera.rotate_z(deg_to_rad(-camera_tilt_recover_speed * 0.5))
	if not Input.is_action_pressed("move_right"):
		if node_fps_camera.rotation.z < 0:
			node_fps_camera.rotate_z(deg_to_rad(camera_tilt_recover_speed * 0.5))

	node_fps_camera.rotation.z = clamp(node_fps_camera.rotation.z , -0.05, 0.05)  #Changing the thresholds will change how far the camera will rotate in either movement_vectorection

	#sprint handling
	if(is_sprinting):
		current_move_speed=sprint_move_speed
		camera_bob_frequency=sprint_bob_frequency
		get_tree().create_tween().tween_property(node_fps_camera,"fov",110,0.5)
	else:
		get_tree().create_tween().tween_property(node_fps_camera,"fov",90,2)

	#camera bobbing mechanic
	if movement_vector != Vector3.ZERO and is_on_floor():
		if not node_animationplayer_cambob.is_playing():
			node_animationplayer_cambob.speed_scale=camera_bob_frequency
			node_animationplayer_cambob.play("camera_bob")
	elif movement_vector == Vector3.ZERO or not is_on_floor():
		if node_animationplayer_cambob.is_playing():
			node_animationplayer_cambob.stop()
#		node_fps_camera.transform.basis = Basis.IDENTITY
		node_fps_camera.transform.origin = Vector3()


	velocity=movement_vector.normalized()*current_move_speed#assign velocity

#deacceleration handling
	horizontal_velocity=horizontal_velocity.lerp(movement_vector*current_move_speed,horizontal_acceleration*delta)
	velocity.z=horizontal_velocity.z+gravity_vector.z
	velocity.x=horizontal_velocity.x+gravity_vector.z
	velocity.y=gravity_vector.y
	move_and_slide()

	#reset variables
	is_sprinting=false
	current_move_speed=walk_move_speed
	camera_bob_frequency=walk_bob_frequency

