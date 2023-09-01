extends Node2D
## Mage controlled by the player by typing incantation.
##
## Mage is a static object that allows player to type incantation.
## Incantation generally cast spells, e.g: shooting enemies, creating a shield,
## summoning a familiar, etc.

@export var entity_type:String = "mage"

var incantation:String = ""

func _input(p_event):
	if p_event is InputEventKey and p_event.is_pressed():
		# When casting (press [Enter]), execute the current incantation
		# and reset the prompt.
		if p_event.keycode == KEY_ENTER:
			execute_incantation(self.incantation)
			self.incantation = ""
			$IncantationUI/Incantation.text = self.incantation # update UI
			return
		# otherwise, just update it
		update_incantation(p_event.keycode)
		$IncantationUI/Incantation.text = self.incantation # update UI

# update self.incantation
func update_incantation(p_key:Key):
	# Edit incantation after [Backspace]
	if p_key == KEY_BACKSPACE:
		var n = len(incantation)
		if n > 0:
			self.incantation = self.incantation.substr(0, n - 1)
		return
	# Ignore typed character that is not in [a-Z0-9_\?!]
	var is_digit = KEY_0 <= p_key and p_key <= KEY_9
	var is_letter = KEY_A <= p_key and p_key <= KEY_Z
	var is_special_char = p_key == KEY_UNDERSCORE or p_key == KEY_QUESTION or p_key==KEY_EXCLAM
	var is_space = p_key == KEY_SPACE
	if !is_digit and !is_letter and !is_special_char and !is_space:
		print_debug("MAGE: typed invalid characters; key= %s" % p_key)
		return
	# Append to incantation
	self.incantation += String.chr(p_key)

func execute_incantation(p_incantation:String):
	print_debug("MAGE: execute \"%s\"" % p_incantation)
	var _enemy_name = p_incantation
	var _target = find_matching_enemy(_enemy_name)
	if _target == null:
		print_debug("MAGE: found no target with name= %s" % _enemy_name )
		return
	self.cast_spell(_target)

func find_matching_enemy(p_enemy_name:String) -> Node:
	var _key = "%s/(target=%s/%s)" % ["enemy", "mage", self.name]
	var _enemies = get_tree().get_nodes_in_group(_key)
	for _enemy in _enemies:
		print_debug("MAGE: search %s (name= %s)" % [_enemy.get_instance_id(), _enemy.name])
		if _enemy.target_name.to_upper() == p_enemy_name.to_upper():
			print_debug("MAGE: found enemy/%s; target_name= %s" % [_enemy.get_instance_id(), _enemy.target_name])
			return _enemy
	return null

const spell_scene = preload("res://entity/spell.tscn")
func cast_spell(p_target:Node):
	print_debug("MAGE: cast spell at %s" % p_target.name)
	var _spell = spell_scene.instantiate()
	_spell.configure(self.global_position, p_target, 200)
	print_debug("MAGE: spawn spell/%s @ (%d, %d)" % [_spell.get_instance_id(), _spell.position.x, _spell.position.y])
	self.add_child(_spell)
