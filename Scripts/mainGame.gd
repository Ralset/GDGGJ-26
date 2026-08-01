extends Node

signal finished()

@onready var SAFE_LOCK : TextureButton = $SafeLock

@export var SLOWNESS_FACTOR : float = 1

var toggled : bool = false
var finished_unwinding : bool = true
var target_number : int = 5

func _ready() -> void:
	SAFE_LOCK.rotation = 0
	start(randi_range(1,5))	#izbrisati posle

func start(target_number : int):
	self.target_number = target_number
	finished_unwinding = false
	SAFE_LOCK.disabled = true

func _process(delta: float) -> void:
	if !finished_unwinding:
		if SAFE_LOCK.rotation <= 0:
			finished_unwinding = true
			SAFE_LOCK.disabled = false
		SAFE_LOCK.rotation -= delta / SLOWNESS_FACTOR
		return
	
	print(SAFE_LOCK.rotation)
	SAFE_LOCK.rotation = max(0, SAFE_LOCK.rotation)
	if SAFE_LOCK.rotation >= target_number:
		SAFE_LOCK.rotation = target_number
		finished.emit()
		start(randi_range(1,5))
		
	if toggled and SAFE_LOCK.rotation < target_number :
		SAFE_LOCK.rotation += delta / SLOWNESS_FACTOR
	elif SAFE_LOCK.rotation > 0 and toggled == false:
		SAFE_LOCK.rotation -= delta / SLOWNESS_FACTOR
	

func _on_safe_lock_button_down() -> void:
	toggled = true


func _on_safe_lock_button_up() -> void:
	toggled = false
