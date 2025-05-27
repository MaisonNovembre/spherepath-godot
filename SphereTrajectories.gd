extends Node3D

# Constants for trajectory types
const TRAJECTORY_POLE_TO_POLE = 1
const TRAJECTORY_POLE_TO_EQUATOR = 2
const TRAJECTORY_POLE_TO_PLANE = 3
const TRAJECTORY_EXACT_PLANE = 4

# Parameters for trajectories
var trajectory_type = TRAJECTORY_POLE_TO_POLE
var pole_of_origin = Vector3(0, 1, 0) # North Pole by default (0, 1, 0)
var direction_clockwise = true
var spiral_rate = 2.0
var plane_normal = Vector3(0, 0, 1) # Plane normal vector for TRAJECTORY_POLE_TO_PLANE and TRAJECTORY_EXACT_PLANE

# Internal variables
var elapsed_time = 0.0
var sphere_radius = 5.0

func _ready():
	# Set up the scene (sphere and trajectory objects)
	var sphere = SphereMesh.new()
	sphere.radius = sphere_radius
	var sphere_node = MeshInstance3D.new()
	sphere_node.mesh = sphere
	add_child(sphere_node)

	# Add a camera to view the trajectories
	var camera = Camera3D.new()
	camera.translation = Vector3(10, 10, 10)
	camera.look_at(Vector3.ZERO)
	add_child(camera)
	
func _process(delta):
	elapsed_time += delta

	# Clear previous trajectory points
	for child in get_children():
		if child is PathFollow3D:
			child.queue_free()

	# Generate new trajectory based on selected type
	var trajectory_points = []
	match trajectory_type:
		TRAJECTORY_POLE_TO_POLE:
			trajectory_points = generate_pole_to_pole_trajectory(elapsed_time)
		TRAJECTORY_POLE_TO_EQUATOR:
			trajectory_points = generate_pole_to_equator_trajectory(elapsed_time)
		TRAJECTORY_POLE_TO_PLANE:
			trajectory_points = generate_pole_to_plane_trajectory(elapsed_time)
		TRAJECTORY_EXACT_PLANE:
			trajectory_points = generate_exact_plane_trajectory(elapsed_time)

	# Create PathFollow3D nodes to visualize the trajectory
	for i in range(trajectory_points.size() - 1):
		var curve = Curve3D.new()
		curve.add_point(trajectory_points[i])
		curve.add_point(trajectory_points[i + 1])

		var path = PathFollow3D.new()
		path.path = curve
		add_child(path)
		
func generate_pole_to_pole_trajectory(time):
	# Asymptotic spiral from pole to opposite pole
	var points = []
	for t in range(0, int(time * 100)):
		var normalized_t = float(t) / 100.0
		var theta = PI * normalized_t
		var phi = spiral_rate * normalized_t

		if direction_clockwise:
			phi = -phi

		var point = spherical_to_cartesian(theta, phi)
		points.append(point)

	return points
	
func generate_pole_to_equator_trajectory(time):
	# Asymptotic spiral from pole to equator
	var points = []
	for t in range(0, int(time * 100)):
		var normalized_t = float(t) / 100.0
		var theta = PI / 2 + (1 - exp(-normalized_t * spiral_rate))
		var phi = spiral_rate * normalized_t

		if direction_clockwise:
			phi = -phi

		var point = spherical_to_cartesian(theta, phi)
		points.append(point)

	return points
	
func generate_pole_to_plane_trajectory(time):
	# Asymptotic spiral towards an arbitrary plane
	var points = []
	for t in range(0, int(time * 100)):
		var normalized_t = float(t) / 100.0
		var theta = PI / 4 + normalized_t * spiral_rate # Just a sample value
		var phi = spiral_rate * normalized_t

		if direction_clockwise:
			phi = -phi

		var point = spherical_to_cartesian(theta, phi)
		points.append(point)

	return points

func generate_exact_plane_trajectory(time):
	# Exact trajectory along an arbitrary plane
	var points = []
	for t in range(0, int(time * 100)):
		var normalized_t = float(t) / 100.0
		var theta = PI / 4 # Constant angle for a specific plane
		var phi = 2 * PI * normalized_t

		if direction_clockwise:
			phi = -phi

		var point = spherical_to_cartesian(theta, phi)
		points.append(point)

	return points
	
	
func spherical_to_cartesian(theta, phi):
	var x = sphere_radius * sin(theta) * cos(phi)
	var y = sphere_radius * cos(theta)
	var z = sphere_radius * sin(theta) * sin(phi)
	return Vector3(x, y, z)
