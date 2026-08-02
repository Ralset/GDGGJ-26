extends minigame

var finishedPanelStyle : StyleBoxFlat
@onready var hBox := $Panel/HBoxContainer

func _ready():
	#hBox.gameFinished.connect(_onGameFinished)
	finishedPanelStyle = $Panel.get_theme_stylebox("panel")
	finishedPanelStyle.border_color = Color(0,0,0,0)

func _start() -> void:
	hBox.gameFinished.connect(_onGameFinished)
	hBox.setup()

func _onGameFinished():
	finishedPanelStyle.border_color = Color.WHITE
	finish(true)
