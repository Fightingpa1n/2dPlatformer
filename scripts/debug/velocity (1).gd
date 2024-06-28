extends Label


var player #player
var absolute #absolute
var velocity_x
var velocity_y
var center_x
var center_y
var arrows = {"up": "", "down": "", "left": "", "right": ""}

func _ready():
	player = get_parent().get_parent().get_node("%Player")
	
	absolute = get_node("../absolute")
	velocity_x = get_node("x")
	velocity_y = get_node("y")
	center_x = velocity_x.position + (velocity_x.get_rect().size / 2)
	center_y = velocity_y.position + (velocity_y.get_rect().size / 2)

	for ar in arrows: #create arrows
		var arrow = Sprite2D.new()
		add_child(arrow)
		arrow.texture = load("res://assets/sprites/debug/debug_arrow.png")
		arrow.region_enabled = true
		set_arrow(arrow, false)
		arrow.scale = Vector2(2.5,2.5)
		arrow.offset = Vector2(0, -10)
		arrows[ar] = arrow

	arrows['up'].position = center_y
	arrows['down'].position = center_y
	arrows['up'].rotation = deg_to_rad(0.0)
	arrows['down'].rotation = deg_to_rad(180.0)

	arrows['left'].position = center_x
	arrows['right'].position = center_x
	arrows['left'].rotation = deg_to_rad(270.0)
	arrows['right'].rotation = deg_to_rad(90.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var velocity = player.velocity

	if absolute.button_pressed:
		velocity_x.text = str(abs(velocity.x))
		velocity_y.text = str(abs(velocity.y))
	else:
		velocity_x.text = str(velocity.x)
		velocity_y.text = str(velocity.y)

	set_arrow(arrows['up'], velocity.y < 0)
	set_arrow(arrows['down'], velocity.y > 0)
	set_arrow(arrows['left'], velocity.x < 0)
	set_arrow(arrows['right'], velocity.x > 0)







func set_arrow(arrow, boolean):
	if boolean:
		arrow.region_rect = Rect2(10, 0, 9, 14)
	else:
		arrow.region_rect = Rect2(0, 0, 9, 14)
