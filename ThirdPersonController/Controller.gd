extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(NodePath) var PlayerPath  = ""
export(float) var MovementSpeed = 10
export var MouseSensitivity = 2


var Player
var InnerGimbal
var Direction = Vector3()
var Rotation = Vector2()
var gravity = Vector3(0,-10,0)
var Movement = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Player = get_node(PlayerPath)
	InnerGimbal =  $InnerGimbal
	pass

func _input(event):
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_pressed("move_forward"):
		Direction.z =-1
	elif Input.is_action_pressed("move_backward"):
		Direction.z =1
	elif Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backward"):
		Direction.z = 0
		
	if Input.is_action_pressed("stafe_left"):
		Direction.x =-1
	elif Input.is_action_pressed("stafe_right"):
		Direction.x =1
	elif Input.is_action_just_released("stafe_left") or Input.is_action_just_released("stafe_right"):
		Direction.x=0
	
	if event is InputEventMouseMotion :
		Rotation = event.relative
	else:
	 	Rotation = Vector2()

func _physics_process(delta):
	Player.rotate_y(deg2rad(-Rotation.x)*delta*MouseSensitivity)
	InnerGimbal.rotate_x(deg2rad(-Rotation.y)*delta*MouseSensitivity)
	
	Movement = Player.transform.basis * (MovementSpeed * Direction.normalized())
	Movement += gravity 
	
	Player.move_and_slide(Movement,Vector3(0,1,0))
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
