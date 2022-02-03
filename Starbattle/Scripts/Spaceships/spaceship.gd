extends RigidBody2D

export(int, "player", "enemy1", "enemy2") var group
export var player_controlled = false

var max_health = Values.SPACESHIP["basic"]["health"]
var health = max_health

var forward_thrusters = []
var backward_thrusters = []
var strave_left_thrusters = []
var strave_right_thrusters = []

var rotate_left_thrusters = []
var rotate_right_thrusters = []

var linear_acceleration = Vector2()
var angular_acceleration = 0

export(NodePath) var gui_path = "GUI"
onready var gui = get_node(gui_path)

func _input(event):
	if player_controlled:
		if event.is_action_pressed("ui_accept"):
			$InventoryComponent.toggle_window(self)
		
		# Query test by hitting 'Esc' for Apple
		if event.is_action_pressed("ui_cancel"):
			if $InventoryComponent.inv_query("Apple", 2):
				print("it has 2 apples or more")
			else:
				print("doesn't have 2 apples")

func _on_item_interacted(_sender, item, amount):
	$InventoryComponent.add_to_inventory(item, amount)

func _ready():
	for thruster in $thruster.get_children():
		if thruster.direction == 0:
			forward_thrusters.append(thruster)
		elif thruster.direction == 1:
			backward_thrusters.append(thruster)
		elif thruster.direction == 2:
			strave_left_thrusters.append(thruster)
		elif thruster.direction == 3:
			strave_right_thrusters.append(thruster)
		elif thruster.direction == 4:
			rotate_left_thrusters.append(thruster)
		elif thruster.direction == 5:
			rotate_right_thrusters.append(thruster)
		else:
			thruster.queue_free()

	if player_controlled:
		add_to_group("player_flagship")

	add_to_group(str(group))
	add_to_group(Values.SPACESHIP["type"])

	mass = Values.SPACESHIP["basic"]["mass"]

func _physics_process(delta):
	if health <= 0:
		queue_free()

	linear_acceleration = Vector2()
	angular_acceleration = 0

	if player_controlled:
		if Input.is_action_pressed("Rotate_left"):
			for thruster in rotate_left_thrusters:
				angular_acceleration -= thruster.force / mass
				thruster.thrust()
		if Input.is_action_pressed("Rotate_right"):
			for thruster in rotate_right_thrusters:
				angular_acceleration += thruster.force / mass
				thruster.thrust()

		if Input.is_action_pressed("Forward"):
			for thruster in forward_thrusters:
				linear_acceleration += Vector2(0, -thruster.force / mass).rotated(thruster.global_rotation)
				thruster.thrust()
		if Input.is_action_pressed("Backward"):
			for thruster in backward_thrusters:
				linear_acceleration += Vector2(0, -thruster.force / mass).rotated(thruster.global_rotation)
				thruster.thrust()
	
		if Input.is_action_pressed("Strave_left"):
			for thruster in strave_left_thrusters:
				linear_acceleration += Vector2(0, -thruster.force / mass).rotated(thruster.global_rotation)
				thruster.thrust()
		if Input.is_action_pressed("Strave_right"):
			for thruster in strave_right_thrusters:
				linear_acceleration += Vector2(0, -thruster.force / mass).rotated(thruster.global_rotation)
				thruster.thrust()

		linear_velocity += linear_acceleration * delta
		angular_velocity += angular_acceleration * delta

func _on_hit_area_entered(area):
	var hit = area.deal_damage(group)
	if hit:
		health -= hit[0]
		area.queue_free()

func _on_hit_body_entered(body):
	var hit = body.deal_damage(group)
	if hit:
		health -= hit[0]
		body.queue_free()
