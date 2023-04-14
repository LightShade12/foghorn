extends character
class_name player

var dir=Vector3()

@export var env_file: Environment;


func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	jump=7;
#	gravity=40
	if env_file!=null:
		$head/Camera3D.set_environment(env_file)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
		head.rotation.x=clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))


func _process(_delta: float) -> void:

	if Input.is_action_pressed("press_quit"):
		get_tree().quit()
#	if velocity.x!=0 and velocity.z!=0:
#		audioplayer.playing=true
#	else:
#		audioplayer.playing=false

func _physics_process(delta: float) -> void:

	dir=Vector3()
	if groundcheck.is_colliding():
		full_contact=1
	else:
		full_contact=0

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

	if Input.is_action_pressed("move_front"):
		dir-=transform.basis.z

	elif Input.is_action_pressed("move_back"):
		dir+=transform.basis.z
	elif Input.is_action_pressed("move_right"):
		dir+=transform.basis.x
	elif Input.is_action_pressed("move_left"):
		dir-=transform.basis.x

	velocity=dir.normalized()*SPEED
	h_velocity=h_velocity.lerp(dir*SPEED,h_accel*delta)
	velocity.z=h_velocity.z+gravity_vec.z
	velocity.x=h_velocity.x+gravity_vec.z
	velocity.y=gravity_vec.y

	move_and_slide()
