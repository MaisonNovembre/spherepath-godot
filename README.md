# Sphere Trajectories in Godot

This is a Godot 4.4 project that demonstrates four different types of trajectories on the surface of a sphere:

1. Asymptotic spiral towards the other pole
2. Asymptotic spiral towards the equator
3. Asymptotic spiral towards an arbitrary planar section
4. Exact trajectory along an arbitrary plane

## Project Structure

- `project.godot`: Godot project configuration file
- `res://Main.tscn`: Main scene with sphere, camera, and trajectory objects
- `res://Sphere.gd`: Main script that calculates trajectories

## Trajectory Types

The script implements four types of trajectories as described in the documentation:

1. **Asymptotic spiral towards the other pole**: Spirals from one pole to the opposite pole.
2. **Asymptotic spiral towards the equator**: Spirals from a pole towards the equator.
3. **Asymptotic spiral towards an arbitrary planar section**: Spirals towards any plane intersecting the sphere.
4. **Exact trajectory along an arbitrary plane**: Follows a path exactly within a specific plane.

## How to Run

1. Open this project in Godot 4.4
2. Press F5 to run the scene
3. Observe the four small spheres following different trajectories on the surface of the larger sphere

## Parameters

Each trajectory type has its own set of parameters that control its behavior:
- Direction (clockwise or counterclockwise)
- Rate of spiral
- Plane orientation for arbitrary plane trajectories