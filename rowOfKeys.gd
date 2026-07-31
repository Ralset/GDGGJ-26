extends Node

@onready var WORD_DISPLAY : RichTextLabel = $Label

var WORD_ARRAY : String = ""
var CHECK_ARRAY : String = ""
var PLAYER_INPUT : int
var x : int = 0
var cooked : bool = false
var passed : bool = false

func _ready() -> void:
	WORD_DISPLAY.bbcode_enabled = true
	for i in range(5):
		var c = randi_range(97, 122)
		WORD_ARRAY += char(c) + " "
		CHECK_ARRAY += char(c)
	WORD_ARRAY[WORD_ARRAY.length() - 1] = ""
	WORD_DISPLAY.text = WORD_ARRAY

func _process(delta: float) -> void:
	if passed:
		print("ez") #ovde signal
		passed = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo() and !cooked:
		if event.unicode != 0:
			PLAYER_INPUT = event.unicode
			var typed_letter: String = char(PLAYER_INPUT)
			
			if x < CHECK_ARRAY.length():
				if CHECK_ARRAY[x] == typed_letter:
					var new = ""
					for i in range(CHECK_ARRAY.length()):
						if i <= x:
							new += "[color=green]" + CHECK_ARRAY[i] + "[/color] "
						else:
							new += CHECK_ARRAY[i] + " "
					WORD_DISPLAY.text = new
					x += 1
				else:
					var new = ""
					x = 0
					for i in range(CHECK_ARRAY.length()):
						if i <= x:
							new += "[color=red]" + CHECK_ARRAY[i] + "[/color] "
						else:
							new += CHECK_ARRAY[i] + " "
						x += 1
					WORD_DISPLAY.text = new
					cooked = true
			else:
				cooked = true
				passed = true
