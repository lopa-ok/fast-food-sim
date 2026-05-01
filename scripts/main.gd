extends Node3D

var money: int = 0
var customer_scene = preload("res://scenes/Customer.tscn")
var current_customer = null

@onready var money_label = $UI/MoneyLabel
@onready var order_label = $UI/OrderLabel
@onready var spawn_point = $SpawnPoint
@onready var counter_point = $CounterPoint

func _ready():
	update_ui()
	spawn_customer()

func spawn_customer():
	await get_tree().create_timer(2.0).timeout
	var cust = customer_scene.instantiate()
	add_child(cust)
	cust.global_position = spawn_point.global_position
	cust.nav.target_position = counter_point.global_position
	cust.target_pos = counter_point.global_position
	cust.order_completed.connect(_on_order_completed)
	current_customer = cust
	order_label.text = "Order: CookedBurger (Incoming)"
	cust.reached_counter.connect(func(): order_label.text = "Order: CookedBurger (Waiting)")

func _on_order_completed():
	money += 10
	order_label.text = "Order: None"
	update_ui()
	current_customer = null
	spawn_customer()

func update_ui():
	money_label.text = "Money: $" + str(money)
