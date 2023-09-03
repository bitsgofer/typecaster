extends Node2D
## Enemy is a object that flies toward a target.
##
## Enemy is a top-level object that flies towards a configured target
## (i.e: homing-missle style).
## All Enemy objects flying towards the same target (identified by name)
## belongs to the same group.

@export var entity_type:String = "enemy"
@export var speed:int = 50
@export var target:Node = null # Mage node
@export var identifier:String = "CHANGE_ME" # Must be set

func _enter_tree():
	self.join_group()

func configure(p_global_position:Vector2, p_target:Node, p_speed:int, p_identifier:String):
	self.position = p_global_position
	self.speed = p_speed
	self.target = p_target
	self.identifier = p_identifier

func update_ui():
	$EnemyLabelUI/EnemyLabel.text = self.identifier

func join_group():
	if self.target == null:
		print_debug("ENEMY.V(4): enemy/%s (identifier= %s): self.target is null => skip joining group" % [self.target.name, self.identifier])
		return
	var _key = self.get_group_key()
	self.add_to_group(_key)
	print_debug("ENEMY.V(3): enemy/%s (identifier= %s): joined group %s" % [self.name, self.identifier, _key])

func _ready():
	print_debug("ENEMY.V(2): enemy/%s (identifier= %s): spawned @ (%d, %d)" % [self.name, self.identifier, self.position.x, self.position.y])
	self.update_ui()
	$Enemy.area_entered.connect(Callable(self, "_on_hit"))

func _process(delta):
	move_towards_top_level_target(delta)

func get_group_key() -> String:
	return "enemy(target=mage/%s)" % self.target.name

func get_collision_key() -> String:
	return "spell(target=enemy/%s)" % self.name

# move towards a target by its global position
func move_towards_top_level_target(delta:float):
	if self.target == null:
		print_debug("ENEMY.V(4): enemy/%s (identifier= %s): self.target is null => skip moving" % [self.target.name, self.identifier])
		return
	var direction = self.target.global_position - self.position
	self.position += direction.normalized() * (self.speed * delta)

func _on_hit(area:Area2D):
	match area.name:
		"Spell":
			var _spell = area.get_parent()
			var _spell_group_key = _spell.get_group_key()
			var _collision_key = self.get_collision_key()
			if _collision_key == _spell_group_key:
				$SFXDead.play()
				self.visible = false
				print_debug("ENEMY.V(2): enemy/%s (identifier= %s): hit by a matched spell => remove enemy and all matched spell(s)" % [self.target.name, self.identifier])
				get_tree().call_group(_spell_group_key, "queue_free")
				await $SFXDead.finished
				self.queue_free()
				return
			print_debug("ENEMY.V(2): enemy/%s (identifier= %s): hit by an unmatched spell => do nothing" % [self.target.name, self.identifier])
			return
		"Mage":
			print_debug("ENEMY.V(2): enemy/%s (identifier= %s): hit by a mage" % [self.target.name, self.identifier])
			self.queue_free()
			return
	print_debug("ENEMY.V(3): enemy/%s (identifier= %s): hit by unhandled area (name= %s)" % [self.target.name, self.identifier, area.name])
	return
