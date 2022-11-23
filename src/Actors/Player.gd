extends Actor

export var stomp_impulse = 1000.0

func _physics_process(delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	var direction = get_direction()
	velocity = calc_move_velocity(speed, direction, velocity, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	velocity = calc_stomp_velocity(velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	queue_free()
	
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") -
		Input.get_action_strength("move_left"), 
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calc_move_velocity(speed: Vector2, 
direction: Vector2, 
lin_velocity: Vector2,
is_jump_interrupted) -> Vector2:
	var new_velocity = lin_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
		
	return new_velocity
	
func calc_stomp_velocity(lin_velocity: Vector2, impulse: float) -> Vector2:
	var out = lin_velocity
	out.y = -impulse
	return out
	




