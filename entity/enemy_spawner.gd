extends Node2D

var target_ref:WeakRef = null

func configure(p_target:Node, p_spawn_rate:float):
	self.target_ref = weakref(p_target)
	$SpawnTimer.wait_time = p_spawn_rate
	print_debug("ENEMY_SPAWNER: configure spawn_rate= %d; target= %s" % [p_spawn_rate, p_target.name])

func _ready():
	$SpawnTimer.timeout.connect(Callable(self, "_on_spawn_timer_timeout"))

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

const enemy_scene = preload("res://entity/enemy.tscn")
func _on_spawn_timer_timeout():
	print_debug("ENEMY_SPAWNER: spawn timer ticked")
	if self.target_ref == null:
		print_debug("ENEMY_SPAWNER: target_ref == null")
		return
	var _target = self.target_ref.get_ref()
	if _target == null:
		print_debug("ENEMY_SPAWNER: target_ref.get_ref() == null")
		return
	var enemy = enemy_scene.instantiate()
	var _position = get_random_position_within_donut_shape(self.global_position, 20, 50)
	var _target_name = get_random_name()
	enemy.configure(_position, _target_name, _target)
	enemy.top_level = true
	print_debug("ENEMY_SPAWNER: spawn enemy/%s @ (%s, %s); target= %s" % [_target_name, _position.x, _position.y, _target.get_instance_id()])
	self.add_child(enemy)

func get_random_position_within_donut_shape(center:Vector2, inner_radius:float, outter_radius:float) -> Vector2:
	var distance = inner_radius + (randf() * (outter_radius - inner_radius))
	var angle = randf() * 2 * PI
	var offset = Vector2(cos(angle), sin(angle)) * distance
	return center + offset

func get_random_name() -> String:
	var _name = target_name_list[randi() % target_name_list.size()]
	return _name
