PrefabFiles = {
	"robobee",
	"statuerobobee",
	"sparks_robobee",
}

Assets = {
	Asset("SOUNDPACKAGE", "sound/robobeesounds.fev"),
	Asset("SOUND", "sound/robobeesounds.fsb"),

	Asset("ATLAS", "images/inventoryimages/statuerobobee.xml"),
	Asset("IMAGE", "images/inventoryimages/statuerobobee.tex"),

	Asset("ATLAS", "images/inventoryimages/statuerobobee_icebox.xml"),
	Asset("IMAGE", "images/inventoryimages/statuerobobee_icebox.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_full.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_full.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_icebox.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_icebox.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_full_icebox.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_full_icebox.tex"),

	Asset("ATLAS", "images/map_icons/robobee.xml"),
	Asset("IMAGE", "images/map_icons/robobee.tex"),

	--skinned version:
	Asset("ATLAS", "images/map_icons/statuerobobee_map_78.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_78.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_full_78.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_full_78.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_icebox_78.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_icebox_78.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_full_icebox_78.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_full_icebox_78.tex"),

	Asset("ATLAS", "images/map_icons/robobee_78.xml"),
	Asset("IMAGE", "images/map_icons/robobee_78.tex"),

	--skinned version#2:

	Asset("ATLAS", "images/map_icons/statuerobobee_map_caterpillar.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_caterpillar.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_full_caterpillar.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_full_caterpillar.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_icebox_caterpillar.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_icebox_caterpillar.tex"),

	Asset("ATLAS", "images/map_icons/statuerobobee_map_full_icebox_caterpillar.xml"),
	Asset("IMAGE", "images/map_icons/statuerobobee_map_full_icebox_caterpillar.tex"),

	Asset("ATLAS", "images/map_icons/robobee_caterpillar.xml"),
	Asset("IMAGE", "images/map_icons/robobee_caterpillar.tex"),
}

-- ### Add Mini-map Images ###
AddMinimapAtlas("images/map_icons/statuerobobee_map.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_full.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_icebox.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_full_icebox.xml")
AddMinimapAtlas("images/map_icons/robobee.xml")

AddMinimapAtlas("images/map_icons/statuerobobee_map_78.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_full_78.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_icebox_78.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_full_icebox_78.xml")
AddMinimapAtlas("images/map_icons/robobee_78.xml")

AddMinimapAtlas("images/map_icons/statuerobobee_map_caterpillar.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_full_caterpillar.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_icebox_caterpillar.xml")
AddMinimapAtlas("images/map_icons/statuerobobee_map_full_icebox_caterpillar.xml")
AddMinimapAtlas("images/map_icons/robobee_caterpillar.xml")

-- ### Import utilities ###
modimport("libs/engine.lua")
Load("libs/item_skins_api")

-- ### Define Base Parameters ("Constants") ###
local DEF_ROBOBEE_SIGHT_DIST = 15
local DEF_ROBOBEE_CONT_PICK_DIST = 15
local DEF_INCLUSION_TAGS = {"pickable", "robobee_transportable"}
local DEF_EXCLUSION_TAGS = {"robobee_target", "locomotor", "robobee_excluded", "fire"}

-- ### Handle User Config and Define Selection/Derivative Parameters ###

