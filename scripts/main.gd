extends Node3D

var money: int = 0
var customer_scene = preload("res://scenes/Customer.tscn")
var ordering_customers = []
var waiting_for_food_customers = []
const MAX_CUSTOMERS = 3

@onready var money_label = $UI/MoneyLabel
@onready var order_label = $UI/OrderLabel
@onready var spawn_point = $SpawnPoint
@onready var counter_point = $CounterPoint
@onready var delivery_point = $DeliveryPoint

func _ready():
	update_ui()
	spawn_loop()

func spawn_loop():
	while true:
		await get_tree().create_timer(3.0).timeout
		if ordering_customers.size() + waiting_for_food_customers.size() < MAX_CUSTOMERS:
			_spawn_customer()

func _spawn_customer():
	var cust = customer_scene.instantiate()
	add_child(cust)
	cust.global_position = spawn_point.global_position
	cust.order_completed.connect(_on_order_completed)
	cust.customer_left.connect(_on_customer_left)
	cust.order_placed.connect(_on_order_placed)
	ordering_customers.append(cust)
	_update_queue()
	update_ui()

func _update_queue():
	for i in range(ordering_customers.size()):
		var cust = ordering_customers[i]
		var target = counter_point.global_position
		if counter_point.get_child_count() > i:
			target = counter_point.get_child(i).global_position
		cust.set_target(target)
	
	for i in range(waiting_for_food_customers.size()):
		var cust = waiting_for_food_customers[i]
		var target = delivery_point.global_position
		if delivery_point.get_child_count() > i:
			target = delivery_point.get_child(i).global_position
		cust.set_target(target)

func _on_order_placed(cust):
	if ordering_customers.has(cust):
		ordering_customers.erase(cust)
	waiting_for_food_customers.append(cust)
	_update_queue()
	update_ui()

func _on_order_completed(cust):
	money += 10
	_remove_customer(cust)

func _on_customer_left(cust):
	_remove_customer(cust)

func _remove_customer(cust):
	if ordering_customers.has(cust):
		ordering_customers.erase(cust)
	if waiting_for_food_customers.has(cust):
		waiting_for_food_customers.erase(cust)
	_update_queue()
	update_ui()

func update_ui():
	money_label.text = "Money: $" + str(money)
	
	var orders_text = ""
	var all_cust = ordering_customers.duplicate()
	all_cust.append_array(waiting_for_food_customers)
	
	for i in range(all_cust.size()):
		var cust = all_cust[i]
		if cust.get("has_ordered") == true:
			var order_name = cust.order_recipe.name if cust.get("order_recipe") != null else cust.desired_order
			orders_text += "Customer " + str(i+1) + ": " + order_name + " (Wait: " + str(int(cust.patience)) + "s)\n"
	
	if orders_text == "":
		orders_text = "Order: None"
		
	order_label.text = orders_text
func _process(delta):
	update_ui()
