extends HBoxContainer

signal gameFinished
var controls : Array[Control]
@export var gradientPanel : PackedScene
var numberOfTiles : int
var leftColor : Color
var rightColor : Color
func cleanup():
	for control in controls:
		control.queue_free()
	controls = []
	

func _process(_delta: float) -> void:
	for i in range(0, controls.size()):
		if controls[i] != get_child(i):
			return
	
	gameFinished.emit()
	await get_tree().create_timer(0.5).timeout
	cleanup()
	
func color_distance(a: Color, b: Color) -> float:
	return sqrt(pow(a.r - b.r, 2) + pow(a.g - b.g, 2) + pow(a.b - b.b, 2))

func setup():
	numberOfTiles = randi_range(4, 6)
	for i in range(numberOfTiles):
		var panel = gradientPanel.instantiate() as Control
		controls.append(panel)
		add_child(panel)
	
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
		
	for i in range(controls.size()):
		var panel = controls[i].get_child(0)
		var styleBox = panel.get_theme_stylebox("panel").duplicate()
		styleBox.set("bg_color", leftColor.lerp(rightColor, 1.0*i/(numberOfTiles-1)))
		print("setting color", leftColor.lerp(rightColor, 1.0*i/(numberOfTiles - 1)))
		panel.add_theme_stylebox_override("panel", styleBox)
	
	controls.front().set_script(null)
	controls.back().set_script(null)
	for i in range(get_child_count()-2, 0, -1):
		move_child(get_child(i), randi_range(1, i))
