extends MainLoop

func _ready():
    var scene = load("res://HelloWorld.tscn").instance()
    get_tree().root.add_child(scene)
    get_tree().connect("idle_frame", Callable(self, "_on_idle_frame"))

func _on_idle_frame(delta):
    # This is where we would update our game logic
    pass

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        print("Goodbye from Godot!")