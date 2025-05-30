extends Camera2D
class_name PlayerCamera

#this is the camera script, it handles the camera stuff

@onready var player:PlayerController = await NodeManager.get_player() #get the player

func _ready(): #Ready

    #connect Input
    InputManager.camera_zoom_in.connect("on_press", _on_zoom_in)
    InputManager.camera_zoom_out.connect("on_press", _on_zoom_out)
    InputManager.camera_reset.connect("on_press", _reset)


func _on_zoom_in(): #zoom in
    zoom += Vector2(0.1, 0.1)

func _on_zoom_out(): #zoom out
    zoom -= Vector2(0.1, 0.1)

func _reset():
    zoom = Vector2(1,1)
