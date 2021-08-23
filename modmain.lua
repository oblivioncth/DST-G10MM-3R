PrefabFiles = {
	"robobee",
	"robobee_78",
	"robobee_caterpillar",
	"statuerobobee",
	"statuerobobee_78",
	"statuerobobee_caterpillar",
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

-- ### Import engine utilities ###
modimport("libs/engine.lua")

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

-- ### Define Default Behavior ###

-- Sight/Interact Distance
GLOBAL.ROBOBEE_SEE_OBJECT_DIST = 15
GLOBAL.ROBOBEE_KEEP_PICKING_DIST = 15

-- Storage Container
GLOBAL.STATUEROBOBEE_CONTAINER = "chest"

-- Inclusions
GLOBAL.STATUEROBOBEE_INCLUDETAGS = {"pickable", "robobee_transportable"}

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

-- Exclusions
GLOBAL.STATUEROBOBEE_EXCLUDETAGS = {"robobee_target", "locomotor", "robobee_excluded", "fire"}
AddPrefabPostInit("sculptingtable", ForbiddenStructuresPostInit)

-- Harvest Level
GLOBAL.ROBOBEE_HARVEST = 1

-- Move speed
GLOBAL.ROBOBEE_MOVESPEED = 4

-- Component Modifications
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
			-- Keep that dir ty magic away from my pure bee!
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

-- New ACTIONS
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

-- Container Modifications:
local containers = require("containers")
local oldwidgetsetup = containers.widgetsetup

mods=GLOBAL.rawget(GLOBAL,"mods")or(function()local m={}GLOBAL.rawset(GLOBAL,"mods",m)return m end)()
mods.old_widgetsetup = mods.old_widgetsetup or containers.smartercrockpot_old_widgetsetup or oldwidgetsetup
containers.widgetsetup = function(container, prefab, ...)
	if ((not prefab and container and container.inst and container.inst.prefab == "statuerobobee") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee")) or
		((not prefab and container and container.inst and container.inst.prefab == "statuerobobee_78") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee_78")) or
		((not prefab and container and container.inst and container.inst.prefab == "statuerobobee_caterpillar") or (prefab and container and container.inst and container.inst.prefab == "statuerobobee_caterpillar")) then
		prefab = "treasurechest"
	end
	oldwidgetsetup(container, prefab, ...)
end

-- Skin Implementation
GLOBAL.PREFAB_SKINS.statuerobobee =
{
	"statuerobobee_78",
	"statuerobobee_caterpillar",
}
GLOBAL.PREFAB_SKINS_IDS.statuerobobee = {}
GLOBAL.PREFAB_SKINS_IDS.statuerobobee.statuerobobee_78 = 1 -- lua is 1 indexed
GLOBAL.PREFAB_SKINS_IDS.statuerobobee.statuerobobee_caterpillar = 2 -- lua is 1 indexed

local function RecipePopupPostConstruct( widget )
	local _GetSkinsList = widget.GetSkinsList
	widget.GetSkinsList = function( self )
		if self.recipe.skinnable == nil then
			return _GetSkinsList( self )
		end

		self.skins_list = {}
		if self.recipe and PREFAB_SKINS[self.recipe.name] then
			for _,item_type in pairs(PREFAB_SKINS[self.recipe.name]) do
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
		return STRINGS.SKIN_NAMES[var]
	end

	local _GetSkinOptions = widget.GetSkinOptions
	widget.GetSkinOptions = function( self )
		if self.recipe.skinnable == nil then
			return _GetSkinOptions( self )
		end

		local skin_options = {}

		table.insert(skin_options,
		{
			text = STRINGS.UI.CRAFTING.DEFAULT,
			data = nil,
			colour = SKIN_RARITY_COLORS["Common"],
			new_indicator = false,
			image =  {self.recipe.atlas or "images/inventoryimages.xml", self.recipe.image or self.recipe.name .. ".tex", "default.tex"},
		})

		local recipe_timestamp = Profile:GetRecipeTimestamp(self.recipe.name)
		--print(self.recipe.name, "Recipe timestamp is ", recipe_timestamp)
		if self.skins_list and TheNet:IsOnlineMode() then
			for which = 1, #self.skins_list do
				local image_name = self.skins_list[which].item

				local rarity = GetRarityForItem("item", image_name)
				local colour = rarity and SKIN_RARITY_COLORS[rarity] or SKIN_RARITY_COLORS["Common"]
				local text_name = GetName(image_name) or SKIN_STRINGS.SKIN_NAMES["missing"]
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
				elseif CanPrototypeRecipe(recipe.level, self.accessible_tech_trees) and
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
		if GetValidRecipe(recname).skinnable then
			if skin ~= nil then
				if AllRecipes[recname]._oldproduct == nil then
					GLOBAL.AllRecipes[recname]._oldproduct = AllRecipes[recname].product
				end
				GLOBAL.AllRecipes[recname].product = skin
			else
				if AllRecipes[recname]._oldproduct ~= nil then
					GLOBAL.AllRecipes[recname].product = AllRecipes[recname]._oldproduct
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

-- Add Game Strings:
Load("scripts/robobee_strings")

-- ### Define/Alter Config Based Behavior Parameters ###

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

-- Read Config: Container
GLOBAL.STATUEROBOBEE_CONTAINER = GetModConfigData("chesticeboxconfig") == CF_CONTAINER_CHEST and "chest" or "icebox" 
local imageatlas = GetModConfigData("chesticeboxconfig") == CF_CONTAINER_CHEST and "statuerobobee" or "statuerobobee_icebox"

-- Read Config: Recipe Availability
local robobee_tech = TECH.LOST

if GetModConfigData("robobeetechconfig") == CF_RECIPE_AVAIL_OBTAIN then

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
	for _,v in ipairs(bosses) do AddPrefabPostInit(v, RaidBossesRecipeDropPostInit) end

	function ClockworkJunkRecipeDropPostInit(inst)
		if TheWorld.ismastersim then
			if inst.components.lootdropper then
				inst.components.lootdropper:AddChanceLoot("statuerobobee_blueprint", 0.01)
			end
		end
	end
	local junkpiles = {"chessjunk1", "chessjunk2", "chessjunk3"}
	for _,v in ipairs(junkpiles) do AddPrefabPostInit(v, ClockworkJunkRecipeDropPostInit) end

elseif GetModConfigData("robobeetechconfig") == CF_RECIPE_AVAIL_SHADOW then
	robobee_tech = TECH.MAGIC_THREE
elseif GetModConfigData("robobeetechconfig") == CF_RECIPE_AVAIL_PRESTIHAT then
	robobee_tech = TECH.MAGIC_TWO
elseif GetModConfigData("robobeetechconfig") == CF_RECIPE_AVAIL_ALCHMY then
	robobee_tech = TECH.SCIENCE_TWO
elseif GetModConfigData("robobeetechconfig") == CF_RECIPE_AVAIL_SCIENCE then
	robobee_tech = TECH.SCIENCE_ONE
elseif GetModConfigData("robobeetechconfig") == CF_RECIPE_AVAIL_ALWAYS then
	robobee_tech = TECH.NONE
end

-- Read Config: Recipe Difficulty
local statuerecipe = AddRecipe("statuerobobee",
{  Ingredient("gears", GetModConfigData("robobeestatuerecipeconfig")), Ingredient("glommerflower", 1), Ingredient("glommerwings", 1)},
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

-- Read Config: Include Structures
if GetModConfigData("includestructures") == CF_INCLUDE_STRUCT_YES then
	table.insert(STATUEROBOBEE_INCLUDETAGS, "readyforharvest")
	table.insert(STATUEROBOBEE_INCLUDETAGS, "dried")
	table.insert(STATUEROBOBEE_INCLUDETAGS, "harvestable")
else
	table.insert(STATUEROBOBEE_EXCLUDETAGS, "structure")
end

-- Read Config: Include Crops
if GetModConfigData("includecrops") == CF_INCLUDE_CROPS_NO then
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	for _,v in ipairs(PLANT_DEFS) do AddPrefabPostInit(v.prefab, RobobeeExcludedItems) end

	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	for _,v in ipairs(WEED_DEFS) do AddPrefabPostInit(v.prefab, RobobeeExcludedItems) end
end

-- Read Config: Excluded Items
if GetModConfigData("excludeitemsconfig") == CF_EXCLUDED_ITEMS_FLOWERS then
	local flowers =
		{"flower",
		"flower_evil",
		"cave_fern",
		"succulent_plant",
		"flower_rose",
		"flower_withered",}
	for _,v in ipairs(flowers) do AddPrefabPostInit(v, RobobeeExcludedItems) end
end

if GetModConfigData("excludeitemsconfig") == CF_EXCLUDED_ITEMS_MEATS then
	AddPrefabPostInit("meatrack", RobobeeExcludedItems)
else
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

if GetModConfigData("excludeitemsconfig") == CF_EXCLUDED_ITEMS_VEGFRUIT then
	AddPrefabPostInit("plant_normal", RobobeeExcludedItems)
else
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

-- Read Config: When to Harvest
GLOBAL.ROBOBEE_HARVEST = GetModConfigData("whentoharvest")

-- Read Config: Move Speed
GLOBAL.ROBOBEE_MOVESPEED = GetModConfigData("robobee_speed")