extends Area3D

var player_nearby: bool = false
@onready var label: Label3D = $Label3D

func _ready():
	# Поврзување на сигнали
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	
	# Почетно скривање на лабелата
	if label:
		label.visible = false

func _process(_delta):
	# Проверка за активација
	if player_nearby and Input.is_action_just_pressed("activate"):
		if GameManager.can_activate_station():
			GameManager.activate_station()
	
	# Ажурирање на видливост на лабелата
	if label:
		if player_nearby and GameManager.can_activate_station():
			label.visible = true
		else:
			label.visible = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
