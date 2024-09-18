extends Node3D

@export var object_mesh: MeshInstance3D

signal pulse_changed(pulsing: bool)

var pulsing := false
var pulse_material: ShaderMaterial

func _ready():
	object_mesh.material_overlay = object_mesh.material_overlay.duplicate()
	pulse_material = object_mesh.material_overlay
	pulse_material.set_shader_parameter("strength", 0.00)
	
func start_pulse():
	if !pulsing:
		pulse_material.set_shader_parameter("strength", 0.05)
		pulsing = true
		pulse_changed.emit(true)

func stop_pulse():
	pulse_material.set_shader_parameter("strength", 0.00)
	pulsing = false
	pulse_changed.emit(false)
