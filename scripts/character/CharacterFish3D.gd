## Allows character control and logic management while fishing
class_name CharacterFish3D extends CharacterExtensionBase3D

@export var fishing_interaction_3d: Interaction3D

var in_fish_area: bool = false
var fish_state_id: int
var idle_state_id: int
var fish_mode := false

func _ready():
	register_handled_states(["fish", "idle", "walk", "sprint"])
	
	fish_state_id = sm.get_id_from_name("fish")
	idle_state_id = sm.get_id_from_name("idle")
	
	sm.add_valid_transition("fish", ["idle", "walk", "sprint"])
	sm.add_valid_transition("idle", "fish")
	sm.add_valid_transition("walk", "fish")
	sm.add_valid_transition("sprint", "fish")
	
	if fishing_interaction_3d:
		fishing_interaction_3d.connect("interacted", fishing_interacted)
		
	GlobalSignal.add_listener("can_fish", self, "set_in_fish_area")
	GlobalSignal.add_listener("cant_fish", self, "set_not_in_fish_area")
	
func state_updated(old_state: int, new_state: int):
	if new_state == fish_state_id:
		enable_fish_mode()
	else:
		disable_fish_mode()
		
func action(_delta):
	pass
	
func can_fish(body: Node3D):
	if in_fish_area == true and fish_mode == false and body is WaterArea3D and character.submerge_handler.is_submerged == false:
		return true
	return false
	
func fishing_interacted(body: Node3D, collision_point: Vector3, _collision_normal):
	if can_fish(body):
		%bait.water_area_3d = body
		%bait.global_position = collision_point
		sm.set_state(fish_state_id)
		return
	if fish_mode == true:
		sm.set_state(idle_state_id)

func enable_fish_mode():
	fish_mode = true
	# TODO: Check which rod is in the inventory and show it
	%bait.visible = true
	%FishingRods.visible = true
	
func disable_fish_mode():
	fish_mode = false
	%bait.visible = false
	%FishingRods.visible = false

func set_in_fish_area():
	in_fish_area = true
	
func set_not_in_fish_area():
	in_fish_area = false
