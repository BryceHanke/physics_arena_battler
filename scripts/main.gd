extends Node3D

# Preload the necessary scripts and resources
const BallBuilder = preload("res://scripts/ball_builder.gd")
const BattleBallData = preload("res://scripts/resources/battle_ball_data.gd")
const CoreResource = preload("res://scripts/resources/core_resource.gd")
const ShellResource = preload("res://scripts/resources/shell_resource.gd")

func _ready():
	# 1. Create a placeholder Core
	var core := CoreResource.new()
	core.mass = 100.0
	core.com_offset = Vector3(0, -0.2, 0) # Lower center of mass for stability

	# 2. Create a placeholder Shell
	var shell := ShellResource.new()
	shell.friction = 0.6
	shell.bounce = 1.0

	# Create a simple sphere mesh and collider for the shell
	var sphere_mesh := SphereMesh.new()
	sphere_mesh.radius = 1.0
	sphere_mesh.height = 2.0
	shell.mesh = sphere_mesh

	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = 1.0
	shell.collider = sphere_shape

	# 3. Create two materials
	var red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED

	var blue_material = StandardMaterial3D.new()
	blue_material.albedo_color = Color.BLUE

	# 4. Create ball data
	var ball_data1 := BattleBallData.new()
	ball_data1.ball_name = "RedBall"
	ball_data1.core_ref = core
	ball_data1.shell_ref = shell
	ball_data1.material = red_material

	var ball_data2 := BattleBallData.new()
	ball_data2.ball_name = "BlueBall"
	ball_data2.core_ref = core
	ball_data2.shell_ref = shell
	ball_data2.material = blue_material

	# 5. Build and place the balls
	var ball1 = BallBuilder.build_ball(ball_data1)
	if ball1:
		ball1.position = Vector3(-10, 5, 0)
		ball1.apply_torque(Vector3(0, 1000, 0))
		add_child(ball1)

	var ball2 = BallBuilder.build_ball(ball_data2)
	if ball2:
		ball2.position = Vector3(10, 5, 0)
		ball2.apply_torque(Vector3(0, -1000, 0))
		add_child(ball2)
