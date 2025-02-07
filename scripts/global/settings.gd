extends Node

#temp settings for the player just so I can already add some settings logic for ceartain stuff

enum JumpBufferMode {
	DISABLED, ## No Jump Buffer
	TIMED, ## The Jump Input will be stored for a certain amount of time and then applied if the player is on the ground
	DYNAMIC ## Will use a Ground Check based on the players velocity to determine if the jump buffer should be activated where it then will be stored for a certain amount of time
}

@export var jump_buffer_mode:JumpBufferMode = JumpBufferMode.DYNAMIC