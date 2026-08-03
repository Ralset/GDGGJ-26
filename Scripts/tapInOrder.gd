extends minigame

@onready var HBox1 : HBoxContainer = $VBox/HB1
@onready var HBox2 : HBoxContainer = $VBox/HB2
@onready var styleboxnormal :   StyleBoxFlat = preload("res://Glodot/new_style_box_flat.tres")
@onready var styleboxhover :    StyleBoxFlat = preload("res://Glodot/button_hover.tres")
@onready var styleboxpress :    StyleBoxFlat = preload("res://Glodot/button_press.tres")
@onready var styleboxdisabled : StyleBoxFlat = preload("res://Glodot/button_disabled.tres")

const CHECK_ARRAY : Array[int] = [1, 2, 3, 4, 5, 6, 7, 8]

var button_array : Array[Button] = []
var DISPLAY_ARRAY : Array[int] = []
var current_idx : int = 0

func _start() -> void:
	_reset_variables()
	_create_buttons()

func _finish() -> void:
	for btn in button_array:
		btn.queue_free()


func _reset_variables() -> void:
	current_idx = 0
	button_array = []
	DISPLAY_ARRAY = CHECK_ARRAY.duplicate()
	DISPLAY_ARRAY.shuffle()


func _set_theme(btn : Button) -> void:
	btn.add_theme_font_size_override("font_size", 64)
	btn.add_theme_color_override("font_disabled_color", Color.GREEN)
	btn.add_theme_stylebox_override("normal", styleboxnormal)
	btn.add_theme_stylebox_override("pressed", styleboxpress)
	btn.add_theme_stylebox_override("hover", styleboxhover)
	btn.add_theme_stylebox_override("disabled", styleboxdisabled)


func _create_buttons() -> void:
	for i in range(8):
		var btn: Button = Button.new()
		_set_theme(btn)
		btn.text = " " + str(DISPLAY_ARRAY[i]) + " "
		btn.pressed.connect(func(): _on_button_pressed(DISPLAY_ARRAY[i], i))
		button_array.append(btn)
		
		if i < 4: HBox1.add_child(btn)
		else:     HBox2.add_child(btn)


func _on_button_pressed(num: int, index: int) -> void:
	button_array[index].disabled = true
	
	if current_idx + 1 == button_array.size():
		button_array[index].add_theme_color_override("font_color", Color.GREEN)
		finish(true)
		return
	
	if CHECK_ARRAY[current_idx] != num:
		for btn in button_array:
			btn.disabled = true
			var disabled_stylebox = btn.get_theme_stylebox("disabled").duplicate() as StyleBoxFlat
			disabled_stylebox.border_color = Color.RED
			btn.add_theme_color_override("font_disabled_color", Color.RED)
			btn.add_theme_stylebox_override("disabled", disabled_stylebox)
		finish(false)
		return
	current_idx += 1
