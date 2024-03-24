extends Node3D

@export_group("Properties")
@export var target: CharacterBody3D

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120
@export var min_rotacao_x = -80
@export var max_rotacao_x = -10
@export var min = -80
@export var max = -10

var camera_rotation:Vector3
var cam:Vector3
var zoom = 10

@onready var camera = $Camera
@onready var joy: Node2D = $"../CanvasLayer/Control/VirtualJoystick"

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	cam = rotation_degrees
	
	pass

func _physics_process(delta):
	
	# Set position and rotation to targets
	
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	rotation_degrees = rotation_degrees.lerp(cam, delta * 6)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, min_rotacao_x, max_rotacao_x)
	
	# Zooming
	
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
	
var posicao_mouse: Vector2
	
func _input(event):
	if event is InputEventMouseMotion and joy.ongoing_drag:
		var movimento = event as InputEventMouseMotion
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			movimento_camera(movimento.relative)
			posicao_mouse =  movimento.position
			
func movimento_camera(move):
	var input0 := Vector2(move.y, move.x)
	cam.y -= input0.y * 0.5
	cam.x += input0.x * 0.5
	cam.x = clamp(cam.x,min, max)
