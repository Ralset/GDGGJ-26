extends Node

signal finished()

@onready var SAFE_LOCK : TextureButton = $SafeLock
@onready var GLIBA : TextureRect = $SafeLock/rotaryshit

@export var SLOWNESS_FACTOR : float = 1

var toggled : bool = false
var finished_unwinding : bool = true
var target_number : int = 5

func _ready() -> void:
	GLIBA.rotation = 0

func start(target_number : int):
	self.target_number = target_number
	finished_unwinding = false
	GLIBA.disabled = true

func _process(delta: float) -> void:
	if !finished_unwinding:
		if GLIBA.rotation <= 0:
			finished_unwinding = true
			GLIBA.disabled = false
		GLIBA.rotation -= delta / SLOWNESS_FACTOR
		return
	
	GLIBA.rotation = max(0, GLIBA.rotation)
	if GLIBA.rotation >= target_number:
		GLIBA.rotation = target_number
		finished.emit()
		return
	
	if toggled and GLIBA.rotation < target_number :
		GLIBA.rotation += delta / SLOWNESS_FACTOR
	elif GLIBA.rotation > 0 and toggled == false:
		GLIBA.rotation -= delta / SLOWNESS_FACTOR
	

func _on_safe_lock_button_down() -> void:
	toggled = true


func _on_safe_lock_button_up() -> void:
	toggled = false
