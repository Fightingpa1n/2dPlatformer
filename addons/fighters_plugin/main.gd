@tool
extends EditorPlugin

var git

func _enter_tree():
	# Initialization of the plugin goes here.
	git = preload("scenes/git.tscn").instantiate()
	add_control_to_bottom_panel(git, "Git")

	add_tool_menu_item("Reload Plugins", reloadPlugins)

	# Reference:
	# Gets the directory icon for loading a resource in the Inspector
	#var gui = get_editor_interface().get_base_control()
	#var load_icon = gui.get_icon("Load", "EditorIcons")

	add_custom_type("Extend_Button", "Button", preload("nodes/expand_button.gd"), preload("assets/expand_button/icon.png"))
	add_custom_type("DebugRoot", "Control", preload("nodes/debug_root.gd"), preload("assets/expand_button/icon.png"))
	add_custom_type("DebugWindow", "DebugRoot", preload("nodes/debug_window.gd"), preload("assets/expand_button/icon.png"))

	pass

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(git)
	git.queue_free()
	remove_tool_menu_item("Reload Plugins")

	remove_custom_type("Extend_Button")
	remove_custom_type("DebugRoot")
	remove_custom_type("DebugWindow")
	pass



func reloadPlugins():
	print("Reloading plugins...")
	var plugins = []
	var dir = DirAccess.open("res://addons")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if dir.current_is_dir():
				if EditorInterface.is_plugin_enabled(str(file)):
					plugins.append(str(file))
					EditorInterface.set_plugin_enabled(str(file), false)					
			file = dir.get_next()
	else:
		print("Could not open directory.")
	for plugin in plugins:
		EditorInterface.set_plugin_enabled(plugin, true)