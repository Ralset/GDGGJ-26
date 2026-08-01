extends minigame

@onready var WORD_DISPLAY : RichTextLabel = $DisplayLabel

var gottenWord : String = ""
var PLAYER_INPUT : int
var cooked : bool = false
var symonSaid : bool

func _start() -> void:
	WORD_DISPLAY.bbcode_enabled = true
	genWord()
	setWord()

func _finished() -> void:
	minigame_finished.emit(!cooked)

func genWord() -> void:
	gottenWord = ""
	var rndLetter = randi_range(97, 122)
	gottenWord += char(rndLetter)
	var rnd : int = randi_range(1, 3)
	if rnd == 1 or rnd == 2:
		symonSaid = true
	else:
		symonSaid = false
	print(symonSaid)

func setWord() -> void:
	WORD_DISPLAY.text = gottenWord

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo() and !cooked:
		if event.unicode != 0:
			PLAYER_INPUT = event.unicode
			var typed_letter: String = char(PLAYER_INPUT)
			if (gottenWord == typed_letter and symonSaid) or (typed_letter == " " and symonSaid == false):
				genWord()
				setWord()
			else:
				var new : String = "[color=red]" + gottenWord + "[/color]"
				WORD_DISPLAY.text = new
				cooked = true
