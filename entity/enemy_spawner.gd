extends Node2D
## EnemySpanwer is a object that creates enemies.
##
## Enemy objects are created by the spawner with a random position within a certain radius of the
## spawner.

@export var entity_type:String = "enemy_spawner"
@export var spawn_interval:float = 3
@export var target:Node = null

func _ready():
	$Timer.wait_time = self.spawn_interval
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
	var _position = get_random_position_within_donut_shape(self.global_position, 16, 64)
	var _identifier = get_random_name()
	_enemy.configure(_position, self.target, 20, _identifier)
	self.add_child(_enemy)

func get_random_position_within_donut_shape(center:Vector2, inner_radius:float, outter_radius:float) -> Vector2:
	var distance = inner_radius + (randf() * (outter_radius - inner_radius))
	var angle = randf() * 2 * PI
	var offset = Vector2(cos(angle), sin(angle)) * distance
	return center + offset

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
