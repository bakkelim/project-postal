extends Node

enum States { SELECTING, PLACING }

var state: States = States.SELECTING
var tile_size: int = 64
