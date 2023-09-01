extends Node2D

func _ready():
	$EndGame.button_down.connect(Callable(self, "_on_press_end"))
	$EnemySpawner.configure($Mage, 2)

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
	var target = find_matching_enemy(incantation)
	if target == null:
		print_debug("NOT FOUND: target=null")
		return
	self.cast_spell(target)

func find_matching_enemy(targetName:String) -> Node:
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		print_debug("SEARCH: enemy/%s; target_name= %s" % [enemy.get_instance_id(), enemy.target_name])
		if enemy.target_name.to_upper() == targetName.to_upper():
			print_debug("FOUND: enemy/%s; target_name= %s" % [enemy.get_instance_id(), enemy.target_name])
			return enemy
	print_debug("NOT FOUND: enemy=null")
	return null

const SpellScene = preload("res://entity/spell.tscn")
func cast_spell(target:Node):
	var spell = SpellScene.instantiate()
	spell.configure($Mage.position, target, 200)
	print_debug("SPAWN: spell/%s @ (%d, %d)" % [spell.get_instance_id(), spell.position.x, spell.position.y])
	self.add_child(spell)
