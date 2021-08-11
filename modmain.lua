PrefabFiles = {
	"robobee",
	"robobee_78",
	"robobee_caterpillar",
	"statuerobobee",
	"statuerobobee_78",
	"statuerobobee_caterpillar",
	"sparks_robobee",
	"sparks_robobee_78",
	"sparks_robobee_caterpillar",
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
	Asset("ATLAS", "images/inventoryimages/statuerobobee_78.xml"),
	Asset("IMAGE", "images/inventoryimages/statuerobobee_78.tex"),
	
	Asset("ATLAS", "images/inventoryimages/statuerobobee_icebox_78.xml"),
	Asset("IMAGE", "images/inventoryimages/statuerobobee_icebox_78.tex"),
	
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
	Asset("ATLAS", "images/inventoryimages/statuerobobee_caterpillar.xml"),
	Asset("IMAGE", "images/inventoryimages/statuerobobee_caterpillar.tex"),
	
	Asset("ATLAS", "images/inventoryimages/statuerobobee_icebox_caterpillar.xml"),
	Asset("IMAGE", "images/inventoryimages/statuerobobee_icebox_caterpillar.tex"),
	
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

modimport("libs/env.lua")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = GLOBAL.ActionHandler

-- OBBY: Static Globals
--GLOBAL.ROBOBEE_MIN_FOLLOW_DIST = 0 -- Unused
--GLOBAL.ROBOBEE_MAX_FOLLOW_DIST = 15 -- Unused
--GLOBAL.ROBOBEE_TARGET_FOLLOW_DIST = 15 -- Unused

GLOBAL.ROBOBEE_SEE_OBJECT_DIST = 15
GLOBAL.ROBOBEE_KEEP_PICKING_DIST = 15
--GLOBAL.ROBOBEE_MAX_WANDER_DIST = 15 -- Unused

-- OBBY: Dynamic Globals
GLOBAL.ROBOBEE_HARVEST = GetModConfigData("whentoharvest")

GLOBAL.ROBOBEE_MOVESPEED = GetModConfigData("robobee_speed")

if GetModConfigData("chesticeboxconfig") == 1 then
	GLOBAL.STATUEROBOBEE_CONTAINER = "chest"
else
	GLOBAL.STATUEROBOBEE_CONTAINER = "icebox"
end

if GetModConfigData("includestructures") == 2 then
	GLOBAL.STATUEROBOBEE_EXCLUDETAGS = {"robobee_target", "locomotor", "robobee_excluded", "fire"}
	GLOBAL.STATUEROBOBEE_INCLUDETAGS = {"pickable", "robobee_transportable", "readyforharvest", "dried", "harvestable"}
else
	GLOBAL.STATUEROBOBEE_EXCLUDETAGS = {"robobee_target", "structure", "locomotor", "robobee_excluded", "fire"}
	GLOBAL.STATUEROBOBEE_INCLUDETAGS = {"pickable", "robobee_transportable"}
end

local numgears = GetModConfigData("robobeestatuerecipeconfig")

GLOBAL.PREFAB_SKINS.statuerobobee =
{
    "statuerobobee_78",
	"statuerobobee_caterpillar",
}

GLOBAL.PREFAB_SKINS_IDS = {}
for prefab,skins in pairs(GLOBAL.PREFAB_SKINS) do
	GLOBAL.PREFAB_SKINS_IDS[prefab] = {}
	for k,v in pairs(skins) do
		GLOBAL.PREFAB_SKINS_IDS[prefab][v] = k
	end
end

local imageatlas = nil
if GetModConfigData("chesticeboxconfig") == 1 then
	imageatlas = "statuerobobee"
else
	imageatlas = "statuerobobee_icebox"
end

local robobee_tech = TECH.LOST

if GetModConfigData("robobeetechconfig") == 2 then
	robobee_tech = TECH.MAGIC_THREE
elseif GetModConfigData("robobeetechconfig") == 3 then
	robobee_tech = TECH.MAGIC_TWO
elseif GetModConfigData("robobeetechconfig") == 4 then
	robobee_tech = TECH.SCIENCE_TWO
elseif GetModConfigData("robobeetechconfig") == 5 then
	robobee_tech = TECH.SCIENCE_ONE
elseif GetModConfigData("robobeetechconfig") == 6 then
	robobee_tech = TECH.NONE
end

local statuerecipe = AddRecipe("statuerobobee", 
{  Ingredient("gears", numgears), Ingredient("glommerflower", 1), Ingredient("glommerwings", 1)}, 
RECIPETABS.SCIENCE, 
robobee_tech, 
"statuerobobee_placer", 
1.5, 
nil, 
nil, 
nil, 
"images/inventoryimages/" .. imageatlas .. ".xml",
"statuerobobee.tex")
statuerecipe.sortkey = -99
statuerecipe.skinnable = true

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

-- OBBY: Combinding of previous two AddComponentPostInit uses into one, and fix for newer Pick which (sometimes) returns a value
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

-- OBBY: Simplification of function args and combinding of previous two AddComponentPostInit uses into one
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
	
		--if self.inst ~= nil and self.inst.Transform ~= nil and self.inst.originaltransformsize ~= nil then
			--local oldsize = self.inst.originaltransformsize
			--self.inst.Transform:SetScale(oldsize, oldsize, oldsize)
			--self.inst.originaltransformsize = nil
		--end
		
		--if self.inst ~= nil and self.inst.AnimState ~= nil and self.inst.originalcolour ~= nil then
			--local oldcolour = self.inst.originalcolour
			--self.inst.AnimState:SetAddColour(oldcolour[1], oldcolour[2], oldcolour[3], oldcolour[4])
			--self.inst.originalcolour = nil
		--end
		
		OldOnDropped(self, ...)
	end
end)

