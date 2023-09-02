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
		print_debug("MAGE.V(4): typed invalid characters; key= %s" % p_key)
		return
	# Append to incantation
	self.incantation += String.chr(p_key)

func execute_incantation(p_incantation:String):
	print_debug("MAGE.V(2): execute \"%s\"" % p_incantation)
	var _enemy_identifier = p_incantation
	var _target = find_matching_enemy(_enemy_identifier)
	if _target == null:
		print_debug("MAGE.V(3): found no target with identifier= %s" % _enemy_identifier )
		return
	self.cast_spell(_target)

func find_matching_enemy(p_enemy_identifier:String) -> Node:
	var _key = "enemy(target=mage/%s)" % self.name
	var _enemies = get_tree().get_nodes_in_group(_key)
	for _enemy in _enemies:
		print_debug("MAGE.V(4): search enemy/%s (identifier= %s)" % [_enemy.name, _enemy.identifier])
		if _enemy.identifier.to_upper() == p_enemy_identifier.to_upper():
			print_debug("MAGE.V(2): found enemy/%s (identifier= %s)" % [_enemy.name, _enemy.identifier])
			return _enemy
	return null

const spell_scene = preload("res://entity/spell.tscn")
func cast_spell(p_target:Node):
	var _spell = spell_scene.instantiate()
	_spell.configure(self.global_position, p_target, 200)
	print_debug("MAGE.V(2): spawn spell @ (%d, %d) (target=enemy/%s, identifier= %s)" % [_spell.position.x, _spell.position.y, _spell.target.name, _spell.target.identifier])
	self.add_child(_spell)

func _ready():
	$Mage.area_entered.connect(Callable(self, "_on_hit"))

func _on_hit(area:Area2D):
	if area.name != "Enemy":
		print_debug("MAGE.V(3): hit by unhandled area (name= %s)" % area.name)
		return
	print_debug("MAGE.V(2): hit by an enemy")
