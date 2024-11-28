class_name ResidentState
extends State

const IDLE = "Idle"
const PRODUCING = "Producing"
const WAITING = "Waiting"
const DELIVERED = "Delivered"
const WALKING_TO_MAILBOX = "WalkingToMailbox"
const WALKING_TO_HOUSE = "WalkingToHouse"

const DATA_SELECTED_MAILBOX = "selected_mailbox"
const DATA_HAS_MAIL = "has_mail"

var resident: Resident


func _ready() -> void:
	await owner.ready
	resident = owner as Resident
	assert(
		resident != null,
		(
			"The ResidentState state type must be used only in the resident scene."
			+ " It needs the owner to be a Resident node."
		)
	)
