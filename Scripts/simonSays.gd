extends minigame

@onready var WORD_DISPLAY : RichTextLabel = $DisplayLabel
@onready var ORDER_DISPLAY : RichTextLabel = $MarginContainer/OrderLabel

var gottenWord : String = ""
var simonSaid : bool
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
	var rndLetter = randi_range(97, 122)
	while char(rndLetter) == gottenWord: 
		rndLetter = randi_range(97, 122)
	
	gottenWord = char(rndLetter)
	order = ""
	if randi_range(1, 3) != 1:
		simonSaid = true
		order += "Simon says "
	else:
		simonSaid = false
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
	
	if (char(event.unicode) == gottenWord) == simonSaid:
		cnt += 1
		if cnt == NUM_OF_RUNS:
			WORD_DISPLAY.add_theme_color_override("default_color", Color.GREEN)
			ORDER_DISPLAY.add_theme_color_override("default_color", Color.GREEN)
			finish(true)
		else:
			WORD_DISPLAY.add_theme_color_override("default_color", Color.GREEN)
			ORDER_DISPLAY.add_theme_color_override("default_color", Color.GREEN)
			await get_tree().create_timer(0.25).timeout
			WORD_DISPLAY.add_theme_color_override("default_color", Color.WHITE)
			ORDER_DISPLAY.add_theme_color_override("default_color", Color.WHITE)
			genWord()
			setWord()
	else:
		WORD_DISPLAY.add_theme_color_override("default_color", Color.RED)
		ORDER_DISPLAY.add_theme_color_override("default_color", Color.RED)
		finish(false)