-- OBBY: Simplification of function args
AddComponentPostInit("spellcaster", function(SpellCaster)
	local OldCanCast = SpellCaster.CanCast
	SpellCaster.CanCast = function(self, doer, target, ...)
	
		if target ~= nil and target:HasTag("robobee") then
			-- Keep that dir ty magic away from my pure bee!
			return false
		else
			return OldCanCast(self, doer, target, ...)
		end

	end
end)

-- OBBY: Fix for newer ReleaseAllChildren that returns a value, simplification of function args
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

function RobobeePickableItems(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddTag("robobee_transportable")
    end
end

if GetModConfigData("excludeitemsconfig") ~= 4 then
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
	for _,v in ipairs(plants_shrooms) do AddPrefabPostInit(v, RobobeePickableItems) end
end
	
if GetModConfigData("excludeitemsconfig") ~= 3 then
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
	for _,v in ipairs(meats_eggs) do AddPrefabPostInit(v, RobobeePickableItems) end
end

local manure =
	{"poop",
	"guano",
	"spoiled_food",
	"glommerfuel",}
for _,v in ipairs(manure) do AddPrefabPostInit(v, RobobeePickableItems) end
	
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
for _,v in ipairs(resources) do AddPrefabPostInit(v, RobobeePickableItems) end
	
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
for _,v in ipairs(other) do AddPrefabPostInit(v, RobobeePickableItems) end

---

function RobobeeExcludedItems(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddTag("robobee_excluded")
    end
end

if GetModConfigData("excludeitemsconfig") == 2 then
	local flowers =
		{"flower",
		"flower_evil",
		"cave_fern",
		"succulent_plant",
		"flower_rose",
		"flower_withered",}
	for _,v in ipairs(flowers) do AddPrefabPostInit(v, RobobeeExcludedItems) end
end

if GetModConfigData("excludeitemsconfig") == 3 then
	AddPrefabPostInit("meatrack", RobobeeExcludedItems)
end

if GetModConfigData("excludeitemsconfig") == 4 then
	AddPrefabPostInit("plant_normal", RobobeeExcludedItems)
end

---

function ForbiddenStructuresPostInit(inst)
	if GLOBAL.TheWorld.ismastersim then -- no need to add the tag for clients, G10MM-3R operates locally
		inst:AddTag("robobee_excluded")
	end
end 
AddPrefabPostInit("sculptingtable", ForbiddenStructuresPostInit)

if GetModConfigData("robobeetechconfig") == 1 then

	function GlommerStatuePostInit(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 1)
			end
		end
	end 
	AddPrefabPostInit("statueglommer", GlommerStatuePostInit)

	function RaidBossesRecipeDropPostInit(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.2)
			end
		end
	end 
	local bosses = {"dragonfly", "beequeen"}
	for _,v in ipairs(bosses) do AddPrefabPostInit(v, RaidBossesRecipeDropPostInit) end

	function ClockworkJunkRecipeDropPostInit(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.01)
			end
		end
	end 
	local junkpiles = {"chessjunk1", "chessjunk2", "chessjunk3"}
	for _,v in ipairs(junkpiles) do AddPrefabPostInit(v, ClockworkJunkRecipeDropPostInit) end
	
end

local BREAKSTACK = GLOBAL.Action({ priority= 10 })	
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

-- CONTAINERS:
-- OBBY: Removal of unnecessary return statement since containers.widgetsetup doesn't return a value
local containers = GLOBAL.require("containers")
local oldwidgetsetup = containers.widgetsetup
_G=GLOBAL
mods=_G.rawget(_G,"mods")or(function()local m={}_G.rawset(_G,"mods",m)return m end)()
mods.old_widgetsetup = mods.old_widgetsetup or containers.smartercrockpot_old_widgetsetup or oldwidgetsetup
containers.widgetsetup = function(container, prefab, ...)
    if ((not prefab and container and container.inst and container.inst.prefab == "statuerobobee") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee")) or
		((not prefab and container and container.inst and container.inst.prefab == "statuerobobee_78") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee_78")) or
		((not prefab and container and container.inst and container.inst.prefab == "statuerobobee_caterpillar") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee_caterpillar")) then
		prefab = "treasurechest"
    end
    oldwidgetsetup(container, prefab, ...)
end

STRINGS.NAMES.ROBOBEE = "G10MM-3R"
STRINGS.NAMES.ROBOBEE_78 = "G10MM-3R"
STRINGS.NAMES.ROBOBEE_CATERPILLAR = "G10MM-3R"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROBOBEE = "It's buzzing with electricity."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROBOBEE = "It's not as fuzzy as the real thing..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROBOBEE = "The original is dead. This one is just a mindless drone..."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROBOBEE = "Is robot bug tiny robot person's friend?"
STRINGS.CHARACTERS.WX78.DESCRIBE.ROBOBEE = "MAYBE IT HAS A SIMPLE BRAIN, BUT IT'S NOT A BRAIN MADE OF FLESH"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROBOBEE = "An artificial creature with seemingly infinite energy."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROBOBEE = "Whatever I chop, it'll collect, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROBOBEE = "Well, at least this one doesn't leave its feces everywhere."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROBOBEE = "Majestic goober, in a majestic armor."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROBOBEE = "Always busy! He has no time for fun."
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROBOBEE = "Oh, it looks amazing! I'd like to take a peek inside..."

STRINGS.NAMES.STATUEROBOBEE = "G10MM-3R Base"
STRINGS.NAMES.STATUEROBOBEE_78 = "G10MM-3R Base"
STRINGS.NAMES.STATUEROBOBEE_CATERPILLAR = "G10MM-3R Base"

GLOBAL.STRINGS.SKIN_NAMES.statuerobobee = "Default"
GLOBAL.STRINGS.SKIN_NAMES.statuerobobee_78 = "Clockwork"
GLOBAL.STRINGS.SKIN_NAMES.statuerobobee_caterpillar = "Caterpillar"

STRINGS.RECIPE_DESC.STATUEROBOBEE = "Small deposit station. Comes with a drone."
STRINGS.RECIPE_DESC.STATUEROBOBEE_78 = "Small deposit station. Comes with a drone." -- this fixes disappearing in-menu flavor text after crafting the skinned robobee base
STRINGS.RECIPE_DESC.STATUEROBOBEE_CATERPILLAR = "Small deposit station. Comes with a drone."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "It's an electric plant. I named it a \"power-plant\".", 
	BEEINSIDE = "Scientifically speaking, sleeping does \"charge your batteries\"." }
	
STRINGS.CHARACTERS.WILLOW.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "I like the flower part of it.", 
	BEEINSIDE = "It's actually sleeping or is it just trying to mock me?" }

STRINGS.CHARACTERS.WENDY.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "It provides that hollow drone a place to rest.", 
	BEEINSIDE = "One day it's going to die from an electrical outage." }
	
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "Hah, dumb machine. You are not flower.", 
	BEEINSIDE = "Flower is cozy bed for robot." }
	
STRINGS.CHARACTERS.WX78.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "I APPRECIATE ITS NON-ORGANIC PARTS", 
	BEEINSIDE = "SLEEP WELL, FRIEND" }

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "A structure utilizing conductivity of flora.", 
	BEEINSIDE = "This automated creature is able to imitate the act of sleeping." }
	
