extends KinematicBody
	
var direction = Vector3()
var velocity = Vector3()

var gravity = -27
var jump_height = 10
var walk_speed = 10
var fly = false

var view = {
	x=0,
	y=0,
	mouse_sensitivity = 0.3,
	camera = null,
	camera_angle = 0,
	camera_speed = 0.001,
	ray = null,
}

func _ready():
	view.camera = $Camera
	view.ray = $Camera/RayCast

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_mode = true
		get_tree().quit()
	elif event is InputEventMouseMotion:
		var change = deg2rad(-event.relative.y * view.mouse_sensitivity)
		view.x += deg2rad(-event.relative.x * view.mouse_sensitivity)
		if abs(view.y + change + view.camera_angle) < PI:
			view.y += change
			view.camera_angle += change
		view.camera.transform.basis = Basis()
		view.camera.rotate_object_local(Vector3(0,1,0),view.x)
		view.camera.rotate_object_local(Vector3(1,0,0),view.y)
	elif event is InputEventMouseButton:
		if Input.is_action_just_pressed("left_click") and view.ray.is_colliding():
			var aim = $Camera.get_global_transform().basis
			var c = (view.ray.get_collision_point() + -aim.z).floor()
			Game.remove_node(c)
			
		elif Input.is_action_just_pressed("right_click") and view.ray.is_colliding():
			var t = view.ray.get_collision_point().floor()
			Game.add_node(t)


func _physics_process(delta):
	direction = Vector3()
	var aim = $Camera.get_global_transform().basis
	if Input.is_key_pressed(KEY_W):
		direction -= aim.z
	if Input.is_key_pressed(KEY_S):
		direction += aim.z
	if Input.is_key_pressed(KEY_A):
		direction -= aim.x
	if Input.is_key_pressed(KEY_D):
		direction += aim.x
	if Input.is_action_just_pressed("fly_mode"):
		fly = fly == false
	direction = direction.normalized()
	
	if fly:
		transform.origin += direction*0.1
		return
	
	velocity.y += gravity * delta
	var tv = velocity
	tv = velocity.linear_interpolate(direction * walk_speed,6 * delta)
	velocity.x = tv.x
	velocity.z = tv.z
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	if is_on_floor() and Input.is_key_pressed(KEY_SPACE):
		velocity.y = jump_height
