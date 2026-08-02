extends Control

signal finishedMovement

@export var pomeri : Vector2 = Vector2(800, 0)
func MoveToPhone():
	var tween := create_tween()
	tween.tween_property(self, "position", position + pomeri, 0.75).\
	set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	finishedMovement.emit()

func MoveBack():
	var tween := create_tween()
	tween.tween_property(self, "position", position - pomeri, 0.75).\
	set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	finishedMovement.emit()
