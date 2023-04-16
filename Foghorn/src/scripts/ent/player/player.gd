extends character
class_name player

var dir=Vector3()
#@onready var camera_holder=$head
@onready var fpscam=$head/Camera3D
@onready var p_col=$CollisionShape3D
@onready var p_col_foot=$footcollision
@export var env_file: Environment;

#@onready var orig_cam_translation: Vector3 =camera_holder.position
#var delta_=0;
var crouching_speed=20;
var def_height=1.7
var crouch_height=0.85


var camera_tilt = 0.4  #The speed which the camera will rotate back

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	jump=7;#override
	if env_file!=null:
		$head/Camera3D.set_environment(env_file)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
		head.rotation.x=clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))


func _process(_delta: float) -> void:
	SPEED=default_move_speed
	if Input.is_action_pressed("press_quit"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
#	delta_+=delta

	dir=Vector3()#reset dir length

	if groundcheck.is_colliding():
		full_contact=1
	else:
		full_contact=0

#jump handling
	if not is_on_floor():
		gravity_vec+=Vector3.DOWN*gravity*delta
		h_accel=air_accel
	elif is_on_floor() and full_contact:
		gravity_vec=-get_floor_normal()*gravity
		h_accel=normal_accel
	else:
		gravity_vec=-get_floor_normal()
		h_accel=normal_accel

	if Input.is_action_just_pressed("press_jump") and (is_on_floor() or groundcheck.is_colliding()):
		gravity_vec=Vector3.UP*jump

#crouch handling
	if Input.is_action_pressed("press_crouch"):
		p_col_foot.transform.origin.y+=crouching_speed*delta
		p_col.shape.height-=crouching_speed*delta

		SPEED=default_crouch_speed

	else:
		p_col_foot.transform.origin.y-=crouching_speed*delta
		p_col.shape.height+=crouching_speed*delta

		SPEED=default_move_speed

	p_col.shape.height=clamp(p_col.shape.height,crouch_height,def_height)
	p_col_foot.transform.origin.y=clamp(p_col.transform.origin.y,0.422,1)

# movement handling//USE "ELIF" IF DIAGONAL SPEED IS HIGH
	if Input.is_action_pressed("move_front"):
		dir-=transform.basis.z

	if Input.is_action_pressed("move_back"):
		dir+=transform.basis.z

	if Input.is_action_pressed("move_right"):
		fpscam.rotate_z(deg_to_rad(-camera_tilt))
		dir+=transform.basis.x

	if Input.is_action_pressed("move_left"):
		fpscam.rotate_z(deg_to_rad(camera_tilt))
		dir-=transform.basis.x
	#Returning the camera angle back to zero. The 0.5 has the camera rotate back at a slower rate.
	if not Input.is_action_pressed("move_left"):
		if fpscam.rotation.z > 0:
			fpscam.rotate_z(deg_to_rad(-camera_tilt * 0.5))
	if not Input.is_action_pressed("move_right"):
		if fpscam.rotation.z < 0:
			fpscam.rotate_z(deg_to_rad(camera_tilt * 0.5))

	fpscam.rotation.z = clamp(fpscam.rotation.z , -0.05, 0.05)  #Changing the thresholds will change how far the camera will rotate in either direction

	velocity=dir.normalized()*SPEED
	h_velocity=h_velocity.lerp(dir*SPEED,h_accel*delta)
	velocity.z=h_velocity.z+gravity_vec.z
	velocity.x=h_velocity.x+gravity_vec.z
	velocity.y=gravity_vec.y

	move_and_slide()
#	print(dir)
#	var camera_bob=floor(abs(velocity.x)+abs(velocity.z))*delta_*4 #dir=input?
#	var target_cam_translation=orig_cam_translation+Vector3.UP*sin(camera_bob)*0.5
#	camera_holder.position=camera_holder.position.lerp(target_cam_translation,delta)

