@tool
extends Control

# Vars
var refresh_button
var staged_list
var file_list
var message_box
var commit_button

func _enter_tree():
	# Elements
	refresh_button = $refresh
	staged_list = $staged_list
	file_list = $file_list
	message_box = $message
	commit_button = $commit

	# Signals
	refresh_button.connect("pressed", self, "_on_refresh_button_pressed")
	file_list.connect("item_clicked", self, "_on_file_clicked")
	staged_list.connect("item_clicked", self, "_on_staged_clicked")
	commit_button.connect("pressed", self, "_on_commit_button_pressed")

	# Initial refresh to populate file list
	_on_refresh_button_pressed()

func _on_refresh_button_pressed():
	var output = []
	OS.execute("git status -s", [], [], output)
	file_list.clear()
	staged_list.clear()
	
	for line in output:
		var file_name = line.split(" ")[1]
		if line.starts_with("M"):
			staged_list.add_item(file_name)
		else:
			file_list.add_item(file_name)
	print("File list refreshed")

func _on_file_clicked(index, _at_position, _mouse_button_index):
	var file_name = file_list.get_item_text(index)
	var output = []
	OS.execute("git add " + file_name, [], [], output)
	if output.empty():
		staged_list.add_item(file_name)
		file_list.remove_item(index)
		print("File staged: ", file_name)
	else:
		_error("Failed to stage file: " + file_name)

func _on_staged_clicked(index, _at_position, _mouse_button_index):
	var file_name = staged_list.get_item_text(index)
	var output = []
	OS.execute("git reset %s" % file_name, [], [], output)
	if output.empty():
		file_list.add_item(file_name)
		staged_list.remove_item(index)
		print("File unstaged: ", file_name)
	else:
		_error("Failed to unstage file: " + file_name)

func _on_commit_button_pressed():
	var commit_message = message_box.text.strip_edges()
	if commit_message.empty():
		_error("Commit message cannot be empty")
		return
	
	var output = []
	OS.execute("git commit -m %s" % commit_message.quote(), [], [], output)
	if "nothing to commit" in output.join(" "):
		_error("No changes to commit")
	else:
		print("Committed with message: ", commit_message)
		message_box.text = ""
		_on_refresh_button_pressed()

func _error(message):
	var error_window = AcceptDialog.new()
	add_child(error_window)
	error_window.set_title("Error")
	error_window.set_text(message)
	error_window.popup_centered()
