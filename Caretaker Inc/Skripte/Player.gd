extends KinematicBody2D

export (NodePath) var Main
export (NodePath) var Guard_Coordination = '../Guard_Coordination'

export (int) var speed = 200
export (int) var health = 100
var gun = false
var policeman = null
var tarned = false
var can_strangle = false
export (int) var reaction_time = 0.5

var strangle = null

var velocity = Vector2()

func _ready():
	$Gun.hide()

func reset():
	$Reaction.stop()
	$Spr.show()
	gun = false
	$Gun.hide()
	$Tarned.hide()
	policeman = null
	tarned = false
	can_strangle = false
	health = 100

# warning-ignore:unused_argument
func _unhandled_input(event):
	if Input.is_action_pressed('shoot'):
		shoot()
	elif Input.is_action_pressed('strangle'):
		strangle()
	elif Input.is_action_pressed('take_gun'):
		if gun == false:
			gun = true
			$Gun.show()
		else:
			gun = false
			$Gun.hide()
	elif Input.is_action_pressed('tarn') and is_instance_valid(policeman):
		if policeman.health <= 0:
			tarn()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func tarn():
	tarned = true
	$Tarned.show()
	$Spr.hide()

func shoot():
	if gun == true:
		$Gun.shoot()
		$Reaction.start(reaction_time)
		tarned = false

# warning-ignore:function_conflicts_variable
func strangle():
	if can_strangle == true and get_node(Guard_Coordination).danger == false:
		if is_instance_valid(strangle) and not gun == true:
			strangle.strangle()
			strangle = null

func _on_Hurt_area_entered(area):
	if not area.get('damage') == null and not area.get('shooter') == self:
		health -= area.damage

	if (health <= 0):
		get_node(Main).lose('You were killed')

func arrest():
	get_node(Main).lose('You were arrested')

func leave():
	get_node(Main).leave_ui()

func _on_Playerpos_area_entered(area):
	if area.collision_layer == 128:
		leave()
	elif area.collision_layer == 256 and not tarned:
		get_node(Guard_Coordination).action()

func _on_Hit_area_entered(area):
	strangle = area.get_parent()
	can_strangle = true

func _on_Hit_area_exited(area):
	if area.get_parent() == strangle:
		strangle = null

func _on_Collect_body_entered(body):
	if body.is_in_group('Enemies'):
		policeman = body

func _on_Collect_body_exited(body):
	if body == policeman:
		policeman = null

func _on_Reaction_timeout():
	get_node(Guard_Coordination).action()
