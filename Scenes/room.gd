extends Control

signal finishedMovement

func MoveToPhone():
	var tween := create_tween()
	tween.tween_property(self, "position", position + Vector2(400, 0), 0.75).\
	set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	finishedMovement.emit()

func MoveBack():
	var tween := create_tween()
	tween.tween_property(self, "position", position + Vector2(-400, 0), 0.75).\
	set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	finishedMovement.emit()
