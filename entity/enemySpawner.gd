extends Node2D

@export var SpawnRatePerSecond:float = 4
@export var spawnDistance:int # spawn in a circle with radius [distance] from the spawner position

var name_list:Array[String] = [
  "dill",
  "eggs",
  "truffles",
  "squid",
  "beans",
  "wasabi",
  "kale",
  "pickles",
  "celery seeds",
  "onion powder",
  "alfredo sauce",
  "chocolate",
  "kidney beans",
  "broccoli",
  "granola",
  "gelatin",
  "pico de gallo",
  "jelly beans",
  "tomato juice",
  "swordfish",
  "catfish",
  "pork",
  "breadfruit",
  "dumpling",
  "pears",
  "anchovy paste",
  "cider",
  "milk",
  "garlic powder",
  "onions",
  "borscht",
  "tomato puree",
  "chestnuts",
  "chicken liver",
  "olive oil",
  "shrimp",
  "wild rice",
  "margarine",
  "flax seed",
  "figs",
  "spaghetti squash",
  "baking soda",
  "passion fruit",
  "bok choy",
  "Worcestershire sauce",
  "celery",
  "peanuts",
  "navy beans",
  "capers",
  "potatoes",
  "mascarpone",
  "gouda",
  "chile peppers",
  "fish sauce",
  "ricotta cheese",
  "bass",
  "potato chips",
  "colby cheese",
  "cornmeal",
  "green onions",
  "Tabasco sauce",
  "pineapples",
  "asiago cheese",
  "hot sauce",
  "dried leeks",
  "scallops",
  "cream of tartar",
  "bruschetta",
  "pumpkin seeds",
  "bagels",
  "beets",
  "couscous",
  "grapes",
  "herring",
  "sesame seeds",
  "adobo",
  "tonic water",
  "vanilla",
  "kiwi",
  "lemons",
  "broth",
  "limes",
  "almond extract",
  "turnips",
  "custard",
  "carrots",
  "cabbage",
  "white beans",
  "honey",
  "snapper",
  "succotash",
  "lemon Peel",
  "mozzarella",
  "cottage cheese",
  "swiss cheese",
  "zest",
  "corn",
  "parsley",
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

	var max_distance = max(get_viewport().size.x, get_viewport().size.y) / 2.0
	var position = generate_random_enemy_position(self.position, 64, max_distance, 16)

	var enemy = enemyScene.instantiate()
	var mage:Node = get_tree().root.get_node("node").get_node("Mage")

	enemies[name] = enemy
	enemy.init(name, mage, position)
	get_tree().root.get_node("node").add_child(enemy) # Q: Why does it have to be added to the root node?

func generate_random_enemy_position(center:Vector2, safe_zone_radius:float, max_spawn_radius:float, enemy_radius:float) -> Vector2:
	var max_distance = max_spawn_radius - enemy_radius
	var min_distance = safe_zone_radius + enemy_radius
	var distance = min_distance + (randf() * (max_distance - min_distance))
	var angle = randf() * 2 * PI
	var offset = Vector2(cos(angle), sin(angle)) * distance
	return center + offset

func get_random_name() -> String:
	var name = name_list[randi() % name_list.size()]
	return name
