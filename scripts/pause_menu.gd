extends CanvasLayer

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func pause():
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().quit()
