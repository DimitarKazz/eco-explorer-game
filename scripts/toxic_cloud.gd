extends Area3D

@export var move_speed: float = 1.0
@export var move_distance: float = 5.0
@export var move_horizontal: bool = true  # true за хоризонтално, false за вертикално

var start_position: Vector3
var time_passed: float = 0.0

func _ready():
	start_position = global_position
	body_entered.connect(_on_body_entered)

func _process(delta):
	time_passed += delta
	
	# Движење напред-назад
	var offset = sin(time_passed * move_speed) * move_distance
	
	if move_horizontal:
		global_position = start_position + Vector3(offset, 0, 0)
	else:
		global_position = start_position + Vector3(0, 0, offset)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Зголемување на загаденоста при допир со облак
		GameManager.increase_pollution_by_cloud()
