class_name Action extends Resource

@export var name : String
@export var charge_cost : int

func _init() -> void:
    print("WARNING: Initialized action is not implemented!")

func _to_string() -> String:
    return self.name

func perform_action() -> void:
    print("WARNING: Performed action is not implemented!")
