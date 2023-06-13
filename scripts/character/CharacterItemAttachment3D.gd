class_name CharacterItemAttachment3D extends Node3D

@export var inventory: CollectableInventory
@export var items: Array[String] = []
@export var time_visible = 0.0

var timer: Timer

func _ready():
	timer = get_parent().get_node("Timer")
	timer.connect("timeout", hide)
	inventory.connect("collectable_added", inventory_updated)

func inventory_updated(index, collectable_id, quantity):
	hide_all()
	for item in items:
		if inventory.get_collectable_count(item) > 0:
			get_node(item).visible = true
			break
			
func hide_all():
	for child in get_children():
		child.visible = false

func activate():
	visible = true
	if time_visible > 0:
		timer.wait_time = time_visible
		timer.start()
		
	
