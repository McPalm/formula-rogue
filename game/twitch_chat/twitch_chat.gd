extends Control

var names:Array[String] = ["Bit", "Gangrene", "Sondy", "Noteworthy", "BizarreSong", "SugarMorning", "Filly", "Porona", "Mark", "Aaron", "Ligma", "Strongboy99", "Nitz", "Qwerty", "Waldo", "Enui", "Rickard", "Roach", "Yplmis", "Ugandan Knuckles", "IJTP", "OP34", "Pal", "DoeStreamLive", "Chessynut", "AProblem", "Sekhmet", "Dragon07", "FF20", "GGNoRe", "Ham", "Jotun", "Kyle89", "Larry01", "Zach", "IsThisLoss", "TheGame", "Xenophile", "BannedUser", "NightGlyder", "CarlSagan42", "Vinner", "B0b", "Nick", "Mammon"]
var colors:Array[String] = ["blue", "green", "red", "purple", "orange", "yellow", "cyan"]

var spam:Array[String] = ["Chat is moving so fast noone will know I am gay.", "I just joined, what is going on?", "Shout out to Simpleflips", "Stream is lagging", "[message deleted]", "!enter", "?lmao", "Car time!", "Who won last round?", "Good Morning!", "Easy", "You should have drifted there!", "Have you tried not sucking?", "Idiot, 34 never read chat.", "Brb making breakfast", "Can you pause the stream, Im need to go to the bathroom.", "Hi!"]

var adds:Array[String] = ["Add, pog", "Melons!", "Hail capitalism", "I Love to Consume Product!", "My addblocker doesn't work.", "Sellout", "Snoooore", "Melon", "Meeeelon", "OMG I NEED THIS!", "I am a real human being and I reccomend this product!", "Shill", "Shill", "Shill", "Shill", "Shill", "Shill", "Add?", "Who is that?", "More car!", "Add", "Add", "Add!", "Add!", "add", "add", "ADd!"]
var reset:Array[String] = ["Lmao", "lol", "Skill issue", "Have you tried turning?", "Turn?", "Turning?", "Please turn", "Please just do better", "lol", "Omegalul", "kek", "sand gang", "SAND GANG", "Sand gang", "Sand gang", "Sand Gang", "Sand Gang", "I LOVE eating dirt", "Lmao", "This driver is so bad", "Who got this guy to drive?", "Youre supposed to be ON the road!", "SMH my whole head.", "kek", "o7", "o7", "o7", "o7"]
var lap:Array[String] = ["Hype!", "Pog!", "POG", "Lets fucking goooo", "LETS GO!", "WOO!", "Lets go!", "poggers", "omegapog", "Lets go!", "Nooo, my bet!", "please crash this lap!", "Winning!", "Fucking lests go!", "poG"]
var game_over:Array[String] = ["lol", "god job!", "WINNIGN BIG!", "GO next!", "o7", "NOOOOOO!", "lmao", "go next", "go next!", "GG", "Nice driving!", "LMAO, 34 cant drive", "Sucks at driving", "GOOD RACE!", "So close!"]
var win:Array[String] = ["Noooo!", "YES", "POG", "omegapog", "WOOO", "WInning big", "gg"]

func _ready() -> void:
	$RichTextLabel.clear()

func _open_chat() -> void:
	$RichTextLabel.clear()
	show()
	while true:
		for n in 100:
			await get_tree().create_timer(randf() * 2.0).timeout
			push_message(spam.pick_random())
		$RichTextLabel.clear()

func push_message(message:String) -> void:
	$RichTextLabel.append_text("\n[b][color=%s]%s:[/color][/b] %s" % [colors.pick_random(), names.pick_random(), message])

func push_message_after_delay(message:String) -> void:
	await get_tree().create_timer(1.5 + min(randf() * 15, randf() * 15)).timeout
	push_message(message)

func stagger_array(array:Array[String]) -> void:
	for n in 25:
		push_message_after_delay(array.pick_random())

func add_read() -> void:
	stagger_array(adds)

func new_lap(_lap:int) -> void:
	stagger_array(lap)

func reset_car() -> void:
	stagger_array(reset)

func on_game_over() -> void:
	stagger_array(game_over)

func on_win() -> void:
	stagger_array(win)