-- Config named constants
local CF_RECIPE_AVAIL_OBTAIN = 1
local CF_RECIPE_AVAIL_SHADOW = 2
local CF_RECIPE_AVAIL_PRESTIHAT = 3
local CF_RECIPE_AVAIL_ALCHMY = 4
local CF_RECIPE_AVAIL_SCIENCE = 5
local CF_RECIPE_AVAIL_ALWAYS = 6
local CF_RECIPE_DIFF_EASY = 1
local CF_RECIPE_DIFF_DEFAULT = 2
local CF_RECIPE_DIFF_HARD = 3
local CF_CONTAINER_CHEST = 1
local CF_CONTAINER_ICEBOX = 0
local CF_INCLUDE_STRUCT_NO = 1
local CF_INCLUDE_STRUCT_YES = 2
local CF_INCLUDE_CROPS_NO = 1
local CF_INCLUDE_CROPS_YES = 2
local CF_EXCLUDED_ITEMS_NONE = 1
local CF_EXCLUDED_ITEMS_FLOWERS = 2
local CF_EXCLUDED_ITEMS_MEATS = 3
local CF_EXCLUDED_ITEMS_VEGFRUIT = 4
local CF_HARVEST_LEVEL_FULL = 1
local CF_HARVEST_LEVEL_HALF = 2
local CF_HARVEST_LEVEL_ANY = 3
local CF_ROBOEE_SPEED_SLOWER = 3
local CF_ROBOEE_SPEED_DEFAULT = 4
local CF_ROBOEE_SPEED_FASTER = 6
local CF_ROBOEE_SPEED_VERYFAST = 8

-- Read config
cfVal_chestIceBox = GetModConfigData("chesticeboxconfig")
cfVal_robobeeTech = GetModConfigData("robobeetechconfig")
cfVal_robobeeStatueRecipe = GetModConfigData("robobeestatuerecipeconfig")
cfVal_includeStructures = GetModConfigData("includestructures")
cfVal_includeCrops = GetModConfigData("includecrops")
cfVal_excludeItems = GetModConfigData("excludeitemsconfig")
cfVal_whenToHarvest = GetModConfigData("whentoharvest")
cfVal_robobeeSpeed = GetModConfigData("robobee_speed")

-- ### Behavior helper functions ###
function RobobeePickableItems(inst)
	if TheWorld.ismastersim then
		inst:AddTag("robobee_transportable")
	end
end

function RobobeeExcludedItems(inst)
	if TheWorld.ismastersim then
		inst:AddTag("robobee_excluded")
	end
end

