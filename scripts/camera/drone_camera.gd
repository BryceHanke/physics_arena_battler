extends Camera3D

class_name DroneCamera

@export var movement_speed: float = 10.0
@export var sensitivity: float = 0.1
@export var damping: float = 0.9

private var _velocity: Vector3 = Vector3.ZERO
private var _yaw: float = 0.0
private var _pitch: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		_yaw -= event.relative.x * sensitivity
		_pitch -= event.relative.y * sensitivity
		_pitch = clamp(_pitch, -90.0, 90.0)
		transform.basis = Basis.from_euler(Vector3(deg_to_rad(_pitch), deg_to_rad(_yaw), 0))

func _physics_process(delta):
	var input_dir = Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_pressed("camera_up"):
		direction.y += 1.0
	if Input.is_action_pressed("camera_down"):
		direction.y -= 1.0

	_velocity = _velocity.lerp(direction * movement_speed, 1.0 - pow(damping, delta))
	global_translate(_velocity * delta)
