extends IItem

func _init():
	self.i_name = "Turret"
	self.i_image = load("res://icon.png")
	self.i_description = "If you eat me, you will get 10 health"
	self.i_stackable = true
	self.i_maxstack = 4

func i_use(player):
	player.health += 10
	.i_use(player)
