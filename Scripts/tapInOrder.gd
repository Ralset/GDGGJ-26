extends minigame

@onready var HBox1 : HBoxContainer = $VBox/HB1
@onready var HBox2 : HBoxContainer = $VBox/HB2

var CHECK_ARRAY : Array[int]  = []
var DISPLAY_ARRAY : Array[int]  = []
var x : int = 0

var button_array : Array[Button] = []

func createButtons() -> void:
	for i in range(8):
		var btn: Button = Button.new()
		btn.text = str(DISPLAY_ARRAY[i])
		btn.add_theme_font_size_override("font_size", 48)
		btn.pressed.connect(func(): _on_button_pressed(DISPLAY_ARRAY[i], i))
		
		if i < 4:
			HBox1.add_child(btn)
		else:
			HBox2.add_child(btn)
		
		button_array.append(btn)

func _on_button_pressed(num: int, index: int) -> void:
	if x+1 == button_array.size():
		button_array[index].add_theme_color_override("font_color", Color.GREEN)
		_on_game_finish(true)
		return
	if CHECK_ARRAY[x] != num:
		for btn in button_array:
			btn.add_theme_color_override("font_color", Color.RED)
		_on_game_finish(false)
		return
	x += 1
	button_array[index].add_theme_color_override("font_color", Color.GREEN)

func _on_game_finish(passed : bool) -> void:
	for btn in button_array:
		btn.queue_free()
	finish(passed)

func _start() -> void:
	x = 0
	button_array = []
	CHECK_ARRAY = []
	DISPLAY_ARRAY = []
	for i in range(8):
		CHECK_ARRAY.append(i + 1)
	
	print(CHECK_ARRAY)
	DISPLAY_ARRAY = CHECK_ARRAY.duplicate()
	DISPLAY_ARRAY.shuffle()
	createButtons()
