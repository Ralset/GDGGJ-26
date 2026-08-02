extends Control

@export var GAMES : Array[minigame]
@export var num_of_games : int = 5
@export var LOCK_CNT : int = 5
@export var LOCKS_DONE : int = 0
@export var cognitive_decline : Array[float] = [10, 12, 14, 16, 20]
#@export var DIFFICULTY : int = 12

@onready var attention_bar : ProgressBar = $Overlay/ProgressBar
@onready var room : Control = $Room
@onready var mainGame : Control = $Room/MainGame
@onready var lockCounter : RichTextLabel = $Overlay/LockPickedCounter
@onready var timer : Timer = $TimeLeft
@onready var timerDisplay : Label = $Overlay/TimerDisplay
@onready var vignete = $Overlay/TextureRect
@onready var flight = $Overlay/Path2D/PathFollow2D
@onready var bars = $Overlay/bars 

@onready var safedoor = $Overlay/safedoor
@onready var opensafe = $Overlay/opensafe
@onready var miniflight = $Overlay/miniflight
var attention : float
var current_game_id : int
var games_passed : int
var combination : Array[int]
var number_idx : int


var MINIGAME_STATE : bool = false


func _ready() -> void:
	lockCounter.text = str(LOCKS_DONE) + " / " + str(LOCK_CNT)
	attention = 100
	_generate_combination()
	mainGame.connect("finished", _on_found_number)
	number_idx = 0
	_next_number()
	MINIGAME_STATE = false

func _process(delta: float) -> void:
	timerDisplay.text = str(ceil(timer.time_left))
	if timer.time_left == 0:
		return
	
	if LOCKS_DONE == LOCK_CNT:
		return
	
	if MINIGAME_STATE:
		return
	
	if attention == 0:
		attention = 100
		MINIGAME_STATE = true
		games_passed = 0
		mainGame.out_of_focus()
		room.MoveToPhone()
		await room.finishedMovement
		minigame_cycle()
	else:
		attention -= delta * cognitive_decline[number_idx]
	attention = maxf(0, attention)
	#attention_bar.value = attention
	if not MINIGAME_STATE:
		vignete.modulate.a = 1 - (attention/100.0)
		vignete.modulate.a = minf(0.90, vignete.modulate.a)

func _generate_combination() -> void:
	#var sum : int = DIFFICULTY
	#var num = randi_range(1, 5)
	for i in range(LOCK_CNT):
		combination.append(randi_range(1, 5))

func _next_number() -> void:
	mainGame.start(combination[number_idx])

func _on_win():
	timer.stop()
	safedoor.show()
	opensafe.show()
	miniflight.show()
	var twin = create_tween()
	twin.tween_property(safedoor, "position:x", 450, 2.0)
	await twin.finished
	
	var been = create_tween()
	been.tween_property(miniflight, "scale", Vector2(2.0, 2.0), 0.75).set_trans(Tween.TRANS_EXPO)
	await been.finished
	var seen = create_tween()
	seen.tween_property(bars, "position:y", 349.305, 2.5)

func _on_found_number() -> void:
	number_idx += 1
	LOCKS_DONE += 1
	lockCounter.text = str(LOCKS_DONE) + " / " + str(LOCK_CNT)
	if number_idx >= LOCK_CNT:
		_on_win()
	else:
		_next_number()



func minigame_cycle():
	var vignetetween := create_tween()
	vignetetween.tween_property(vignete, "modulate:a", 0.0, 0.2)
	if games_passed == num_of_games:
		MINIGAME_STATE = false
		mainGame.in_focus()
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


func _on_time_left_timeout() -> void:
	timer.stop()
	vignete.modulate.a = 0
	flight.show()
	var tween = create_tween()
	tween.tween_property(flight, "progress_ratio", 1.0, 1.5).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	var seen = create_tween()
	seen.tween_property(bars, "position:y", 349.305, 2.5)
