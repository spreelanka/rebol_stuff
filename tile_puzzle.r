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




;imgs: copy []
;size: 300x300  ; width and height of each subimage
;xy: 0x0
;height: 450
;image_two: copy/part image height
;change/dup at image_two 10x20 blue 40x30

; at image 50x50 0x0

comment[
repeat y 3 [
    repeat x 3 [
        xy: size * as-pair x -1 y -1
        print xy
        append imgs copy/part at image xy size
    ]
]
]

empty_game_square: 2x2

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

tile_click_feel: func [face action event] [
            if action = 'down [face/data: event/offset]
            if find [up] action [
            	tile_loc: ( (face/offset - 20x38 ) / 150x150 )
            	movement: 0x0 ;nothing, but we need to initialize it
            	if is_adjacent? tile_loc empty_game_square [
            		movement: (empty_game_square - tile_loc) * 150x150
            		print "we are adjacent"
            		empty_game_square: tile_loc
            	]

            	final_offset: face/offset + movement
            	increment: movement / 10
        		while [ not-equal? face/offset final_offset] [
                	face/offset: face/offset + increment
                	wait 0.008
                	show face
                ]


                keys: probe first face
                key: probe keys/2
                print face/offset
                print face/offset / 150x150
                print tile_loc
                ;print key ;get in face key
                ;print face/data
                ;alert probe first face
            ]
        ]
image_path: %ship.jpg
main_layout: layout [
	backcolor gold
    ;h2 "Web Bookmarks"
    ;style btn btn 130
    ;btn "github" [browse "http://github.com"]
    ;h2 config_path
    pos: vh1 10x10

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
    ;tile22: box image_path 150x150 effect [crop 300x300 150x150 fit] feel [ 
    ;	engage: :tile_click_feel
    ;]
    return
    below




    ;image11: image 150x150 img
    
    ;img_from_file: image %internet_ship_small.jpg 450x450 300x300
    
    ;ti01: box white 150x150 effect [draw image11]

    ;ti00: box 450x450 effect [draw img_from_file]

]

;print probe first main_layout
is_adjacent? 0x0 2x2
is_adjacent? 1x1 1x2
is_adjacent? 1x1 2x1
is_adjacent? 0x0 0x0

view main_layout


