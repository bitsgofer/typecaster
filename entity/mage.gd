extends Node2D

@export var HP:int=1
@export var MP:int=1000

var incantation = "" # Current incantation

func _ready():
	pass

func _process(delta):
	pass

func update_incantation(key:Key):
	if key == KEY_ENTER:
		self.incantation = ""
		return

	if key == KEY_BACKSPACE:
		var n = len(incantation)
		if n > 0:
			self.incantation = self.incantation.substr(0, n - 1)

		# TODO: penalty for bad key press
		return

	var is_digit = KEY_0 <= key and key <= KEY_9
	var is_letter = KEY_A <= key and key <= KEY_Z
	var is_special_char = key == KEY_UNDERSCORE or key == KEY_QUESTION or key==KEY_EXCLAM
	var is_space = key == KEY_SPACE
	if !is_digit and !is_letter and !is_special_char and !is_space:
		# TODO: penalty for bad key press
		return

	incantation += String.chr(key)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			execute_incantation(incantation)

		update_incantation(event.keycode)
		$Incantation.text = self.incantation

func execute_incantation(incantation:String):
	# Version 1: Incantation == [Target name]

	print_debug("execute incantation: " + incantation)
	var potential_targets = get_node("/root/node").get_children()
	for target in potential_targets:
		if !property_exist(target, "TargetLabel"):
			continue

		if target.TargetLabel == incantation:
			print_debug("matched: " + incantation)
			cast_spell(target)
		pass
	pass

func property_exist(node:Node, property:String) -> bool:
	var properties = node.get_property_list()
	for p in properties:
		if p.name == property:
			return true
	return false

const SpellScene = preload("res://entity/spell.tscn")

func cast_spell(target:Node):
	print_debug("cast spell= " + target.name)
	var spell = SpellScene.instantiate()
	spell.position = self.position
	spell.Target = target
	get_node("/root/node").add_child(spell)
