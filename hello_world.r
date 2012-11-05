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

view layout [
	backcolor gold
    h2 "Web Bookmarks"
    style btn btn 130
    btn "github" [browse "http://github.com"]
    h2 config_path
]




