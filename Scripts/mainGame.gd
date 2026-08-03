extends Node

signal finished()

@export var UNWINDING : float = 20
@export var WINDING : float = 2.5
@export var RESET : float = 0.5

@onready var SAFE_LOCK : TextureButton = $SafeLock
@onready var ROTATING_THING : TextureRect = $SafeLock/rotaryshit

var toggled : bool = false
var finished_unwinding : bool = true
var target_number : int

func start(num : int) -> void:
	target_number = num
	print("START sa ", target_number)
	finished_unwinding = false
	SAFE_LOCK.disabled = true

func out_of_focus() -> void:
	toggled = false
	SAFE_LOCK.disabled = true

func in_focus() -> void:
	if finished_unwinding:
		SAFE_LOCK.disabled = false

func _process(delta: float) -> void:
	if !finished_unwinding:
		if ROTATING_THING.rotation <= 0:
			finished_unwinding = true
			SAFE_LOCK.disabled = false
		ROTATING_THING.rotation -= delta / RESET
		ROTATING_THING.rotation = max(0, ROTATING_THING.rotation)
		return
	
	if ROTATING_THING.rotation >= target_number:
		ROTATING_THING.rotation = target_number
		finished_unwinding = false
		finished.emit()
		return
	
	if toggled and ROTATING_THING.rotation < target_number :
		ROTATING_THING.rotation += delta / WINDING
	elif ROTATING_THING.rotation > 0 and toggled == false:
		ROTATING_THING.rotation -= delta / UNWINDING
	
	ROTATING_THING.rotation = max(0, ROTATING_THING.rotation)

func _on_safe_lock_button_down() -> void: toggled = true
func _on_safe_lock_button_up() -> void:   toggled = false
