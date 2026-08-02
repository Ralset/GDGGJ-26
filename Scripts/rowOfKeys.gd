extends minigame

@onready var WORD_DISPLAY : RichTextLabel = $DisplayLabel

var WORD_ARRAY : String
var CHECK_ARRAY : String
var x : int

func _start() -> void:
	WORD_ARRAY = ""
	CHECK_ARRAY = ""
	x = 0
	WORD_DISPLAY.bbcode_enabled = true
	for i in range(5):
		var c = randi_range(97, 122)
		WORD_ARRAY += char(c).to_upper() + " "
		CHECK_ARRAY += char(c)
	WORD_ARRAY[WORD_ARRAY.length() - 1] = ""
	WORD_DISPLAY.text = WORD_ARRAY

func input(event: InputEvent) -> void:
	print(x)
	if event is not InputEventKey: 
		return
	if not event.pressed:          
		return
	if event.is_echo():            
		return
	if event.unicode == 0:
		return
	
	var typed_letter: String = char(event.unicode)
	
	if CHECK_ARRAY[x] == typed_letter:
		var new = ""
		for i in range(CHECK_ARRAY.length()):
			if i <= x:
				new += "[color=green]" + CHECK_ARRAY[i].to_upper() + "[/color] "
			else:
				new += CHECK_ARRAY[i].to_upper() + " "
		WORD_DISPLAY.text = new
		x += 1
		if x == CHECK_ARRAY.length():
			finish(true)
	else:
		var new = ""
		for i in range(CHECK_ARRAY.length()):
			if i <= x:
				new += "[color=red]" + CHECK_ARRAY[i].to_upper() + "[/color] "
			else:
				new += CHECK_ARRAY[i].to_upper() + " "
			x += 1
		WORD_DISPLAY.text = new
		finish(false)