STRINGS.CHARACTERS.WOODIE.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "That thing's trunk looks like it's made of metal.", 
	BEEINSIDE = "So it comes here for a nap, eh?" }

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "This flower may be pretty, but its smell... not so much.", 
	BEEINSIDE = "It's resting after a long day of physical labor." }
	
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "It's not real gold, but I appreciate the effort.", 
	BEEINSIDE = "Goober is resting after a battle." }
	
STRINGS.CHARACTERS.WEBBER.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "Hey, we've seen a similar statue somewhere...", 
	BEEINSIDE = "Shh, he's sleeping!" }
	
STRINGS.CHARACTERS.WINONA.DESCRIBE.STATUEROBOBEE = { 
	GENERIC = "Pure utility, I love it!", 
	BEEINSIDE = "You're not fooling anyone, little guy." }

	
-- Skin strings
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROBOBEE_78 = "It's buzzing with electricity."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROBOBEE_78 = "It's not as fuzzy as the real thing..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROBOBEE_78 = "The original is dead. This one is just a mindless drone..."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROBOBEE_78 = "Is robot bug tiny robot person's friend?"
STRINGS.CHARACTERS.WX78.DESCRIBE.ROBOBEE_78 = "MAYBE IT HAS A SIMPLE BRAIN, BUT IT'S NOT A BRAIN MADE OF FLESH"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROBOBEE_78 = "An artificial creature with seemingly infinite energy."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROBOBEE_78 = "Whatever I chop, it'll collect, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROBOBEE_78 = "Well, at least this one doesn't leave its feces everywhere."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROBOBEE_78 = "Majestic goober, in a majestic armor."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROBOBEE_78 = "Always busy! He has no time for fun."
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROBOBEE_78 = "Oh, it looks amazing! I'd like to take a peek inside..."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "It's an electric plant. I named it a \"power-plant\".", 
	BEEINSIDE = "Scientifically speaking, sleeping does \"charge your batteries\"." }
	
