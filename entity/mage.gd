extends Node2D

var incantation:String = ""

func _ready():
	pass

func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			execute_incantation(incantation)
		update_incantation(event.keycode)
		$CenterContainer/Incantation.text = self.incantation

func update_incantation(key:Key):
	if key == KEY_ENTER:
		self.incantation = ""
		return
	if key == KEY_BACKSPACE:
		var n = len(incantation)
		if n > 0:
			self.incantation = self.incantation.substr(0, n - 1)
		return

	var is_digit = KEY_0 <= key and key <= KEY_9
	var is_letter = KEY_A <= key and key <= KEY_Z
	var is_special_char = key == KEY_UNDERSCORE or key == KEY_QUESTION or key==KEY_EXCLAM
	var is_space = key == KEY_SPACE
	if !is_digit and !is_letter and !is_special_char and !is_space:
		return

	incantation += String.chr(key)

func execute_incantation(incantation:String):
	print_debug("EXECUTE: %s" % incantation)
