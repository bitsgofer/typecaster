extends Node2D

@export var SpawnRatePerSecond:float = 2
@export var spawnDistance:int # spawn in a circle with radius [distance] from the spawner position

var name_list:Array[String] = [
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
]

var enemies:Dictionary # name -> Node

func _ready():
	$SpawnTimer.wait_time = self.SpawnRatePerSecond
	$SpawnTimer.timeout.connect(Callable(self, "_on_spawn_timer_tick"))

func _process(delta):
	pass

const enemyScene:PackedScene = preload("res://entity/enemy.tscn")

func _on_spawn_timer_tick():
	var name = get_random_name()
	if enemies.has(name):
		return

	var position_x = randi() % (get_viewport().size.x - 64) + 32
	var position_y = randi() % (get_viewport().size.y - 36) + 18

	var enemy = enemyScene.instantiate()
	var mage:Node = get_node("/root/node/Mage")

	enemies[name] = enemy
	enemy.init(name, mage, Vector2i(position_x, position_y))
	get_node("/root/node").add_child(enemy) # Q: Why does it have to be added to the root node?

func get_random_name() -> String:
	var name = name_list[randi() % name_list.size()]
	return name
