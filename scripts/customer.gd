extends CharacterBody3D

signal order_completed(cust)
signal reached_counter
signal customer_left(cust)

@onready var nav = $NavigationAgent3D
var target_pos: Vector3

var current_state = "moving"
var order_recipe: Dictionary
var desired_order = "Burger"

var patience = 60.0
var max_patience = 60.0

func _ready():
	order_recipe = RecipeManager.get_random_recipe()
	desired_order = order_recipe.result
	_create_order_label()

func _create_order_label():
	var label = Label3D.new()
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.text = order_recipe.name + "\n("
	
	var ingredients_counts = {}
	for ing in order_recipe.ingredients:
		if ingredients_counts.has(ing):
			ingredients_counts[ing] += 1
		else:
			ingredients_counts[ing] = 1
	
	var parts = []
	for ing in ingredients_counts.keys():
		var count = ingredients_counts[ing]
		if count > 1:
			parts.append(str(count) + "x " + ing)
		else:
			parts.append(ing)
	
	label.text += " + ".join(parts) + ")"
	label.pixel_size = 0.005
	label.position.y = 2.0
	label.font_size = 32
	add_child(label)

func set_target(pos: Vector3):
	if current_state != "leaving":
		nav.target_position = pos
		target_pos = pos
		current_state = "moving"

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
	elif current_state == "waiting":
		patience -= delta
		if patience <= 0:
			customer_left.emit(self)
			leave_store()
	elif current_state == "leaving":
		var next_pos = nav.get_next_path_position()
		var dir = global_position.direction_to(next_pos)
		velocity = dir * 3.0
		if global_position.distance_to(target_pos) < 1.0:
			queue_free()
		move_and_slide()

func interact(player):
	if current_state == "waiting":
		if player.held_item != null and player.held_item.item_id == desired_order:
			player.take_item()
			order_completed.emit(self)
			leave_store()

func leave_store():
	current_state = "leaving"
	nav.target_position = Vector3(10, 0, 10)
	target_pos = nav.target_position
