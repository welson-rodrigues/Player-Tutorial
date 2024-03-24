extends CharacterBody3D


const SPEED = 200.0
const JUMP_VELOCITY = 10.0
@onready var animacao = get_node("gdbot/AnimationPlayer") as AnimationPlayer

@export var view : Node3D
var gravity = 0
var input_dir: Vector2
var movimento_eixo : Vector3
var direcao_rotacao : float


func _physics_process(delta):
	entrada_teclado(delta)
	entrada_animacao()
	gravidade(delta)
	var aplicar_velocidade : Vector3
	aplicar_velocidade = velocity.lerp(movimento_eixo, delta * 10)
	aplicar_velocidade.y = -gravity
	velocity = aplicar_velocidade
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	##var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		direcao_rotacao = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, direcao_rotacao, delta * 10)
	

func entrada_teclado(delta):
	var input := Vector3.ZERO
	input.x = input_dir.x
	input.z = input_dir.y
	
	input = input.rotated(Vector3.UP,view.rotation.y).normalized()
	
	velocity = input * SPEED * delta
	
func entrada_animacao():
	if abs(velocity.x) > 1 or abs(velocity.z) > 1:
		animacao.play("run", 0.3)
	else:
		animacao.play("Idle", 0.3)
		
func gravidade(delta):
	if not is_on_floor():
		gravity += 25 * delta
		
func pulo(delta):
	pass

func _on_virtual_joystick_analogic_chage(move: Vector2):
	input_dir = move
