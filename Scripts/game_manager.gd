extends Node2D

@export var GAMES : Array[minigame]

func _ready() -> void:
	GAMES[0].start()