-- [### Main Mod Setup ###]

-- Set Sight/Interact Distance
GLOBAL.ROBOBEE_SEE_OBJECT_DIST = DEF_ROBOBEE_SIGHT_DIST
GLOBAL.ROBOBEE_KEEP_PICKING_DIST = DEF_ROBOBEE_CONT_PICK_DIST

-- Set Inclusions
GLOBAL.STATUEROBOBEE_INCLUDETAGS = {}
for _,tag in ipairs(DEF_INCLUSION_TAGS) do table.insert(STATUEROBOBEE_INCLUDETAGS, tag) end

if cfVal_includeStructures == CF_INCLUDE_STRUCT_YES then
	table.insert(STATUEROBOBEE_INCLUDETAGS, "readyforharvest")
	table.insert(STATUEROBOBEE_INCLUDETAGS, "dried")
	table.insert(STATUEROBOBEE_INCLUDETAGS, "harvestable")
end

local manure =
	{"poop",
	"guano",
	"spoiled_food",
	"glommerfuel",}
for _,prefab in ipairs(manure) do AddPrefabPostInit(prefab, RobobeePickableItems) end

local resources =
	{"cutreeds",
	"cutgrass",
	"twigs",
	"manrabbit_tail",
	"pigskin",
	"rocks",
	"flint",
	"goldnugget",
	"nitre",
	"marble",
	"log",
	"pinecone",
	"acorn",
	"twiggy_nut",
	"spidergland",
	"silk",}
for _,prefab in ipairs(resources) do AddPrefabPostInit(prefab, RobobeePickableItems) end

local other =
	{"charcoal",
	"honey",
	"ash",
	"butterflywings",
	"beardhair",
	"goatmilk",
	"stinger",
	"slurper_pelt",
	"houndstooth",
	"beefalowool"}
for _,prefab in ipairs(other) do AddPrefabPostInit(prefab, RobobeePickableItems) end

if cfVal_excludeItems ~= CF_EXCLUDED_ITEMS_MEATS then
	local meats_eggs =
		{"meat",
		"monstermeat",
		"monstermeat_dried",
		"meat_dried",
		"smallmeat_dried",
		"smallmeat",
		"drumstick",
		"batwing",
		"plantmeat",
		"fish",
		"eel",
		"bird_egg",
		"tallbirdegg",
		"froglegs",}
	for _,prefab in ipairs(meats_eggs) do AddPrefabPostInit(prefab, RobobeePickableItems) end
end

if cfVal_excludeItems ~= CF_EXCLUDED_ITEMS_VEGFRUIT then
	local plants_shrooms =
		{"berries",
		"berries_juicy",
		"carrot",
		"cactus_meat",
		"watermelon",
		"dragonfruit",
		"pomegranate",
		"durian",
		"eggplant",
		"pumpkin",
		"cave_banana",
		"cactus_flower",
		"seeds",
		"red_cap",
		"green_cap",
		"blue_cap",
		"petals",
		"petals_evil",
		"foliage",
		"lightbulb",}
	for _,prefab in ipairs(plants_shrooms) do AddPrefabPostInit(prefab, RobobeePickableItems) end
end

-- Set Exclusions
GLOBAL.STATUEROBOBEE_EXCLUDETAGS = {}
for _,tag in ipairs(DEF_EXCLUSION_TAGS) do table.insert(STATUEROBOBEE_EXCLUDETAGS, tag) end

if cfVal_includeStructures == CF_INCLUDE_STRUCT_NO then
	table.insert(STATUEROBOBEE_EXCLUDETAGS, "structure")
end

AddPrefabPostInit("sculptingtable", RobobeeExcludedItems)

if cfVal_includeCrops == CF_INCLUDE_CROPS_NO then
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	for _,plant in ipairs(PLANT_DEFS) do AddPrefabPostInit(plant.prefab, RobobeeExcludedItems) end

	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	for _,plant in ipairs(WEED_DEFS) do AddPrefabPostInit(plant.prefab, RobobeeExcludedItems) end
end

if cfVal_excludeItems == CF_EXCLUDED_ITEMS_FLOWERS then
	local flowers =
		{"flower",
		"flower_evil",
		"cave_fern",
		"succulent_plant",
		"flower_rose",
		"flower_withered",}
	for _,prefab in ipairs(flowers) do AddPrefabPostInit(prefab, RobobeeExcludedItems) end
end

if cfVal_excludeItems == CF_EXCLUDED_ITEMS_MEATS then
	AddPrefabPostInit("meatrack", RobobeeExcludedItems)
end

if cfVal_excludeItems == CF_EXCLUDED_ITEMS_VEGFRUIT then
	AddPrefabPostInit("plant_normal", RobobeeExcludedItems)
end

-- Set Harvest Level
GLOBAL.ROBOBEE_HARVEST = cfVal_whenToHarvest

-- Set Move speed
GLOBAL.ROBOBEE_MOVESPEED = cfVal_robobeeSpeed

-- Set Container
GLOBAL.STATUEROBOBEE_CONTAINER = cfVal_chestIceBox == CF_CONTAINER_CHEST and "chest" or "icebox" 

-- Set Recipe Acquisition Method
local robobee_tech = TECH.LOST

if cfVal_robobeeTech == CF_RECIPE_AVAIL_OBTAIN then
	function GlommerStatuePostInit(inst)
		if TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 1)
			end
		end
	end
	AddPrefabPostInit("statueglommer", GlommerStatuePostInit)

	function RaidBossesRecipeDropPostInit(inst)
		if TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.2)
			end
		end
	end
	local bosses = {"dragonfly", "beequeen"}
	for _,boss in ipairs(bosses) do AddPrefabPostInit(boss, RaidBossesRecipeDropPostInit) end

	function ClockworkJunkRecipeDropPostInit(inst)
		if TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.01)
			end
		end
	end
	local junkpiles = {"chessjunk1", "chessjunk2", "chessjunk3"}
	for _,junkpile in ipairs(junkpiles) do AddPrefabPostInit(junkpile, ClockworkJunkRecipeDropPostInit) end