STRINGS.CHARACTERS.WILLOW.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "I like the flower part of it.", 
	BEEINSIDE = "It's actually sleeping or is it just trying to mock me?" }

STRINGS.CHARACTERS.WENDY.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "It provides that hollow drone a place to rest.", 
	BEEINSIDE = "One day it's going to die from an electrical outage." }
	
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "Hah, dumb machine. You are not flower.", 
	BEEINSIDE = "Flower is cozy bed for robot." }
	
STRINGS.CHARACTERS.WX78.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "I APPRECIATE ITS NON-ORGANIC PARTS", 
	BEEINSIDE = "SLEEP WELL, FRIEND" }

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "A structure utilizing conductivity of flora.", 
	BEEINSIDE = "This automated creature is able to imitate the act of sleeping." }
	
STRINGS.CHARACTERS.WOODIE.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "It's made o' metal and all. Even has little gears grinding about.", 
	BEEINSIDE = "So it comes here for a nap, eh?" }

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "This flower may be pretty, but its smell... not so much.", 
	BEEINSIDE = "It's resting after a long day of physical labor." }
	
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "Brings back memories of war against the fierce automatons!", 
	BEEINSIDE = "Goober is resting after a battle." }
	
STRINGS.CHARACTERS.WEBBER.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "Hey, we've seen a similar statue somewhere...", 
	BEEINSIDE = "Shh, he's sleeping!" }
	
STRINGS.CHARACTERS.WINONA.DESCRIBE.STATUEROBOBEE_78 = { 
	GENERIC = "Pure utility, I love it!", 
	BEEINSIDE = "You're not fooling anyone, little guy." }
	
