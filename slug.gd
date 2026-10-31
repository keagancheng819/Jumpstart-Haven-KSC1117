extends Area2D

func _ready() -> void:
	# Connect the body_entered signal via script or Node dock
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding object has the eat_slug function
	if body.has_method("eat_slug"):
		body.eat_slug()
		queue_free() # Remove the slug from the scene
