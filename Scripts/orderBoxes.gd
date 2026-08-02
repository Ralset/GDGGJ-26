extends minigame

@onready var BUTTON_ARRAY : Array[Button] = [$HBox/b1, $HBox/b2, $HBox/b3, $HBox/b4, $HBox/b5]
@onready var ORDER_LABEL : RichTextLabel = $MarginContainer/OrderLabel

const LtoR : String = "ORDER\nLEFT-TO-RIGHT"
const RtoL : String = "ORDER\nRIGHT-TO-LEFT"

var CHECK_ARRAY : Array[int]
var CURRENT_ARRAY : Array[int]
var btn_id : Array[int]
var button_clicked : int

func _ready() -> void:
	for btn in BUTTON_ARRAY:
		btn.add_theme_color_override("font_disabled_color", Color.GREEN)

func _start() -> void:
	_rest_game_state()
	if randi_range(0,1):
		ORDER_LABEL.text = LtoR
	else:
		ORDER_LABEL.text = RtoL
		CHECK_ARRAY.reverse()
	CURRENT_ARRAY = CHECK_ARRAY.duplicate()
	CURRENT_ARRAY.shuffle()
	_set_box_text()

func _rest_game_state():
	for btn in BUTTON_ARRAY:
		btn.disabled = false
	btn_id = [-1, -1]
	button_clicked = 0
	CHECK_ARRAY = [1,2,3,4,5]
	CURRENT_ARRAY = []

func _on_button_click(id: int) -> void:
	btn_id[button_clicked] = id
	button_clicked += 1
	
	if button_clicked == 2:
		var tmp = CURRENT_ARRAY[btn_id[0]]
		CURRENT_ARRAY[btn_id[0]] = CURRENT_ARRAY[btn_id[1]]
		CURRENT_ARRAY[btn_id[1]] = tmp
		button_clicked = 0
		_set_box_text()
	
	if CHECK_ARRAY == CURRENT_ARRAY:
		for btn in BUTTON_ARRAY:
			btn.disabled = true
		finish(true)

func _set_box_text() -> void:
	for i in range(5):
		BUTTON_ARRAY[i].text = " " + str(CURRENT_ARRAY[i]) + " "

func _on_b_1_pressed() -> void: _on_button_click(0)
func _on_b_2_pressed() -> void: _on_button_click(1)
func _on_b_3_pressed() -> void: _on_button_click(2)
func _on_b_4_pressed() -> void: _on_button_click(3)
func _on_b_5_pressed() -> void: _on_button_click(4)
