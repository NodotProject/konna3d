class_name Collectable3D extends Nodot3D

## Enable the item for collection
@export var enabled: bool = true
## The collectables icon.
@export var icon: Texture2D
## The collectables name.
@export var display_name: String = "Item"
## The collectables description.
@export_multiline var description: String = "A collectable item."
## The quantity of the collectable.
@export var quantity: int = 1
## The weight of the collectable (kg each).
@export var mass: float = 0.1
## Maximum stack count
@export var stack_limit: int = 1
## The interactive label
@export var label_text: String = "Take %s"

@onready var actual_collectable_root_node = get_parent()

func _ready():
	CollectableManager.add(self)
