extends Node3D

func set_fog(value:bool) -> void:
	var env:Environment = $WorldEnvironment.environment
	if value:
		env.fog_light_color = Color(0.317, 0.326, 0.496, 1.0)
		env.fog_depth_begin = 25
		env.fog_depth_end = 300
	else:
		env.fog_light_color = Color("cc8dab")
		env.fog_depth_begin = 100
		env.fog_depth_end = 500
