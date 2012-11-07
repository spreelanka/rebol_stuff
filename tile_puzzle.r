REBOL []
arguments: system/options/args
config_path: "no config passed"
if all [
	not none? arguments
	not empty? arguments
	not empty? select arguments "--config"
	][
	
	config_path: select arguments "--config"
]


empty_game_square: 2x2
game_has_ended: false

;;game_tiles will contain a k:v pairs of the correct coordinates for the tile and a reference to the tile face
game_tiles: []

image_path: load-thru/binary http://i.imgur.com/bilGF.jpg

;;image is 450x450, game board is 3x3 so tile size is 150x150
tile_size: 150x150

random/seed now
tile_order: random [ 0x0 1x0 2x0 0x1 1x1 2x1 0x2 1x2]


;;takes arguments such as 0x0 1x0 2x0 etc and returns true if they are adjacent
is_adjacent?: func [loc1 loc2][

	print abs loc1 - loc2
	print (abs loc1 - loc2) / 1x1
	check: ( (abs loc1 - loc2) / 1x1)
	result: (check == 0x1) or (check == 1x0) ;or (check == 0x0) (check == 1x1) or 
	if/else result and not (loc1 == loc2) [
		return true
	] [
		return false
	]
]

;;action taken when a tile piece is clicked
;;if an adjacent tile location is empty, moves clicked piece to that location
;;then checks for a win
tile_click_feel: func [face action event] [
            if action = 'down [face/data: event/offset]
            if all[ (find [up] action) (not game_has_ended) ] [
            	tile_loc: ( (face/offset - 0x0 ) / tile_size )
            	
            	movement: 0x0 ;;nothing, but we need to initialize it
            	

            	if is_adjacent? tile_loc empty_game_square [
            		
            		movement: (empty_game_square - tile_loc) * tile_size

            		empty_game_square: tile_loc

            		;;this is just to move with some animation
	            	final_offset: face/offset + movement
	            	increment: movement / 10
	        		while [ not-equal? face/offset final_offset] [
	                	face/offset: face/offset + increment
	                	wait 0.008
	                	show face
	                ]
	                
	                ;check if all tiles are in the correct location
            		game_lost: false
            		foreach k tile_order [

            			tile: select game_tiles k

            			if k <> (tile/offset / tile_size) [
            				game_lost: true

            			]
            		]
            		

            		if not game_lost [
            			;;all tiles are in the right place
            			game_has_ended: true

            			final_tile: select game_tiles 2x2

            			append main_layout/pane final_tile

            			final_tile/offset: 2x2 * tile_size
            			show main_layout

            			alert "YOU WON! restart to play again"

            		]
            	]
            ]
        ]


main_layout: layout [
	backcolor gray
	size 450x450

    across
    tile00: box image_path 150x150 effect [crop 0x0 150x150 aspect] feel [ 
    	engage: :tile_click_feel
    ]
    tile01: box image_path 150x150 effect [crop 150x0 150x150 aspect] feel [ 
    	engage: :tile_click_feel
    ]
    tile02: box image_path 150x150 effect [crop 300x0 150x150 fit] feel [ 
    	engage: :tile_click_feel
    ]
    return
    tile10: box image_path 150x150 effect [crop 0x150 150x150 fit] feel [ 
    	engage: :tile_click_feel
    ]
    tile11: box image_path 150x150 effect [crop 150x150 150x150 fit] feel [ 
    	engage: :tile_click_feel
    ]
    tile12: box image_path 150x150 effect [crop 300x150 150x150 fit] feel [ 
    	engage: :tile_click_feel
    ]
    return
    tile20: box image_path 150x150 effect [crop 0x300 150x150 fit] feel [ 
    	engage: :tile_click_feel
    ]
    tile21: box image_path 150x150 effect [crop 150x300 150x150 fit] feel [ 
    	engage: :tile_click_feel
    ]
    tile22: box image_path 150x150 effect [crop 300x300 150x150 fit]
    
    do [
    	

    	tile00/offset: tile_order/1 * tile_size
    	;tile00/data: 0x0
    	append game_tiles 0x0
    	append game_tiles :tile00
    	 

    	tile01/offset: tile_order/2 * tile_size
    	;tile01/data: 1x0
    	append game_tiles 1x0
    	append game_tiles :tile01
    	

		tile02/offset: tile_order/3 * tile_size
		;tile02/data: 2x0
		append game_tiles 2x0
		append game_tiles :tile02
		

		tile10/offset: tile_order/4 * tile_size
		;tile10/data: 0x1
		append game_tiles 0x1
		append game_tiles :tile10
		

		tile11/offset: tile_order/5 * tile_size
		;tile11/data: 1x1
		append game_tiles 1x1
		append game_tiles :tile11
		

		tile12/offset: tile_order/6 * tile_size
		;tile12/data: 2x1
		append game_tiles 2x1
		append game_tiles :tile12
		

		tile20/offset: tile_order/7 * tile_size
		;tile20/data: 0x2
		append game_tiles 0x2
		append game_tiles :tile20
		

		tile21/offset: tile_order/8 * tile_size
		;tile21/data: 1x2
		append game_tiles 1x2
		append game_tiles :tile21

		;;this is the final tile
		tile22/offset: 2x2 * tile_size
		append game_tiles 2x2
		append game_tiles :tile22
		


    ]


]


;;dont show the final piece yet
remove find main_layout/pane tile22
show main_layout


view main_layout


