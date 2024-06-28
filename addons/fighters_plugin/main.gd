@tool
extends EditorPlugin

var git

func _enter_tree():
	# Initialization of the plugin goes here.
	git = preload("res://addons/fighters_plugin/scenes/git.tscn").instantiate()
	add_control_to_bottom_panel(git, "Git")

	add_tool_menu_item("Reload Plugins", reloadPlugins)
	pass

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(git)
	git.queue_free()
	remove_tool_menu_item("Reload Plugins")
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