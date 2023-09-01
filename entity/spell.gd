extends Node2D
## Spell is a object that flies toward a target.
##
## Spell is a top-level object that flies towards a configured target
## (i.e: homing-missle style).
## All Spell objects flying towards the same target (identified by name)
## belongs to the same group.

@export var entity_type:String = "spell"
@export var speed:int = 200
@export var target:Node = null
var target_ref:WeakRef = null

# only update the internal target_ref. position and speed is taken from editor
func _enter_tree():
	if self.target != null:
		self.target_ref = weakref(self.target)
	self.join_group()

# configure all aspects of the spell
func configure(p_global_position:Vector2, p_target:Node, p_speed:int):
	self.position = p_global_position
	self.speed = p_speed
	self.target_ref = weakref(p_target)
	self.join_group()

func join_group():
	if self.target_ref == null:
		print_debug("SPELL: self.target_ref not set => skip joining group")
		return
	var _target = self.target_ref.get_ref()
	if _target == null:
		print_debug("SPELL: self.target_ref.get_ref() returns null => skip joining group")
		return
	var _key = "%s/(target=%s/%s)" % [self.entity_type, _target.entity_type, _target.name]
	self.add_to_group(_key)
	print_debug("SPELL: joied group %s" % _key)

func _ready():
	print_debug("SPELL: spawned @ (%d, %d)" % [self.position.x, self.position.y])

func _process(delta):
	move_towards_top_level_target(delta)

# move towards a target by its global position
func move_towards_top_level_target(delta:float):
	if self.target_ref == null:
		print_debug("SPELL: self.target_ref not set => skip moving")
		return
	var _target = self.target_ref.get_ref()
	if _target == null:
		print_debug("SPELL: self.target_ref.get_ref() returns null => skip moving")
		return
	var direction = _target.global_position - self.position
	self.position += direction.normalized() * (self.speed * delta)
