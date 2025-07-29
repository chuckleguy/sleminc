extends CharacterBody2D

var shake_strength = 10000.0
var shake_frequency = 100.0
var time := 0.0

func _physics_process(delta):
	time += delta
	var offset = Vector2(sin(time * shake_frequency), cos(time * shake_frequency)) * shake_strength * delta
	move_and_collide(offset)
