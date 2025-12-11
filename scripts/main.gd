extends Node3D

# Preload the necessary scripts and resources
const BallBuilder = preload("res://scripts/ball_builder.gd")
const BattleBallData = preload("res://scripts/resources/battle_ball_data.gd")
const CoreResource = preload("res://scripts/resources/core_resource.gd")
const ShellResource = preload("res://scripts/resources/shell_resource.gd")

func _ready():
    # 1. Create a placeholder Core
    var core := CoreResource.new()
    core.mass = 50.0
    core.com_offset = Vector3(0, -0.2, 0) # Lower center of mass for stability

    # 2. Create a placeholder Shell
    var shell := ShellResource.new()
    shell.friction = 0.6
    shell.bounce = 0.4

    # Create a simple sphere mesh and collider for the shell
    var sphere_mesh := SphereMesh.new()
    sphere_mesh.radius = 1.0
    sphere_mesh.height = 2.0
    shell.mesh = sphere_mesh

    var sphere_shape := SphereShape3D.new()
    sphere_shape.radius = 1.0
    shell.collider = sphere_shape

    # 3. Create the main BattleBallData container
    var ball_data := BattleBallData.new()
    ball_data.ball_name = "TestBall"
    ball_data.core_ref = core
    ball_data.shell_ref = shell
    # No spirit for this test

    # 4. Build the ball using the BallBuilder
    var test_ball := BallBuilder.build_ball(ball_data)

    # 5. Position and add the ball to the scene
    if test_ball:
        test_ball.position = Vector3(0, 5, 0) # Start 5 units above the floor
        add_child(test_ball)
    else:
        printerr("Failed to build the test ball.")
