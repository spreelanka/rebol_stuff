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
	size 1250x900
	
]

card_over_feel: func [face action position] [
	if action [
		if  select main_layout/pane face [
			remove find main_layout/pane face ;;this brings face to front
			append main_layout/pane compose/deep face
			for i 1 10000 100 [

				cr: create_card i
				cr/feel: []
				show cr
				show main_layout
				wait 0.5
			]
			show main_layout
		]
	]
]

card_engage_feel: func [f a e] [  ;intercepts target face events
	
	if/else all[f/data f/data/2 (f/data/2 == f/offset ) (find [up] a) ] [
		
		if/else f/size/1 < f/size/2 [
			f/effect: [rotate 90]
		] [
			f/effect: [rotate 0]
		]
		f/size: reverse f/size

		show f

		print "we got a click!"
		for i 200000 270000 500 [

			cr: create_card i
			cr/feel: []
			show cr
			show main_layout
			view main_layout
			wait 0.5
		]
	] [
		if all[( find [over away] a )  (not find [up] a) ] [

			f/offset: confine f/offset + e/offset - f/data/1 f/size
				0x0 f/parent-face/size
			show f
		]
		if a = 'down [
		f/data: array 0
		append f/data e/offset
		append f/data f/offset
		]
	]
	
]
;'

create_card: func [wotc_id] [
	card_reference: []
	img: get_image_path wotc_id
	card: layout [c: box (img) feel[ over: :card_over_feel engage: :card_engage_feel ]
		do[
			card_reference: c
		]
	]
	remove find card/pane c

	append main_layout/pane compose/deep card_reference
	
	show main_layout
	return card_reference
]



for i 1 1 1 [

	cr: create_card i
	cr/offset: (cr/size * 1x0 * ((i - 1) // 5) ) + (cr/size * 0x1 * (to-integer ((i - 1) / 5 )) ) 
	
	;cr/feel: []
	
]





view main_layout



