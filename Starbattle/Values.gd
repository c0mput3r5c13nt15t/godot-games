extends Node

var bullet_path = "res://Scenes/Projectiles/bullet.tscn"
var torpedo_path = "res://Scenes/Projectiles/torpedo.tscn"
var missile_path = "res://Scenes/Projectiles/missile.tscn"

# General

var AUTO_FIRE = 0
var PLAYER_CONTROLL = 1
var CONTINOUS_FIRE = 2
var NO_FIRE = 3

var MAIN_WEAPON = 0
var SECONDARY_WEAPON = 1
var TERTIARY_WEAPON = 2
var QUATERNARY_WEAPON = 3
var QUINARY_WEAPON = 4
var SENARY_WEAPON = 5
var SEPTENARY_WEAPON = 6
var OCTONARY_WEAPON = 7
var NONARY_WEAPON = 8
var OTHER_WEAPON = 9

# Spacespaceships

var SPACESHIP = {
	"type": "spaceship",
	"basic": {
		"health": 10000,
		"mass": 1000,
		"energy_production": 3000
	}
}

# Projectiles

var PROJECTILES = {
	"type": "bullet",
	"basic": {
		"damage": 1,
		"damage_type": "kin",
		"speed": 450,
		"lifetime": 3,
	},
	"railgun": {
		"damage": 400,
		"damage_type": "kin",
		"speed": 600,
		"lifetime": 30,
	}
}

var UNGUIDED_EXPLOSIVES = {
	"type": "torpedo",
	"basic": {
		"health": 2,
		"mass": 5,
		"damage": 200,
		"damage_type": "expl",
		"lifetime": 20
	}
}

var GUIDED_EXPLOSIVES = {
	"type": "missile",
	"basic": {
		"health": 1,
		"mass": 5,
		"damage": 160,
		"damage_type": "expl",
		"rotation_speed": 30,
		"lifetime": 20,
	}
}

# Thrusters

var THRUSTERS = {
	"ion": {
		"main_force": 60000,
		"steer_force": 120
	}
}

# Turrets

var TURRETS = {
	"type": "turret",
	"basic": {
		"mass": 5,
		"energy_consumption": 100,
		"range": 700,
		"view_range": 1000,
		"rotation_speed": 100,
		"inaccuracy": 0,
		"projectile": bullet_path,
		"reload_time": 0.2,
		"magazine_size": 40,
		"magazine_reload_time": 0.5,
		"preferred_targets": ["missile", "torpedo"],
		"other_targets": ["spaceship"]
	}
}

# Canons

var CANONS = {
	"type": "canon",
	"basic": {
		"mass": 12,
		"energy_consumption": 3000,
		"range": 1600,
		"inaccuracy": 0,
		"projectile": bullet_path,
		"reload_time": 0.1,
		"magazine_size": 100,
		"magazine_reload_time": 10,
		"preferred_targets": ["spaceship"],
		"other_targets": []
	}
}

# Launchers

var LAUNCHER = {
	"type": "launcher",
	"torpedo": {
		"mass": 7,
		"energy_consumption": 110,
		"range": 500,
		"inaccuracy": 0.4,
		"projectile": torpedo_path,
		"reload_time": 0.5,
		"magazine_size": 20,
		"magazine_reload_time": 40,
		"preferred_targets": ["spaceship"],
		"other_targets": []
	},
	"missile": {
		"mass": 7,
		"energy_consumption": 200,
		"range": 2500,
		"inaccuracy": 0.5,
		"projectile": missile_path,
		"reload_time": 1,
		"magazine_size": 20,
		"magazine_reload_time": 40,
		"preferred_targets": ["spaceship"],
		"other_targets": []
	}
}
