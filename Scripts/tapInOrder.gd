extends minigame

@onready var HBox1 : HBoxContainer = $VBox/HB1
@onready var HBox2 : HBoxContainer = $VBox/HB2

@onready var styleboxnormal : StyleBoxFlat = preload("res://Glodot/new_style_box_flat.tres")
@onready var styleboxhover : StyleBoxFlat = preload("res://Glodot/button_hover.tres")
@onready var styleboxpress : StyleBoxFlat = preload("res://Glodot/button_press.tres")
@onready var styleboxdisabled : StyleBoxFlat = preload("res://Glodot/button_disabled.tres")

var CHECK_ARRAY : Array[int]  = []
var DISPLAY_ARRAY : Array[int]  = []
var x : int = 0

var button_array : Array[Button] = []

func createButtons() -> void:
	for i in range(8):
		var btn: Button = Button.new()
		btn.text = " " + str(DISPLAY_ARRAY[i]) + " "
		btn.add_theme_font_size_override("font_size", 64)
		btn.add_theme_color_override("font_disabled_color", Color.GREEN)
		btn.add_theme_stylebox_override("normal", styleboxnormal)
		btn.add_theme_stylebox_override("pressed", styleboxpress)
		btn.add_theme_stylebox_override("hover", styleboxhover)
		btn.add_theme_stylebox_override("disabled", styleboxdisabled)
		btn.pressed.connect(func(): _on_button_pressed(DISPLAY_ARRAY[i], i))
		
		if i < 4:
			HBox1.add_child(btn)
		else:
			HBox2.add_child(btn)
		
		button_array.append(btn)

func _on_button_pressed(num: int, index: int) -> void:
	button_array[index].disabled = true
	if x+1 == button_array.size():
		button_array[index].add_theme_color_override("font_color", Color.GREEN)
		finish(true)
		return
	if CHECK_ARRAY[x] != num:
		for btn in button_array:
			btn.disabled = true
			var disabled_stylebox = btn.get_theme_stylebox("disabled").duplicate() as StyleBoxFlat
			disabled_stylebox.border_color = Color.RED
			btn.add_theme_color_override("font_disabled_color", Color.RED)
			btn.add_theme_stylebox_override("disabled", disabled_stylebox)
		finish(false)
		return
	x += 1

func _finish() -> void:
	for btn in button_array:
		btn.queue_free()

func _start() -> void:
	x = 0
	button_array = []
	CHECK_ARRAY = []
	DISPLAY_ARRAY = []
	for i in range(8):
		CHECK_ARRAY.append(i + 1)

	DISPLAY_ARRAY = CHECK_ARRAY.duplicate()
	DISPLAY_ARRAY.shuffle()
	createButtons()