elseif cfVal_robobeeTech == CF_RECIPE_AVAIL_SHADOW then
	robobee_tech = TECH.MAGIC_THREE
elseif cfVal_robobeeTech == CF_RECIPE_AVAIL_PRESTIHAT then
	robobee_tech = TECH.MAGIC_TWO
elseif cfVal_robobeeTech == CF_RECIPE_AVAIL_ALCHMY then
	robobee_tech = TECH.SCIENCE_TWO
elseif cfVal_robobeeTech == CF_RECIPE_AVAIL_SCIENCE then
	robobee_tech = TECH.SCIENCE_ONE
elseif cfVal_robobeeTech == CF_RECIPE_AVAIL_ALWAYS then
	robobee_tech = TECH.NONE
end

-- Add Recipe
local imageatlas = cfVal_chestIceBox == CF_CONTAINER_CHEST and "statuerobobee" or "statuerobobee_icebox"

local statuerecipe = AddRecipe("statuerobobee",
{  Ingredient("gears", cfVal_robobeeStatueRecipe), Ingredient("glommerflower", 1), Ingredient("glommerwings", 1)},
RECIPETABS.SCIENCE,
robobee_tech,
"statuerobobee_placer",
1.5,
nil,
nil,
nil,
"images/inventoryimages/" .. imageatlas .. ".xml",
"statuerobobee")
statuerecipe.sortkey = -99
statuerecipe.skinnable = true

-- Add Skins
MadeRecipeSkinnable("statuerobobee", {
	statuerobobee_78 = {
		atlas = "images/inventoryimages/" .. imageatlas .. ".xml",
		image = "statuerobobee_78",
	},
	statuerobobee_caterpillar = {
		atlas = "images/inventoryimages/" .. imageatlas .. ".xml",
		image = "statuerobobee_caterpillar",
	},
})

-- Make Component Modifications
AddComponentPostInit("pickable", function(Pickable)
	local OldPick = Pickable.Pick
	local OldRegen = Pickable.Regen

	Pickable.Pick = function(self, picker, ...)
		if self.inst and picker ~= nil and not picker:HasTag("robobee") and self.inst.robobee_picker ~= nil then
			self.inst.robobee_picker.pickable_target = nil
			self.inst.robobee_picker:PushEvent("robobee_targetstolen")
			self.inst.robobee_picker = picker
		end

		local inst = self.inst
		self.inst:DoTaskInTime(2, function(inst)
			if inst and inst.components.pickable and inst.components.pickable:CanBePicked() and self.inst.robobee_picker ~= nil then
				if self.inst.robobee_picker.bufferedaction ~= nil and self.inst.robobee_picker.bufferedaction.action == ACTIONS.PICK and self.inst.robobee_picker.bufferedaction.target == self.inst then
					-- check for 2 cases: IF player has picked the object earlier OR Wickerbottom is mass farming resources
					-- if yes, then clear robobee_picker
				else
					self.inst.robobee_picker = nil
				end
			end
		end) -- crappy hacky way to prevent bee targeting bug

		return OldPick(self, picker, ...)
	end

	Pickable.Regen = function(self, ...)
		if self.inst and self.inst:IsValid() then
			if self.inst:HasTag("robobee_target") then
				self.inst:RemoveTag("robobee_target")
			end
			if self.inst.robobee_picker ~= nil then
				self.inst.robobee_picker = nil
			end
		end

		OldRegen(self, ...)
	end
end)

