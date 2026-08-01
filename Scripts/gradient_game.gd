extends HBoxContainer

var controls : Array[Control]
var numberOfTiles : int
var leftColor : Color
var rightColor : Color
func _process(_delta: float) -> void:
	for i in range(0, controls.size()):
		if controls[i] != get_child(i):
			return
	

func _ready():
	controls.append($Control)
	numberOfTiles = randi_range(4, 6)
	leftColor = Color(0.5 + randf()/2.0, 0.5 + randf()/2.0\
	, 0.5 + randf()/2.0)
	
	rightColor = leftColor.blend(Color(0.5 + randf()/2.0, 0.5\
	 + randf()/2.0\
	, 0.5 + randf()/2.0, 0.7))
	
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
	
	for i in range(get_child_count()-2, 0, -1):
		move_child(get_child(i), randi_range(1, i))
