extends Node2D
## EnemySpanwer is a object that creates enemies.
##
## Enemy objects are created by the spawner with a random position within a certain radius of the
## spawner.

@export var entity_type:String = "enemy_spawner"
@export var spawn_interval:float = 3
@export var target:Node = null
@export var enabled:bool = false
@export_range(48, 144, 1, "or_greater", "or_less") var spawn_donut_inner_radius:int = 48
@export_range(272, 528, 1, "or_greater", "or_less") var spawn_donut_outer_radius:int = 272
@export_range(0, 360, 1, "degrees") var spawn_donut_min_degree:int = 0
@export_range(0, 360, 1, "degrees") var spawn_donut_max_degree:int = 360

func _enter_tree():
	$Timer.autostart = self.enabled
	$Timer.wait_time = self.spawn_interval

func _ready():
	$Timer.timeout.connect(Callable(self, "_on_spawn_timer_ticked"))

func configure(p_global_position:Vector2, p_target:Node, p_spawn_interval:float):
	self.position = p_global_position
	self.spawn_interval = p_spawn_interval
	self.target = p_target

const enemy_scene = preload("res://entity/enemy.tscn")
func _on_spawn_timer_ticked():
	if self.target == null:
		print_debug("ENEMY_SPAWNER.V(4): enemy_spawner/%s (target= %s): self.target is null => skip spawning enemy" % [self.name, self.target.name])
		return
	var _enemy = enemy_scene.instantiate()
	var _position = get_random_position_within_donut(self.global_position)
	var _identifier = get_random_name()
	_enemy.configure(_position, self.target, 20, _identifier)
	self.add_child(_enemy)

func get_random_position_within_donut(p_center:Vector2) -> Vector2:
	var _distance = self.spawn_donut_inner_radius + (randf() * (self.spawn_donut_outer_radius - self.spawn_donut_inner_radius))
	var _angle_in_degree = self.spawn_donut_min_degree + randf() * (self.spawn_donut_max_degree - self.spawn_donut_min_degree)
	var _angle = _angle_in_degree/180.0*PI
	print_debug("ENEMY_SPAWNER.V(4): random position with angle=%f (radian)/%f (degree), distance= %f" % [_angle, _angle_in_degree, _distance])
	var _offset = Vector2(cos(_angle), sin(_angle)) * _distance
	return p_center + _offset

var target_name_list = [
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
]
func get_random_name() -> String:
	var _name = target_name_list[randi() % target_name_list.size()]
	return _name.to_upper()
