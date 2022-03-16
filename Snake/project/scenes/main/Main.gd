extends Node

# Declare member variables here. Examples:
const interpolate = preload("res://entities/Interpolate.tscn")
const scene_food = preload("res://entities/food/Food.tscn")
const scene_snake = preload("res://entities/snake/Snake.tscn")

onready var grid: Grid = get_node("Grid") as Grid

onready var random_player_names = ["SnakeJud","SnakePeccancy","SnakeRameal","SnakeHalecret","SnakeTonlet","SnakeGonfalon","SnakeQuotuple","SnakeYird","SnakeRecaption","SnakeIdealism","SnakeDomett","SnakeFizz","SnakeVitrine","SnakeEyelet","SnakeIntention","SnakeLapicide","SnakeBraird","SnakePerlative","SnakeNymphean","SnakeFecalith","SnakeAmpulla","SnakeTheism","SnakeNiggle","SnakeXoana","SnakeNovae","SnakePrevernal","SnakeGramary","SnakeTruculent","SnakeFeracious","SnakeCosmorama","SushiSnake","ArgilSnake","SalemporeSnake","OrotundSnake","RetiarySnake","SlypeSnake","ConundrumSnake","GauleiterSnake","ElastaneSnake","FlumenSnake","LaxismSnake","ElapseSnake","MeacockSnake","HuggerySnake","IncanousSnake","TruncheonSnake","RemanentSnake","ScalawagSnake","NeurergicSnake","PavonineSnake","EruciformSnake","ReliquarySnake","WelkinSnake","SquirageSnake","VolutionSnake","PloceSnake","CariousSnake","LupineSnake","SugentSnake","TorvitySnake", "Neinhorn", "Dochter", "Nahund", "Wasbaer"]

var player: Node2D
onready var player_name = "WaitAMinute"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player_name = random_player_names[randi() % random_player_names.size()] + str(int(rand_range(1, 1000)))
	
	setup_entities()
	get_tree().paused = true
	$UI/ChooseName/LineEdit.text = player_name

func setup_entities() -> void:
	player = scene_snake.instance() as Node2D
	player.connect("move_triggered", self, "_on_Snake_move_triggered")
	player.connect("generated_tail_segment", self, "_on_Snake_generated_tail_segment")
	player.connect("body_segment_move_triggered", self, "_on_Snake_body_segment_move_triggered")
	player.connect("size_changed", self, "_on_Snake_size_changed")
	add_child(player)
	# var inter = interpolate.instance()
	# inter.follow = player.get_path()
	# add_child(inter)
	move_child(player, 0)
	grid.place_entity_at_random_pos(player)
	setup_food_entity()

func setup_food_entity() -> void:
	var food_instance: Node2D = scene_food.instance() as Node2D
	add_child_below_node(player, food_instance)
	grid.place_entity_at_random_pos(food_instance)

func _on_Snake_move_triggered(entity: Node2D, direction: Vector2) -> void:
	grid.move_entity_in_direction(entity, direction)

func _on_Grid_moved_into_death() -> void:
	get_tree().paused = true
	
	var score = player.body_segments.size()
	
	delete_entities_of_group("Food")
	delete_entities_of_group("Player")
	
	$LeaderBoard.save_score(player_name, score)
	$UI/Lose.show()
	
	setup_entities()

func delete_entities_of_group(name: String) -> void:
	var entities: Array = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.queue_free()

func _on_Grid_moved_onto_food(food_entity: Node2D, entity: Node2D) -> void:
	if entity.has_method("eat_food"):
		entity.eat_food(food_entity.value)
		food_entity.queue_free()
		setup_food_entity()

func _on_Snake_generated_tail_segment(segment: Node2D, segment_position: Vector2) -> void:
	add_child_below_node(player, segment)
	# var inter = interpolate.instance()
	# inter.follow = segment.get_path()
	# get_parent().add_child(inter)
	grid.place_entity(segment, grid.world_to_map(segment_position))

func _on_Snake_body_segment_move_triggered(segment: Node2D, segment_position: Vector2) -> void:
	grid.move_entity_to_position(segment, segment_position)

func _on_Snake_size_changed(length: int) -> void:
	$UI.update_score(length)
