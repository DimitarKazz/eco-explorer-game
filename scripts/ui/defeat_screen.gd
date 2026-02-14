extends CanvasLayer

@onready var panel = $Panel
@onready var restart_button = $Panel/VBoxContainer/RestartButton

func _ready():
	# Поврзување на сигнали
	if not GameManager.game_lost.is_connected(_on_game_lost):
		GameManager.game_lost.connect(_on_game_lost)
	if not restart_button.pressed.is_connected(_on_restart_pressed):
		restart_button.pressed.connect(_on_restart_pressed)
	
	# Почетно скривање
	visible = false

func _on_game_lost():
	visible = true

func _on_restart_pressed():
	GameManager.reset_game()
	get_tree().reload_current_scene()
