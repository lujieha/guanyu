extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_body: Sprite2D = $PlayerBody



@export var walk_speed: float = 100.0      # 移动速度
@export var jump_velocity: float = -300.0  # 跳跃初速度（负值向上）
@export var gravity: float = 400.0          # 重力加速度

func _physics_process(delta: float) -> void:
	# 水平移动
	var x_input = Input.get_axis("ui_left", "ui_right")
	velocity.x = x_input * walk_speed
	
	# 跳跃输入
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity
	
	# 重力（只在空中时生效）
	if not is_on_floor():
		velocity.y += gravity * delta
		animation_player.play("jump")
	
	# 动画处理
	if x_input == 0:
		if is_on_floor():  # 只有在地面才播放站立
			animation_player.play("stand")
	else:
		if is_on_floor():  # 只有在地面才播放跑步
			animation_player.play("run")
		player_body.scale.x = sign(x_input)
	
	move_and_slide()