-- Skin strings #2:
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROBOBEE_CATERPILLAR = "It's buzzing with electricity."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROBOBEE_CATERPILLAR = "It's not as fuzzy as the real thing..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROBOBEE_CATERPILLAR = "The original is dead. This one is just a mindless drone..."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROBOBEE_CATERPILLAR = "Is robot bug tiny robot person's friend?"
STRINGS.CHARACTERS.WX78.DESCRIBE.ROBOBEE_CATERPILLAR = "MAYBE IT HAS A SIMPLE BRAIN, BUT IT'S NOT A BRAIN MADE OF FLESH"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROBOBEE_CATERPILLAR = "An artificial creature with seemingly infinite energy."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROBOBEE_CATERPILLAR = "Whatever I chop, it'll collect, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROBOBEE_CATERPILLAR = "Well, at least this one doesn't leave its feces everywhere."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROBOBEE_CATERPILLAR = "Majestic goober, in a majestic armor."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROBOBEE_CATERPILLAR = "Always busy! He has no time for fun."
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROBOBEE_CATERPILLAR = "Oh, it looks amazing! I'd like to take a peek inside..."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "It's an electric plant. I named it a \"power-plant\".", 
	BEEINSIDE = "Scientifically speaking, sleeping does \"charge your batteries\"." }
	
STRINGS.CHARACTERS.WILLOW.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "It would look prettier if its flower was red.", 
	BEEINSIDE = "It's actually sleeping or is it just trying to mock me?" }

STRINGS.CHARACTERS.WENDY.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "It provides that hollow drone a place to rest.", 
	BEEINSIDE = "One day it's going to die from an electrical outage." }
	
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "Hah, dumb machine. You are not flower.", 
	BEEINSIDE = "Flower is cozy bed for robot." }
	
STRINGS.CHARACTERS.WX78.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "IT'S ORGANIC ONLY FROM THE OUTSIDE", 
	BEEINSIDE = "SLEEP WELL, FRIEND" }

STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "A structure utilizing conductivity of flora.", 
	BEEINSIDE = "This automated creature is able to imitate the act of sleeping." }
	
STRINGS.CHARACTERS.WOODIE.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "That's one weird flower growing outta beanstalk.", 
	BEEINSIDE = "So it comes here for a nap, eh?" }

STRINGS.CHARACTERS.WAXWELL.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "This flower may be pretty, but its smell... not so much.", 
	BEEINSIDE = "It's resting after a long day of physical labor." }
	
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "Reminds me of a legendary plant which was reaching heavens!", 
	BEEINSIDE = "Goober is resting after a battle." }
	
STRINGS.CHARACTERS.WEBBER.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "Hey, we've seen a similar statue somewhere...", 
	BEEINSIDE = "Shh, he's sleeping!" }
	
STRINGS.CHARACTERS.WINONA.DESCRIBE.STATUEROBOBEE_CATERPILLAR = { 
	GENERIC = "Pure utility, I love it!", 
	BEEINSIDE = "You're not fooling anyone, little guy." }
	
-- Skins:
local function RecipePopupPostConstruct( widget )
    local _GetSkinsList = widget.GetSkinsList
    widget.GetSkinsList = function( self )
        if self.recipe.skinnable == nil then
            return _GetSkinsList( self )
        end
        
        self.skins_list = {}
        if self.recipe and GLOBAL.PREFAB_SKINS[self.recipe.name] then
            for _,item_type in pairs(GLOBAL.PREFAB_SKINS[self.recipe.name]) do
                local data  = {}
				    data.type = type
				    data.item = item_type
				    data.timestamp = nil
				    table.insert(self.skins_list, data)
			end
	    end
	    
	    return self.skins_list
    end
    
	local GetName = function(var)
		return GLOBAL.STRINGS.SKIN_NAMES[var]
	end
	
    local _GetSkinOptions = widget.GetSkinOptions
    widget.GetSkinOptions = function( self )
        if self.recipe.skinnable == nil then
            return _GetSkinOptions( self )
        end
        
        local skin_options = {}

        table.insert(skin_options, 
        {
            text = GLOBAL.STRINGS.UI.CRAFTING.DEFAULT,
            data = nil, 
            colour = GLOBAL.SKIN_RARITY_COLORS["Common"],
            new_indicator = false,
            image =  {self.recipe.atlas or "images/inventoryimages.xml", self.recipe.image or self.recipe.name .. ".tex", "default.tex"},
        })
		
        local recipe_timestamp = GLOBAL.Profile:GetRecipeTimestamp(self.recipe.name)
        --print(self.recipe.name, "Recipe timestamp is ", recipe_timestamp)
        if self.skins_list and GLOBAL.TheNet:IsOnlineMode() then 
            for which = 1, #self.skins_list do 
                local image_name = self.skins_list[which].item 

                local rarity = GLOBAL.GetRarityForItem("item", image_name)
                local colour = rarity and GLOBAL.SKIN_RARITY_COLORS[rarity] or GLOBAL.SKIN_RARITY_COLORS["Common"]
                local text_name = GetName(image_name) or GLOBAL.SKIN_STRINGS.SKIN_NAMES["missing"]
                local new_indicator = not self.skins_list[which].timestamp or (self.skins_list[which].timestamp > recipe_timestamp)

                if image_name == "" then 
                    image_name = "default"
                else
                    image_name = string.gsub(image_name, "_none", "")
                end

                table.insert(skin_options,  
                {
                    text = text_name, 
                    data = nil,
                    colour = colour,
                    new_indicator = new_indicator,
                    image = {self.recipe.atlas or image_name .. ".xml" or "images/inventoryimages.xml", image_name..".tex" or "default.tex", "default.tex"},
                })
            end

	    else 
    		self.spinner_empty = true
	    end

	    return skin_options
    
    end
