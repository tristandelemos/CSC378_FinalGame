extends Node

class_name State 

var states : Array[State]

@export var return_state : State
@export var return_animation_node : String = "Move"
@export var can_move : bool = true
var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State

func state_input(_event):
	pass

func on_enter():
	pass
	
func on_exit():
	pass

func state_process(_delta):
	pass


