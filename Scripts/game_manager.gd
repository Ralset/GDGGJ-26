extends Control

@export var GAMES : Array[minigame]

var current_game_id : int

func _ready() -> void:
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
		GAMES[current_game_id].disconnect("minigame_finished", _on_minigame_finished)
		start_new_game()
	else:
		restart_game()
