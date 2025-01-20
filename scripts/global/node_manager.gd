extends Node

#this is the Node Manager, it's an Global Script that holds all the important nodes in the game to quickly access them from anywhere

@onready var main:Node2D = get_tree().root.get_node("Main")
func get_main() -> Node2D:
    return main

#=== Player ===#
var player:CharacterBody2D #the player
func get_player() -> CharacterBody2D:
    if not player: #if the player is not set
        if await _is_main_ready(): #if the main node is ready
            player = main.get_node("%Player") #get the player
            if not player.is_node_ready():
                await player.ready
    return player

#=== Camera ===#
var camera:Camera2D #the camera
func get_camera() -> Camera2D:
    if not camera: #if the camera is not set
        if await _is_main_ready(): #if the main node is ready
            camera = main.get_node("%MainCamera") #get the camera
            if not camera.is_node_ready():
                await camera.ready
    return camera

#=== UI ===#
var ui:CanvasLayer #the ui
func get_ui() -> CanvasLayer:
    if not ui: #if the ui is not set
        if await _is_main_ready(): #if the main node is ready
            ui = camera.get_node("%UI") #get the ui
            if not ui.is_node_ready():
                await ui.ready
    return ui

# #=== Debug ===#
# var debug:Control #the debug draw script/node
# func get_debug() -> Control:
#     if not debug: #if the debug is not set 
#         if await _is_main_ready(): #if the main node is ready
#             debug = (await get_ui()).get_node("%Debug")
#             if not debug.is_node_ready():
#                 await debug.ready
#     return debug


#========= Private Functions =========#
func _is_main_ready() -> bool:
    if not main:
        main = get_tree().root.get_node("Main")
    if not main.is_node_ready():
        await main.ready
    return true