extends Node

class_name DataFactory

const CORE_PATH = "res://resources/cores"
const SHELL_PATH = "res://resources/shells"
const SPIRIT_PATH = "res://resources/spirits"

var _core_files: Array = []
var _shell_files: Array = []
var _spirit_files: Array = []

func _ready():
	_core_files = _scan_directory(CORE_PATH)
	_shell_files = _scan_directory(SHELL_PATH)
	_spirit_files = _scan_directory(SPIRIT_PATH)

func get_random_core() -> CoreResource:
	return _get_random_resource(_core_files, CORE_PATH)

func get_random_shell() -> ShellResource:
	return _get_random_resource(_shell_files, SHELL_PATH)

func get_random_spirit() -> SpiritResource:
	return _get_random_resource(_spirit_files, SPIRIT_PATH)

func _scan_directory(path: String) -> Array:
	var dir = DirAccess.open(path)
	if not dir:
		printerr("DataFactory: Could not open directory: ", path)
		return []

	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			files.append(file_name)
		file_name = dir.get_next()

	if files.is_empty():
		printerr("DataFactory: No .tres files found in ", path)

	return files

func _get_random_resource(files: Array, path: String):
	if files.is_empty():
		return null

	var random_file = files[randi() % files.size()]
	var resource = load(path.path_join(random_file))
	if not resource:
		printerr("DataFactory: Failed to load resource: ", random_file)
		return null

	return resource
