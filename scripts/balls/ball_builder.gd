extends Node

class_name BallBuilder

static func build_ball(data: BattleBallData) -> RigidBody3D:
	if not data:
		printerr("BallBuilder: BattleBallData is null.")
		return null

	var ball = RigidBody3D.new()
	ball.name = data.ball_name

	# 1. Configure Core properties
	if data.core_ref:
		ball.mass = data.core_ref.mass
		# Godot requires custom mode to be set to change center of mass
		ball.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
		ball.center_of_mass = data.core_ref.com_offset
	else:
		printerr("BallBuilder: CoreResource is missing for ", data.ball_name)

	# 2. Configure Shell properties
	if data.shell_ref:
		# Create visual mesh
		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = data.shell_ref.mesh
		if data.material:
			mesh_instance.material_override = data.material
		ball.add_child(mesh_instance)

		# Create collision shape
		var collision_shape = CollisionShape3D.new()
		collision_shape.shape = data.shell_ref.collider
		ball.add_child(collision_shape)

		# Apply physics material
		var physics_material = PhysicsMaterial.new()
		physics_material.friction = data.shell_ref.friction
		physics_material.bounce = data.shell_ref.bounce
		ball.physics_material_override = physics_material
	else:
		printerr("BallBuilder: ShellResource is missing for ", data.ball_name)

	# 3. Configure Spirit properties
	if data.spirit_ref and data.spirit_ref.packed_scene:
		var spirit_instance = data.spirit_ref.packed_scene.instantiate()
		ball.add_child(spirit_instance)
	else:
		print("BallBuilder: SpiritResource is missing or has no packed scene for ", data.ball_name)

	return ball
