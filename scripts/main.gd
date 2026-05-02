extends Node3D

var money: int = 0
var customer_scene = preload("res://scenes/Customer.tscn")
var active_customers = []
const MAX_CUSTOMERS = 3

@onready var money_label = $UI/MoneyLabel
@onready var order_label = $UI/OrderLabel
@onready var spawn_point = $SpawnPoint
@onready var counter_point = $CounterPoint

func _ready():
	update_ui()
	spawn_loop()

func spawn_loop():
	while true:
		await get_tree().create_timer(3.0).timeout
		if active_customers.size() < MAX_CUSTOMERS:
			_spawn_customer()

func _spawn_customer():
	var cust = customer_scene.instantiate()
	add_child(cust)
	cust.global_position = spawn_point.global_position
	cust.order_completed.connect(_on_order_completed)
	cust.customer_left.connect(_on_customer_left)
	active_customers.append(cust)
	_update_queue()
	update_ui()

func _update_queue():
	for i in range(active_customers.size()):
		var cust = active_customers[i]
		var target = counter_point.global_position + Vector3(0, 0, i * 2.0)
		cust.set_target(target)

func _on_order_completed(cust):
	money += 10
	_remove_customer(cust)

func _on_customer_left(cust):
	_remove_customer(cust)

func _remove_customer(cust):
	if active_customers.has(cust):
		active_customers.erase(cust)
	_update_queue()
	update_ui()

func update_ui():
	money_label.text = "Money: $" + str(money)
	
	var orders_text = ""
	for i in range(active_customers.size()):
		var cust = active_customers[i]
		var order_name = cust.order_recipe.name if cust.get("order_recipe") != null else cust.desired_order
		orders_text += "Customer " + str(i+1) + ": " + order_name + " (Wait: " + str(int(cust.patience)) + "s)\n"
	
	if orders_text == "":
		orders_text = "Order: None"
		
	order_label.text = orders_text

func _process(delta):
	update_ui()
