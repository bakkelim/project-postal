class_name PostmanState
extends State

const START_TASK = "StartTask"
const WALKING_TO_MAILBOX = "WalkingToMailbox"
const COLLECTED = "Collected"
const WALKING_TO_POST_OFFICE = "WalkingToPostOffice"
const SORTING = "Sorting"

const DATA_SELECTED_MAILBOX = "selected_mailbox"
const DATA_MAILBOXES_TO_VISIT = "mailboxes_to_visit"

var postman: Postman


func _ready() -> void:
	await owner.ready
	postman = owner as Postman
	assert(
		postman != null,
		(
			"The PostmanState state type must be used only in the postman scene."
			+ " It needs the owner to be a Postman node."
		)
	)
