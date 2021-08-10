name = "G10MM-3R"
description = "Automate gathering resources!\nVersion: 1.35\n\nChangelog:\n- G10MM-3R cannot be built on boats anymore (to prevent crashes)."
author = "<default>"
version = "1.35"

forumthread = "https://steamcommunity.com/sharedfiles/filedetails/?id=1628298090"

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
"robobee", "robot glommer", "g10mm-3R","creature"
}

--priority = 257
id = "robobeemod"

configuration_options = {
	{ 
		name = "robobeestatuerecipeconfig",
		label = "G10MM-3R Base Recipe",
		options =
		{
			{description = "Easy", hover = "1 Gears + 1 Glommer's Flower + 1 Glommer's Wings", data = 1},
			{description = "Default", hover = "2 Gears + 1 Glommer's Flower + 1 Glommer's Wings", data = 2},
			{description = "Hard", hover = "3 Gears + 1 Glommer's Flower + 1 Glommer's Wings", data = 3},
		},
		default = 2,
	},
	{ 
		name = "robobeetechconfig",
		label = "Recipe's availability",
		options =
		{
			{description = "Obtainable", hover = "Recipe must be obtained by killing bosses or mining Glommer's Statue.", data = 1},
			{description = "Shadow Manipulator", hover = "Recipe is unlockable via Shadow Manipulator.", data = 2},
			{description = "Prestihatitator", hover = "Recipe is unlockable via Prestihatitator.", data = 3},
			{description = "Alchemy Engine", hover = "Recipe is unlockable via Alchemy Engine.", data = 4},
			{description = "Science Machine", hover = "Recipe is unlockable via Science Machine.", data = 5},
			{description = "No unlock needed", hover = "Recipe is available from the start.", data = 6},
		},
		default = 1,
	},
	{ 
		name = "chesticeboxconfig",
		label = "G10MM-3R's Base Container is",
		--hover	= "Choose the container, which should spawn.",
		options =
		{
			{description = "Chest", data = 1},
			{description = "Icebox", data = 0},
		},
		default = 1,
	},
	{ 
		name = "includestructures",
		label = "Can target structures",
		options =
		{
			{description = "No", hover	= "G10MM-3R will ignore structures.", data = 1},
			{description = "Yes", hover	= "G10MM-3R can target Farms, Bee Boxes and Drying Racks.", data = 2},
		},
		default = 1,
	},
	{ 
		name = "whentoharvest",
		label = "Harvest when the target",
		options =
		{
			{description = "Is full", hover	= "G10MM-3R will harvest Bee Boxes, etc. only when they're full.", data = 1},
			{description = "Is halfway full", hover	= "G10MM-3R will harvest Bee Boxes, etc. when they're at least halfway full.", data = 2},
			{description = "Always", hover	= "G10MM-3R will harvest Bee Boxes, etc. as soon as they produce.", data = 3},
		},
		default = 1,
	},
	{ 
		name = "excludeitemsconfig",
		label = "G10MM-3R shouldn't pick up",
		options =
		{
			{description = "None", hover = "Regular G10MM-3R pickup list.", data = 1},
			{description = "Flowers", hover = "This also includes Ferns and Succulents.", data = 2},
			{description = "Meats", hover = "This also includes Eggs and Drying Racks.", data = 3},
			{description = "Veggies/Fruits", hover = "This also includes Mushrooms and Farmplots.", data = 4},
		},
		default = 1,
	},
	{ 
		name = "robobee_speed",
		label = "G10MM-3R's Movespeed",
		options =
		{
			{description = "Slower", hover	= "G10MM-3R moves 25% slower.", data = 3},
			{description = "Default", hover	= "Regular movespeed.", data = 4},
			{description = "Faster", hover	= "G10MM-3R moves 50% faster.", data = 6},
			{description = "Very Fast", hover	= "G10MM-3R moves at double speed.", data = 8},
		},
		default = 4,
	},
}
