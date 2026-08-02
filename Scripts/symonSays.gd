extends minigame

@onready var WORD_DISPLAY : RichTextLabel = $DisplayLabel
@onready var ORDER_DISPLAY : RichTextLabel = $MarginContainer/OrderLabel

var gottenWord : String = ""
var symonSaid : bool
var order : String = ""
var cnt : int = 0
const NUM_OF_RUNS : int = 5

func _start() -> void:
	cnt = 0
	WORD_DISPLAY.add_theme_color_override("default_color", Color.WHITE)
	ORDER_DISPLAY.add_theme_color_override("default_color", Color.WHITE)
	WORD_DISPLAY.bbcode_enabled = true
	genWord()
	setWord()

func genWord() -> void:
	gottenWord = ""
	order = ""
	var rndLetter = randi_range(97, 122)
	gottenWord += char(rndLetter)
	var rnd : int = randi_range(1, 3)
	if rnd == 1 or rnd == 2:
		symonSaid = true
		order += "Simon says "
	else:
		symonSaid = false
	order += "Click: \"" + gottenWord.to_upper() + "\""
	ORDER_DISPLAY.text = order

func setWord() -> void:
	WORD_DISPLAY.text = gottenWord.to_upper()

func input(event: InputEvent) -> void:
	if event is not InputEventKey: 
		return
	if not event.pressed:          
		return
	if event.is_echo():            
		return
	if event.unicode == 0:
		return
	
	var typed_letter: String = char(event.unicode)
	if (gottenWord == typed_letter and symonSaid) or (typed_letter == " " and symonSaid == false):
		cnt += 1
		if cnt == NUM_OF_RUNS:
			WORD_DISPLAY.add_theme_color_override("default_color", Color.GREEN)
			ORDER_DISPLAY.add_theme_color_override("default_color", Color.GREEN)
			finish(true)
		else:
			genWord()
			setWord()
	else:
			WORD_DISPLAY.add_theme_color_override("default_color", Color.RED)
			ORDER_DISPLAY.add_theme_color_override("default_color", Color.RED)
			finish(false)
