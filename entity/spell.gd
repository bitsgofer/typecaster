extends Node2D
## Spell is a object that flies toward a target.
##
## Spell is a top-level object that flies towards a configured target
## (i.e: homing-missle style).
## All Spell objects flying towards the same target (identified by name)
## belongs to the same group.

@export var entity_type:String = "spell"
@export var speed:int = 200
@export var target:Node = null # Enemy nodes

func _enter_tree():
	self.join_group()

func configure(p_global_position:Vector2, p_target:Node, p_speed:int):
	self.position = p_global_position
	self.speed = p_speed
	self.target = p_target

func join_group():
	if self.target == null:
		print_debug("SPELL.V(4): spell/%s (target= %s): self.target is null => skip joining group" % [self.name, self.target.name])
		return
	var _key = self.get_group_key()
	self.add_to_group(_key)
	print_debug("SPELL.V(3): spell/%s (target= %s): joined group %s" % [self.name, self.target.name, _key])

func get_group_key() -> String:
	return "spell(target=enemy/%s)" % self.target.name

func _ready():
	print_debug("SPELL.V(2): spell/%s (target= %s): spawned @ (%d, %d)" % [self.name, self.target.name, self.position.x, self.position.y])

func _process(delta):
	move_towards_top_level_target(delta)

# move towards a target by its global position
func move_towards_top_level_target(delta:float):
	if self.target == null:
		print_debug("SPELL.V(4): spell/%s (target= %s): self.target is null => skip moving" % [self.name, self.target.name])
		return
	var direction = self.target.global_position - self.position
	self.position += direction.normalized() * (self.speed * delta)
