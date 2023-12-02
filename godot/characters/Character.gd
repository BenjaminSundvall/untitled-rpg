extends CharacterBody2D

# Movement
@export var movement_speed : float = 800.0
@export var grid_locked : bool = false
@export var in_combat : bool = false
var heading : int = 3
const NUM_DIRECTIONS = 8

# Combat
@export var max_health : float = 100
@export var health : float = max_health
@export var atb_level : int = 3
@export var atb_charge_time : float = 4.2


func _physics_process(delta: float) -> void:
    pass
    

func move_dir(direction : Vector2):
    if direction:
        var angle_deg = rad_to_deg(direction.angle())
        self.heading = int(round(NUM_DIRECTIONS * angle_deg / 360) + NUM_DIRECTIONS + 1) % NUM_DIRECTIONS      # 45 degree increments
        print(self.heading)
        $AnimatedSprite2D.play("run_" + str(self.heading))
    else:
        $AnimatedSprite2D.play("idle_" + str(self.heading))

    self.velocity = direction * self.movement_speed * Vector2(1, 0.5)
    move_and_slide()
