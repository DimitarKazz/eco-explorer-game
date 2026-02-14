extends CharacterBody3D

# Константи за движење
const SPEED = 5.0
const JUMP_VELOCITY = 10.0

# Гравитација
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Блокирај движење ако играта е завршена
	if GameManager.game_over or GameManager.victory:
		return
	
	# Гравитација
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Скокање
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Движење напред/назад и лево/десно
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
