extends Control

var dragging_node = null
var drag_offset : float = 0.0
var threshold = 100
@onready var hbox = get_parent()
var just_clicked : bool = false

func _ready():
	set_process_input(false)

func _process(_delta: float) -> void:
	if just_clicked:
		move_dragging_node()
		just_clicked = false

func _on_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("click"):
		dragging_node = self.duplicate()
		
		dragging_node.set_script(null)
		hbox.get_parent().add_child(dragging_node)
		dragging_node.global_position = global_position
		drag_offset = get_global_mouse_position().x - global_position.x
		var new_style = get_child(0).get_theme_stylebox("panel").duplicate()
		new_style.shadow_color.a = 0.3
		new_style.shadow_size = 8
		new_style.shadow_offset = Vector2(3,3)
		dragging_node.get_child(0).add_theme_stylebox_override("panel", new_style)
		
		var style : StyleBoxFlat= get_child(0).get_theme_stylebox("panel")
		style.border_color = Color.WHITE
		style.border_width_bottom = 5
		style.border_width_top = 5
		style.border_width_left = 5
		style.border_width_right = 5

		get_child(0).add_theme_stylebox_override("panel", style)
		just_clicked = true

		set_process_input(true)
		set_process(true)

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		move_dragging_node()
	
	if event.is_action_released("click"):
		modulate.a = 1.0
		var style : StyleBoxFlat= get_child(0).get_theme_stylebox("panel")
		style.border_color = Color.WHITE
		style.border_width_bottom = 0
		style.border_width_top = 0
		style.border_width_left = 0
		style.border_width_right = 0

		get_child(0).add_theme_stylebox_override("panel", style)
		if dragging_node: 
			dragging_node.queue_free()
		
		set_process_input(false)

func move_dragging_node() -> void:
	if not dragging_node:
		return
	dragging_node.global_position.x = get_global_mouse_position().x - drag_offset

	if dragging_node.global_position.x < global_position.x - threshold:
		if self.get_index() > 0:
			hbox.move_child(self, self.get_index() - 1)

	elif dragging_node.global_position.x > global_position.x + threshold:
		if self.get_index() < hbox.get_child_count() - 1:
			hbox.move_child(self, self.get_index() + 1)
