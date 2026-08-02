extends Node

signal finished()

@onready var SAFE_LOCK : TextureButton = $SafeLock
@onready var GLIBA : TextureRect = $SafeLock/rotaryshit

@export var UNWINDING : float = 20
@export var WINDING : float = 2.5
@export var RESET : float = 0.5

var toggled : bool = false
var finished_unwinding : bool = true
var target_number : int

func _ready() -> void:
	GLIBA.rotation = 0

func start(num : int):
	target_number = num
	print("START sa ", target_number)
	finished_unwinding = false
	SAFE_LOCK.disabled = true

func _process(delta: float) -> void:
	if !finished_unwinding:
		if GLIBA.rotation <= 0:
			finished_unwinding = true
			SAFE_LOCK.disabled = false
		GLIBA.rotation -= delta / RESET
		return
	
	GLIBA.rotation = max(0, GLIBA.rotation)
	if GLIBA.rotation >= target_number:
		GLIBA.rotation = target_number
		finished.emit()
		return
	
	if toggled and GLIBA.rotation < target_number :
		GLIBA.rotation += delta / WINDING
	elif GLIBA.rotation > 0 and toggled == false:
		GLIBA.rotation -= delta / UNWINDING
	

func _on_safe_lock_button_down() -> void:
	toggled = true


func _on_safe_lock_button_up() -> void:
	toggled = false
