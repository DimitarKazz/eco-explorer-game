extends Area3D

# Тип на предметот (за визуелна разновидност)
@export var item_type: String = "пластика"  # "пластика", "хемикалија", "отпад"

func _ready():
	# Поврзување на сигналот за детекција на играчот
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Проверка дали е играчот
	if body.is_in_group("player"):
		# Известување на GameManager дека предметот е собран
		GameManager.collect_item()
		
		# Уништување на предметот
		queue_free()
