extends Control

@export var GAMES : Array[minigame]
@export var num_of_games : int = 5

@onready var attention_bar : ProgressBar = $Overlay/ProgressBar
@onready var room : Control = $Room
var attention : float
var cognitive_decline : float = 10
var current_game_id : int
var games_passed : int

var MINIGAME_STATE : bool = false

signal begunMinigame

func _ready() -> void:
	attention = 100
	MINIGAME_STATE = false

func _process(delta: float) -> void:
	if MINIGAME_STATE:
		return
	
	if attention == 0:
		attention = 100
		MINIGAME_STATE = true
		games_passed = 0
		room.MoveToPhone()
		await room.finishedMovement
		minigame_cycle()
	else:
		attention -= delta * cognitive_decline
	attention = maxf(0, attention)
	attention_bar.value = attention

func minigame_cycle():
	if games_passed == num_of_games:
		MINIGAME_STATE = false
		room.MoveBack()
		await room.finishedMovement
	else:
		start_new_game()

func start_new_game() -> void:
	var new_game_pick = randi_range(0, GAMES.size() - 1)
	while new_game_pick == current_game_id:
		new_game_pick = randi_range(0, GAMES.size() - 1)
		
	current_game_id = new_game_pick
	
	GAMES[current_game_id].connect("minigame_finished", _on_minigame_finished)
	GAMES[current_game_id].start()

func restart_game() -> void:
	GAMES[current_game_id].start()

func _on_minigame_finished(passed : bool) -> void:
	if passed:
		games_passed += 1
		GAMES[current_game_id].disconnect("minigame_finished", _on_minigame_finished)
		minigame_cycle()
	else:
		restart_game()
