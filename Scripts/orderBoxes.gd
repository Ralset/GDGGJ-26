extends Node

@onready var BUTTON_ARRAY : Array[Button] = [$HBox/b1, $HBox/b2, $HBox/b3, $HBox/b4, $HBox/b5]
@onready var ORDER_LABEL : RichTextLabel = $MarginContainer/OrderLabel

var CHECK_ARRAY : Array[int] = [1,2,3,4,5]
var CURRENT_ARRAY : Array[int] = []
var LtoR : String = "ORDER\nLEFT-TO-RIGHT"
var RtoL : String = "ORDER\nRIGHT-TO-LEFT"

var button_clicked : int
var x1 : int
var x2 : int
var done : bool = false

func setBoxText() -> void:
	for i in range(5):
		BUTTON_ARRAY[i].text = str(CURRENT_ARRAY[i])

func _ready() -> void:
	var rnd = randi_range(1,2)
	if rnd == 1:
		ORDER_LABEL.text = LtoR
	else:
		ORDER_LABEL.text = RtoL
		CHECK_ARRAY.reverse()
	button_clicked = 0
	CURRENT_ARRAY = CHECK_ARRAY.duplicate()
	CURRENT_ARRAY.shuffle()
	print(CURRENT_ARRAY)
	setBoxText()

func _process(delta: float) -> void:
	if !done:
		if button_clicked == 2:
			var tmp = CURRENT_ARRAY[x1]
			CURRENT_ARRAY[x1] = CURRENT_ARRAY[x2]
			CURRENT_ARRAY[x2] = tmp
			setBoxText()
			button_clicked = 0
			print(CURRENT_ARRAY)
			
		if CHECK_ARRAY == CURRENT_ARRAY:
			for btn in BUTTON_ARRAY:
				btn.add_theme_color_override("font_color", Color.GREEN)
				done = true

func _on_b_1_pressed() -> void:
	if button_clicked == 0:
		x1 = 0
	else:
		x2 = 0
	button_clicked = button_clicked + 1

func _on_b_2_pressed() -> void:
	if button_clicked == 0:
		x1 = 1
	else:
		x2 = 1
	button_clicked = button_clicked + 1


func _on_b_3_pressed() -> void:
	if button_clicked == 0:
		x1 = 2
	else:
		x2 = 2
	button_clicked = button_clicked + 1


func _on_b_4_pressed() -> void:
	if button_clicked == 0:
		x1 = 3
	else:
		x2 = 3
	button_clicked = button_clicked + 1


func _on_b_5_pressed() -> void:
	if button_clicked == 0:
		x1 = 4
	else:
		x2 = 4
	button_clicked = button_clicked + 1
