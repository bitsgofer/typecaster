extends Node2D

@export var HP:int=1
@export var MP:int=1000

var incantation = "" # Current incantation

func _ready():
	$MageArea.area_entered.connect(Callable(self, "_on_spell_hit"))

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

	var potential_targets = get_tree().root.get_node("node").get_children()
	for target in potential_targets:
		if !property_exist(target, "TargetLabel"):
			continue

		if target.TargetLabel.to_upper() == incantation.to_upper():
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
	var spell = SpellScene.instantiate()
	spell.init(self.position, 100, target, target.TargetLabel)
	get_tree().root.get_node("node").add_child(spell)

const game_over_scene:PackedScene = preload("res://scene/game_over.tscn")

func _on_spell_hit(area:Area2D):
	if area.name != "EnemyArea":
		return

	var scene = game_over_scene.instantiate()
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
