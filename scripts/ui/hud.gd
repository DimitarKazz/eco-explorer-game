extends CanvasLayer

@onready var collected_label = $Control/VBoxContainer/CollectedLabel
@onready var pollution_bar = $Control/VBoxContainer/PollutionBar
@onready var pollution_label = $Control/VBoxContainer/PollutionLabel
@onready var instructions_label = $Control/InstructionsLabel

func _ready():
	# Поврзување на сигнали од GameManager
	GameManager.item_collected.connect(_on_item_collected)
	GameManager.pollution_changed.connect(_on_pollution_changed)
	
	# Почетно ажурирање
	_on_item_collected(GameManager.collected_items, GameManager.total_items)
	_on_pollution_changed(GameManager.pollution_level)

func _on_item_collected(collected: int, total: int):
	collected_label.text = "Собрано: %d/%d" % [collected, total]

func _on_pollution_changed(value: float):
	pollution_bar.value = value
	pollution_label.text = "Загаденост: %d%%" % int(value)
