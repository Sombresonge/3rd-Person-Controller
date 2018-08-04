extends Spatial

export(NodePath) var PlayerPath  = ""
export(float) var MovementSpeed = 10
export(float) var Acceleration = 3
export(float) var MouseSensitivity = 2
export(float) var RotationLimit = 45
export(float) var MaxZoom = 0.5
export(float) var MinZoom = 1.5
export(float) var ZoomSpeed = 2
var Player
var InnerGimbal
var Direction = Vector3()
var Rotation = Vector2()
var gravity = Vector3(0,-10,0)
var Movement = Vector3()
var ZoomFactor = 1
var ActualZoom = 1
var Speed = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Player = get_node(PlayerPath)
	InnerGimbal =  $InnerGimbal
	pass

func _unhandled_input(event):
	
	if event is InputEventMouseMotion :
		Rotation = event.relative
	
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				ZoomFactor -= 0.05
			BUTTON_WHEEL_DOWN:
				ZoomFactor += 0.05
		ZoomFactor = clamp(ZoomFactor, MaxZoom, MinZoom)

	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_Z:
				Direction.z -= 1
			KEY_S:
				Direction.z += 1
			KEY_Q:
				Direction.x -= 1
			KEY_D:
				Direction.x += 1
	if event is InputEventKey and not event.pressed:
		match event.scancode:
			KEY_Z:
				Direction.z += 1
			KEY_S:
				Direction.z -= 1
			KEY_Q:
				Direction.x += 1
			KEY_D:
				Direction.x -= 1
	Direction.z = clamp(Direction.z, -1,1)
	Direction.x = clamp(Direction.x, -1,1)

func _physics_process(delta):
	#Rotation
	Player.rotate_y(deg2rad(-Rotation.x)*delta*MouseSensitivity)
	InnerGimbal.rotate_x(deg2rad(-Rotation.y)*delta*MouseSensitivity)
	InnerGimbal.rotation_degrees.x = clamp(InnerGimbal.rotation_degrees.x, -RotationLimit, RotationLimit)
	Rotation = Vector2()
	
	#Movement
	var MaxSpeed = MovementSpeed *Direction.normalized()
	Speed = Speed.linear_interpolate(MaxSpeed, delta * Acceleration)
	Movement = Player.transform.basis * (Speed)
	Movement += gravity
	Player.move_and_slide(Movement,Vector3(0,1,0))
	
	#Zoom
	ActualZoom = lerp(ActualZoom, ZoomFactor, delta * ZoomSpeed)
	InnerGimbal.set_scale(Vector3(ActualZoom,ActualZoom,ActualZoom))
