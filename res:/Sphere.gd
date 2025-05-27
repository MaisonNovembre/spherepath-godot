extends Spatial

# Constants for trajectories
const PI = 3.14159265358979323846
const SPHERE_RADIUS = 10.0

# Parameters for each trajectory type
var trajectory_params = {
    "Trajectory1": {"type": "other_pole", "direction": 1, "rate": 0.5},
    "Trajectory2": {"type": "equator", "direction": -1, "rate": 0.3},
    "Trajectory3": {"type": "arbitrary_plane", "direction": 1, "rate": 0.4, "plane_normal": Vector3(0.5, 0.7, 0.5)},
    "Trajectory4": {"type": "exact_plane", "plane_normal": Vector3(0.8, 0.6, 0)}
}

func _ready():
    # Initialize positions of trajectory objects
    for node_name in trajectory_params.keys():
        var node = get_node(node_name)
        if node:
            node.translation = SPHERE_RADIUS * Vector3(0, 1, 0) # Start at north pole

func _process(delta):
    # Update positions of trajectory objects
    for node_name in trajectory_params.keys():
        var params = trajectory_params[node_name]
        var node = get_node(node_name)
        if node:
            update_trajectory(node, params, delta)

func update_trajectory(node: Spatial, params: Dictionary, delta: float):
    # Get current position
    var pos = node.translation

    # Calculate new position based on trajectory type
    var new_pos = Vector3()
    match params.type:
        "other_pole":
            new_pos = calculate_other_pole_trajectory(params, delta)
        "equator":
            new_pos = calculate_equator_trajectory(params, delta)
        "arbitrary_plane":
            new_pos = calculate_arbitrary_plane_trajectory(params, delta)
        "exact_plane":
            new_pos = calculate_exact_plane_trajectory(params, delta)

    # Update position
    node.translation = new_pos

func calculate_other_pole_trajectory(params: Dictionary, delta: float) -> Vector3:
    var t = params.t || 0.0
    t += params.rate * delta * params.direction
    if t > 1.0:
        t = 0.0 # Reset for continuous motion

    params.t = t

    var theta = PI * t
    var phi = params.rate * t * 5.0 # Multiply by factor for visible rotation

    return SPHERE_RADIUS * Vector3(
        sin(theta) * cos(phi),
        cos(theta),
        sin(theta) * sin(phi)
    )

func calculate_equator_trajectory(params: Dictionary, delta: float) -> Vector3:
    var t = params.t || 0.0
    t += params.rate * delta * params.direction
    if t > 1.0:
        t = 0.0 # Reset for continuous motion

    params.t = t

    var theta = PI / 2 + (1 - 1 / exp(params.rate * t * 5))
    var phi = params.rate * t * 5.0 # Multiply by factor for visible rotation

    return SPHERE_RADIUS * Vector3(
        sin(theta) * cos(phi),
        cos(theta),
        sin(theta) * sin(phi)
    )

func calculate_arbitrary_plane_trajectory(params: Dictionary, delta: float) -> Vector3:
    var t = params.t || 0.0
    t += params.rate * delta * params.direction
    if t > 1.0:
        t = 0.0 # Reset for continuous motion

    params.t = t

    var theta_0 = acos(params.plane_normal.y)
    var theta = theta_0 + params.rate * t * 2.0 # Multiply by factor
    var phi = params.rate * t * 5.0 # Multiply by factor for visible rotation

    return SPHERE_RADIUS * Vector3(
        sin(theta) * cos(phi),
        cos(theta),
        sin(theta) * sin(phi)
    )

func calculate_exact_plane_trajectory(params: Dictionary, delta: float) -> Vector3:
    var t = params.t || 0.0
    t += params.rate || 0.2 * delta * (params.direction || 1)
    if t > PI * 2:
        t = 0.0 # Reset for continuous motion

    params.t = t

    var theta_0 = acos(params.plane_normal.y)
    var phi = t

    return SPHERE_RADIUS * Vector3(
        sin(theta_0) * cos(phi),
        cos(theta_0),
        sin(theta_0) * sin(phi)
    )