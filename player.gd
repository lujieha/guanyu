extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_body: Sprite2D = $PlayerBody



func _physics_process(delta: float) -> void:
	var x_input = Input.get_axis("ui_left","ui_right")
	velocity.x = x_input *100
	#
	
	if not is_on_floor():
		velocity.y += 80 * delta
	
	if x_input==0:
		animation_player.play("stand")
	else:	
		print(sign(x_input))
		animation_player.play("run")
		player_body.scale.x= sign(x_input)
		
		
	
	move_and_slide()