end
AddClassPostConstruct("widgets/recipepopup", RecipePopupPostConstruct)

local function BuilderPostInit( builder )
    local _MakeRecipeFromMenu = builder.MakeRecipeFromMenu
    builder.MakeRecipeFromMenu = function( self, recipe, skin )
        if recipe.skinnable == nil then
            _MakeRecipeFromMenu( self, recipe, skin )
        
		else
		
			if recipe.placer == nil then
				if self:KnowsRecipe(recipe.name) then
					if self:IsBuildBuffered(recipe.name) or self:CanBuild(recipe.name) then
						self:MakeRecipe(recipe, nil, nil, skin)
					end
				elseif GLOBAL.CanPrototypeRecipe(recipe.level, self.accessible_tech_trees) and
					self:CanLearn(recipe.name) and
					self:CanBuild(recipe.name) then
					self:MakeRecipe(recipe, nil, nil, skin, function()
						self:ActivateCurrentResearchMachine()
						self:UnlockRecipe(recipe.name)
					end)
				end
			end
		end
    end
    
    local _DoBuild = builder.DoBuild
    builder.DoBuild = function( self, recname, pt, rotation, skin )
        if GLOBAL.GetValidRecipe(recname).skinnable then
            if skin ~= nil then
                if GLOBAL.AllRecipes[recname]._oldproduct == nil then
                    GLOBAL.AllRecipes[recname]._oldproduct = GLOBAL.AllRecipes[recname].product
                end
                GLOBAL.AllRecipes[recname].product = skin
            else
                if GLOBAL.AllRecipes[recname]._oldproduct ~= nil then
                    GLOBAL.AllRecipes[recname].product = GLOBAL.AllRecipes[recname]._oldproduct
                end
            end
        end
        
        return _DoBuild( self, recname, pt, rotation, skin )
    end
    
end
AddComponentPostInit("builder", BuilderPostInit)

local function PlayerControllerPostInit( playercontroller )
    local OldStartBuildPlacementMode = playercontroller.StartBuildPlacementMode
    playercontroller.StartBuildPlacementMode = function( self, recipe, skin )
	
		if recipe ~= nil and recipe.skinnable ~= nil and skin ~= nil and (skin == "statuerobobee_78" or skin == "statuerobobee_caterpillar") then
			self.placer_cached = nil
			self.placer_recipe = recipe
			self.placer_recipe_skin = skin

			if self.placer ~= nil then
				self.placer:Remove()
			end
			
			if skin == "statuerobobee_78" then
				self.placer = SpawnPrefab("statuerobobee_placer_78")
			else
				self.placer = SpawnPrefab("statuerobobee_placer_caterpillar")
			end
			
			self.placer.components.placer:SetBuilder(self.inst, recipe)
			self.placer.components.placer.testfn = function(pt, rot)
				local builder = self.inst.replica.builder
				return builder ~= nil and builder:CanBuildAtPoint(pt, recipe, rot)
			end
			
		else
			return OldStartBuildPlacementMode(self, recipe, skin)
		end
	
	end
end
AddComponentPostInit("playercontroller", PlayerControllerPostInit)
