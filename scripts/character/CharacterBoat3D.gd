## Allows character control and logic management while boating
class_name CharacterBoat3D extends CharacterExtensionBase3D

func ready():
	register_handled_states(["boat"])
	
	sm.add_valid_transition("boat", ["idle"])
	sm.add_valid_transition("idle", ["boat"])
	sm.add_valid_transition("walk", ["boat"])
	sm.add_valid_transition("sprint", ["boat"])
	sm.add_valid_transition("jump", ["boat"])

