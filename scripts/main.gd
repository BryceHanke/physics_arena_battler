extends Node3D

# Preload the necessary scripts and resources
const BallBuilder = preload("res://scripts/balls/ball_builder.gd")
const BattleBallData = preload("res://scripts/balls/battle_ball_data.gd")
const DataFactory = preload("res://scripts/data_factory.gd")

@export var ball_count: int = 10
@export var launch_speed: float = 500.0

var data_factory: DataFactory

func _ready():
	data_factory = DataFactory.new()
	add_child(data_factory)

	for i in range(ball_count):
		# 1. Get random core and shell
		var core = data_factory.get_random_core()
		var shell = data_factory.get_random_shell()

		if not core or not shell:
			printerr("Main: Failed to get core or shell resource. Skipping ball creation.")
			continue

		# 2. Create a random material
		var material = StandardMaterial3D.new()
		material.albedo_color = Color.from_hsv(randf(), 1.0, 1.0)

		# 3. Create ball data
		var ball_data = BattleBallData.new()
		ball_data.ball_name = "Ball_" + str(i + 1)
		ball_data.core_ref = core
		ball_data.shell_ref = shell
		ball_data.material = material

		# 4. Build and place the ball
		var ball = BallBuilder.build_ball(ball_data)
		if ball:
			var position = Vector3(randf_range(-15, 15), 5, randf_range(-15, 15))
			var torque = Vector3(randf_range(-1000, 1000), randf_range(-1000, 1000), randf_range(-1000, 1000))

			ball.position = position
			ball.apply_torque(torque)

			# Calculate tangential impulse
			var center_to_ball_xz = Vector3(position.x, 0, position.z)
			if center_to_ball_xz.length() > 0: # Avoid division by zero if ball is at center
				var tangent = Vector3(-center_to_ball_xz.z, 0, center_to_ball_xz.x).normalized()
				var upward_component = Vector3(0, randf_range(0.2, 0.5), 0)
				var launch_direction = (tangent + upward_component).normalized()
				ball.apply_central_impulse(launch_direction * launch_speed)

			add_child(ball)
