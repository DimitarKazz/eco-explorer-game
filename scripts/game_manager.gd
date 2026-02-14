extends Node

# Глобални променливи за состојба на играта
var pollution_level: float = 0.0
var collected_items: int = 0
var total_items: int = 0
var game_over: bool = false
var victory: bool = false

# Константи
const POLLUTION_INCREASE_RATE = 5.0  # процент по секунда
const MAX_POLLUTION = 100.0
const TOXIC_CLOUD_PENALTY = 15.0  # Колку се зголемува загаденоста при допир со токсичен облак

# Сигнали за комуникација со UI и други компоненти
signal pollution_changed(new_value)
signal item_collected(collected, total)
signal game_won
signal game_lost

func _ready():
	pass

func _process(delta):
	if game_over or victory:
		return
	
	# Зголемување на загаденост со текот на времето
	pollution_level += POLLUTION_INCREASE_RATE * delta
	pollution_level = clamp(pollution_level, 0.0, MAX_POLLUTION)
	
	emit_signal("pollution_changed", pollution_level)
	
	# Проверка за пораз (загаденост над максимум)
	if pollution_level >= MAX_POLLUTION:
		trigger_defeat()

func collect_item():
	"""Се повикува кога играчот собере предмет"""
	collected_items += 1
	emit_signal("item_collected", collected_items, total_items)

func increase_pollution_by_cloud():
	"""Се повикува кога играчот удри во токсичен облак"""
	pollution_level += TOXIC_CLOUD_PENALTY
	pollution_level = clamp(pollution_level, 0.0, MAX_POLLUTION)
	emit_signal("pollution_changed", pollution_level)

func can_activate_station() -> bool:
	"""Проверува дали може да се активира станицата"""
	return collected_items >= total_items

func activate_station():
	"""Се повикува кога играчот ја активира станицата"""
	if can_activate_station():
		trigger_victory()

func trigger_victory():
	"""Победа - езерото е спасено"""
	victory = true
	game_over = true
	emit_signal("game_won")

func trigger_defeat():
	"""Пораз - преголемо загадување"""
	game_over = true
	emit_signal("game_lost")

func reset_game():
	"""Ресетирање на играта за нова игра"""
	pollution_level = 0.0
	collected_items = 0
	game_over = false
	victory = false
	# Не го ресетираме total_items бидејќи тоа се поставува од сцената