AddComponentPostInit("inventoryitem", function(Inventoryitem)
	local OldOnPutInInventory = Inventoryitem.OnPutInInventory
	local OldOnDropped = Inventoryitem.OnDropped

	Inventoryitem.OnPutInInventory = function(self, ...)
		if self.inst.robobee_picker ~= nil then
			if self.inst.robobee_picker.pickable_target ~= nil then
				self.inst.robobee_picker.pickable_target = nil
			end
			self.inst.robobee_picker = nil
		end

		if self.inst.stackbreaker ~= nil then
			if self.inst.stackbreaker.stacktobreak ~= nil then
				self.inst.stackbreaker.stacktobreak = nil
				if self.inst.stackbreaker.bufferedaction ~= nil and self.inst.stackbreaker.bufferedaction == ACTIONS.BREAKSTACK and self.inst.stackbreaker.bufferedaction.target == self.inst then
					self.inst.stackbreaker:ClearBufferedAction()
				end
			end
			self.inst.stackbreaker = nil
		end

		if self.inst:HasTag("robobee_target") then
			self.inst:RemoveTag("robobee_target")
		end

		OldOnPutInInventory(self, ...)
	end

	Inventoryitem.OnDropped = function(self, ...)
		if self.inst.wasmadeclear ~= nil and self.inst.wasmadeclear == true and self.inst.AnimState then
			self.inst.AnimState:OverrideMultColour(1, 1, 1, 1)
			self.inst.wasmadeclear = nil
		end
		
		OldOnDropped(self, ...)
	end
end)

AddComponentPostInit("spellcaster", function(SpellCaster)
	local OldCanCast = SpellCaster.CanCast
	SpellCaster.CanCast = function(self, doer, target, ...)

		if target ~= nil and target:HasTag("robobee") then
			-- Keep that dirty magic away from my pure bee!
			return false
		else
			return OldCanCast(self, doer, target, ...)
		end

	end
end)

AddComponentPostInit("childspawner", function(ChildSpawner)
	local OldReleaseAllChildren = ChildSpawner.ReleaseAllChildren
	ChildSpawner.ReleaseAllChildren = function(self, target, ...)

	-- Don't release children if robobee is the target
	-- Yes, I had to edit the component, because beebox is not very mod-friendly
		if target == nil or target ~= nil and not target:HasTag("robobee") then
			return OldReleaseAllChildren(self, target, ...)
		end
	end
end)

-- Add New Actions
local BREAKSTACK = Action({ priority= 10 })
BREAKSTACK.str = "Break Stack"
BREAKSTACK.id = "BREAKSTACK"
BREAKSTACK.fn = function(act)
	if act.target ~= nil and
	   act.target.components.inventoryitem ~= nil and
	   not act.target.components.inventoryitem:IsHeld() and
	   act.target.components.stackable ~= nil and
	   act.target.components.stackable:IsStack() then
		local target = act.target
		return act.doer.components.stackbreaker:BreakStack(target)
	end
end
AddAction(BREAKSTACK)

AddComponentAction("SCENE", "stackbreaker", function(inst, doer, actions, right)
	if inst and inst.components.stackable and (inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld()) and doer and doer:HasTag("robobee") then
		table.insert(actions, ACTIONS.BREAKSTACK)
	end
end)

-- Make Container Modifications:
local containers = require("containers")
local oldwidgetsetup = containers.widgetsetup

mods=GLOBAL.rawget(GLOBAL,"mods")or(function()local m={}GLOBAL.rawset(GLOBAL,"mods",m)return m end)()
mods.old_widgetsetup = mods.old_widgetsetup or containers.smartercrockpot_old_widgetsetup or oldwidgetsetup
containers.widgetsetup = function(container, prefab, ...)
	local beeBasenameLen = string.len("statuerobobee")
	
	if container and container.inst and container.inst.prefab and string.len(container.inst.prefab) >= beeBasenameLen then
		local baseName = string.sub(container.inst.prefab, 1, beeBasenameLen)
		
		if baseName == "statuerobobee" then
			prefab = "treasurechest" -- From testing, this code doesn't ever actually seem to be hit
		end
	end

	oldwidgetsetup(container, prefab, ...)
end

-- Add Game Strings:
Load("scripts/robobee_strings")
