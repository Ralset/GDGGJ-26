extends HBoxContainer

signal gameFinished
var controls : Array[Control]
var numberOfTiles : int
var leftColor : Color
var rightColor : Color
func _process(_delta: float) -> void:
	for i in range(0, controls.size()):
		if controls[i] != get_child(i):
			return
	
	gameFinished.emit()
	
func color_distance(a: Color, b: Color) -> float:
	return sqrt(pow(a.r - b.r, 2) + pow(a.g - b.g, 2) + pow(a.b - b.b, 2))

func _ready():
	controls.append($Control)
	numberOfTiles = randi_range(4, 6)
	leftColor = Color(0.5 + randf()/2.0, 0.5 + randf()/2.0\
	, 0.5 + randf()/2.0)
	
	rightColor = leftColor.lerp(Color(0.5 + randf()/2.0, 0.5\
	 + randf()/2.0\
	, 0.5 + randf()/2.0), 0.5)
	
	var count = 0
	while color_distance(leftColor, rightColor) < 0.3 and count < 10:
		rightColor = leftColor.lerp(Color(0.3 + randf()/2.0, 0.3\
		 + randf()/2.0\
		, 0.3 + randf()/2.0), 0.5)
		print(color_distance(leftColor, rightColor))
		count += 1
	
	var panel = controls.back().get_child(0)
	var styleBox: StyleBoxFlat = panel.get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", leftColor)
	panel.add_theme_stylebox_override("panel", styleBox)
	while controls.size() < numberOfTiles:
		controls.append(controls.back().duplicate())
		add_child(controls.back())
		panel = controls.back().get_child(0)
		styleBox = panel.get_theme_stylebox("panel").duplicate()
		styleBox.set("bg_color", leftColor.lerp(rightColor, 1.0*controls.size()/numberOfTiles))
		panel.add_theme_stylebox_override("panel", styleBox)
	
	controls.front().set_script(null)
	controls.back().set_script(null)
	for i in range(get_child_count()-2, 0, -1):
		move_child(get_child(i), randi_range(1, i))
