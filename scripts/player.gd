extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $Camera3D
@onready var interact_ray = $Camera3D/InteractRay
@onready var hold_point = $Camera3D/HoldPoint

var held_item: Item = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("interact") and interact_ray.is_colliding():
		var target = interact_ray.get_collider()
		if target.has_method("interact"):
			target.interact(self)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func give_item(item_scene: PackedScene, item_name: String):
	if held_item != null: return false
	var item = item_scene.instantiate() as Item
	item.item_name = item_name
	hold_point.add_child(item)
	held_item = item
	return true

func take_item() -> String:
	if held_item == null: return ""
	var n = held_item.item_name
	held_item.queue_free()
	held_item = null
	return n
