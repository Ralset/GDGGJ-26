extends Control
class_name minigame

signal minigame_finished(passed : bool)

var in_progress : bool = false

func start() -> void:
	self.show()
	in_progress = true
	_start()

func finished() -> void:
	self.hide()
	in_progress = false
	_finished()

func _process(delta: float) -> void:
	if not in_progress:
		return
	process(delta)

func _input(event: InputEvent) -> void:
	if not in_progress:
		return
	input(event)

func input(event: InputEvent) -> void:
	pass

func process(delta: float) -> void:
	pass

func _start() -> void:
	assert(false, "You must implement method start()")

func _finished() -> void:
	assert(false, "You must implement method finished()")
