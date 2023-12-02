extends Node

# @export var PlayerCharacter: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var direction := Input.get_vector("mov_left", "mov_right", "mov_up", "mov_down")
    $Character.move_dir(direction)
