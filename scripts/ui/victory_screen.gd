extends CanvasLayer

@onready var panel = $Panel
@onready var restart_button = $Panel/VBoxContainer/RestartButton

func _ready():
	# Поврзување на сигнали
	GameManager.game_won.connect(_on_game_won)
	restart_button.pressed.connect(_on_restart_pressed)
	
	# Почетно скривање
	visible = false

func _on_game_won():
	visible = true

func _on_restart_pressed():
	GameManager.reset_game()
	get_tree().reload_current_scene()
