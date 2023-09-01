extends Node2D

func _ready():
	$EndGame.button_down.connect(Callable(self, "_on_press_end"))

func _process(delta):
	pass

func _on_press_end():
	get_tree().change_scene_to_file("res://scene/game_over.tscn")

var incantation:String = ""

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			execute_incantation(incantation)
		update_incantation(event.keycode)
		$Mage/CenterContainer/Incantation.text = self.incantation

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
	cast_spell()

const SpellScene = preload("res://entity/spell.tscn")
func cast_spell():
	var spell = SpellScene.instantiate()
	spell.configure(Vector2(300, 200), null, 20)
	print_debug("SPAWN: spell/%s @ (%d, %d)" % [spell.get_instance_id(), spell.position.x, spell.position.y])
	self.add_child(spell)
