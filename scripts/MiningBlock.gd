class_name MiningBlock extends StaticBreakable3D

@export var gives_item_name: String

signal mined
signal mine_hit
signal mine_miss

var axe_health_limits = [10, 50, 100]
var pickaxes_node: Node3D

func _ready():
	connect("broken", give_item)
	pickaxes_node = PlayerManager.node.get_node("Frog/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D/PickAxes")

func give_item():
	get_inventory().add(gives_item_name, 1)

func interact():
	var health_limit = get_block_health_limit()
	if health.max_health <= health_limit:
		add_health(-health_limit)
		mine_hit.emit()
	else:
		mine_miss.emit()
	
	mined.emit()
	pickaxes_node.activate()
			

func get_block_health_limit():
	var health_limit = 0
	var pickaxes = ["Wooden Pickaxe", "Iron Pickaxe", "Crystal Pickaxe"]
	for i in pickaxes.size():
		var item = pickaxes[i]
		if get_inventory().get_collectable_count(item) > 0:
			health_limit = axe_health_limits[i]
	return health_limit
	
func get_inventory() -> CollectableInventory:
	return Nodot.get_first_child_of_type(PlayerManager.node, CollectableInventory)
