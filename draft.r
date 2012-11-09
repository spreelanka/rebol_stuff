REBOL []

;;we really need a legitimate guid solution but i havent found one thats cross platform
;;so this is a temporary solution that we can easily replace later
guid_counter: 0 
get_guid: func [] [
	return guid_counter: guid_counter + 1
]


get_image_path: func [id] [
	path: join http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid= [id "&type=card"]
	print path
	return  compose/deep load-thru/binary path
]


main_layout: layout [
	backcolor gray
	size 450x900
]

card_over_feel: func [face action position] [
	if action [
		if  select main_layout/pane face [
			remove find main_layout/pane face ;;this brings face to front
			append main_layout/pane compose/deep face
			show main_layout
		]
		
	]

]


create_card: func [wotc_id] [
	card_reference: []
	img: get_image_path wotc_id
	card: layout [c: box (img) feel[ over: compose/deep :card_over_feel ]
		do[
			card_reference: c
		]
	]
	remove find card/pane c

	insert main_layout/pane compose/deep card_reference
	
	show main_layout
	return card_reference
]

for i 1 10 1 [
	cr: create_card i
	cr/offset: (100x100 * (i - 1))
	
]



view main_layout

