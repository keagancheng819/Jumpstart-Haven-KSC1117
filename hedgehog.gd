extends CharacterBody2D

# Movement Parameters
@export var speed: float = 200.0
@export var jump_velocity: float = -600.0

# Get default gravity from project settings
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Score tracking
var slugs_eaten: int = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Handle Horizontal Movement
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
		if animated_sprite:
			animated_sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# 4. Apply Physics
	move_and_slide()

	# 5. Handle Animations
	if animated_sprite and animated_sprite.sprite_frames:
		update_animation(direction)

func update_animation(direction: float) -> void:
	if not is_on_floor():
		if animated_sprite.animation != "jump":
			animated_sprite.play("jump")
	elif direction != 0:
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

func eat_slug() -> void:
	slugs_eaten += 1
	print("Slugs eaten: ", slugs_eaten)

func hit_by_fox() -> void:
	print("Game Over! A fox caught the hedgehog.")
	# Safe reload check
	if get_tree().current_scene != null:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://main.tscn")
