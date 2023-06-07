## Allows character control and logic management while fishing
class_name CharacterFish3D extends CharacterExtensionBase3D

@export var fishing_interaction_3d: Interaction3D
@export var boat_interaction_3d: Interaction3D
@export var minimum_bite_time: float = 3.0
@export var maximum_bite_time: float = 6.0
@export var bitten_time: float = 1.0

signal bitten
signal caught
signal let_go
signal fish_mode_enabled
signal fish_mode_disabled

var current_bite_time: float = 0.0
var current_bitten_time: float = 0.0
var fishing_area: Node
var fish_state_id: int
var idle_state_id: int
var fish_on := false
var fish_mode := false
var rng = RandomNumberGenerator.new()

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
		
	GlobalSignal.add_listener("active_fishing_area", self, "set_fishing_area")
	
	
func state_updated(old_state: int, new_state: int):
	if new_state == fish_state_id:
		enable_fish_mode()
		emit_signal("fish_mode_enabled")
	elif old_state == fish_state_id:
		disable_fish_mode()
		emit_signal("fish_mode_disabled")
		
func action(delta: float):
	if current_bite_time > 0.0:
		current_bite_time -= delta
	elif !fish_on and fish_mode:
		fish_on = true
		current_bitten_time = bitten_time
		%bait.start()
		emit_signal("bitten")
		
	if current_bitten_time > 0.0:
		current_bitten_time -= delta
		if Input.is_action_pressed("interact"):
			fish_on = false
			%bait.stop()
			sm.set_state(idle_state_id)
			emit_signal("caught")
	elif fish_on:
		fish_on = false
		%bait.stop()
		sm.set_state(idle_state_id)
		emit_signal("let_go")
	
func can_fish(body: Node3D):
	var near_boat = boat_interaction_3d.is_colliding() and boat_interaction_3d.get_collider().name == "SpeedBoat"
	if !near_boat and fishing_area and fish_mode == false and body is WaterArea3D and character.submerge_handler.is_submerged == false:
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
	current_bite_time = rng.randf_range(minimum_bite_time, maximum_bite_time)
	fish_mode = true
	# TODO: Check which rod is in the inventory and show it
	%bait.visible = true
	%FishingRods.visible = true
	
func disable_fish_mode():
	fish_mode = false
	%bait.visible = false
	%FishingRods.visible = false

func set_fishing_area(area: Variant = null):
	fishing_area = area
