extends CharacterBody3D

signal order_completed
signal reached_counter

@onready var nav = $NavigationAgent3D
var target_pos: Vector3

var current_state = "moving"
var desired_order = "CookedBurger"

func _ready():
	pass



func _physics_process(delta):
	if current_state == "moving":
		var next_pos = nav.get_next_path_position()
		var dir = global_position.direction_to(next_pos)
		velocity = dir * 3.0
		if global_position.distance_to(target_pos) < 1.5:
			current_state = "waiting"
			reached_counter.emit()
			velocity = Vector3.ZERO
		move_and_slide()
	elif current_state == "leaving":
		var next_pos = nav.get_next_path_position()
		var dir = global_position.direction_to(next_pos)
		velocity = dir * 3.0
		if global_position.distance_to(target_pos) < 1.0:
			queue_free()
		move_and_slide()




func interact(player):
	if current_state == "waiting":
		if player.held_item != null and player.held_item.item_name == desired_order:
			player.take_item()
			current_state = "leaving"
			order_completed.emit()
			leave_store()



func leave_store():
	nav.target_position = Vector3(10, 0, 10)
	target_pos = nav.target_position
