-- OBBY: General consolidation of previously redundant functions to a common file

local function PickableCheck(v, target)
	return target
	and target.components.pickable
	and target.components.pickable:CanBePicked()
	and target.components.pickable.product ~= nil
	and target.components.pickable.product == v.prefab
	and v.components.stackable
	and not v.components.stackable:IsFull()
	and ((target.components.pickable.jostlepick == nil or target.components.pickable.jostlepick == false) and target.components.pickable.numtoharvest <= v.components.stackable:RoomLeft()
	or target.components.pickable.jostlepick == true and 1 <= v.components.stackable:RoomLeft())
end

local function checkharvestconfiguration(target, prefab)
	return ROBOBEE_HARVEST == 1 and ((TheWorld.state.iswinter and not TheWorld:HasTag("cave") and prefab == "beebox") or target.produce == target.maxproduce) and true
	or ROBOBEE_HARVEST == 2 and ((TheWorld.state.iswinter and not TheWorld:HasTag("cave") and prefab == "beebox") or target.produce >= math.ceil(target.maxproduce*0.5)) and true
	or ROBOBEE_HARVEST == 3 and target.produce > 0 and true
	or false
end

-- DEBUG VERSION
--[[
local function checkharvestconfiguration(target, prefab)
	print("[GM10MM-3R] CHC - Stack: ")
	print(debugstack())

	local modeOne = ROBOBEE_HARVEST == 1 and ((TheWorld.state.iswinter and not TheWorld:HasTag("cave") and prefab == "beebox") or target.produce == target.maxproduce) and true
	local modeTwo = ROBOBEE_HARVEST == 2 and ((TheWorld.state.iswinter and not TheWorld:HasTag("cave") and prefab == "beebox") or target.produce >= math.ceil(target.maxproduce*0.5)) and true
	local modeThree = ROBOBEE_HARVEST == 3 and target.produce > 0 and true

	local Result = modeOne
	or modeTwo
	or modeThree
	or false

	print("[GM10MM-3R] CHC - Prefab: ", prefab)
	print("[GM10MM-3R] CHC - Target Product: ", target.product)
	print("[GM10MM-3R] CHC - Target Produce: ", target.produce)
	print("[GM10MM-3R] CHC - Target Max Produce: ", target.maxproduce)

	print("[GM10MM-3R] CHC - Player Harvest Setting: ", ROBOBEE_HARVEST)
	print("[GM10MM-3R] CHC - Is Winter: ", TheWorld.iswinter)
	print("[GM10MM-3R] CHC - Has Tag Cave: ", TheWorld:HasTag("cave"))
	print("[GM10MM-3R] CHC - Mode 1: ", modeOne)
	print("[GM10MM-3R] CHC - Mode 2: ", modeTwo)
	print("[GM10MM-3R] CHC - Mode 3: ", modeThree)

	print("[GM10MM-3R] CHC - Result: ", Result)

	return Result
end
--]]

local function HarvestableCheck(v, target)
	return target
	and target.components.harvestable
	and target.components.harvestable:CanBeHarvested()
	and target.components.harvestable.produce ~= nil
	and checkharvestconfiguration(target.components.harvestable, target.prefab) == true
	and tostring(target.components.harvestable.product) == v.prefab
	and v.components.stackable
	and not v.components.stackable:IsFull()
	and target.components.harvestable.produce <= v.components.stackable:RoomLeft()
end

local function DryerCheck(v, target)
	return target
	and target.components.dryer
	and target.components.dryer:IsDone()
	and target.components.dryer.product ~= nil
	and target.components.dryer.product == v.prefab
	and v.components.stackable
	and not v.components.stackable:IsFull()
	and 1 <= v.components.stackable:RoomLeft()
end

local function CropCheck(v, target)
	return target
	and target.components.crop
	and target.components.crop:IsReadyForHarvest()
	and target.components.crop.product_prefab ~= nil
	and target.components.crop.product_prefab == v.prefab
	and v.components.stackable
	and not v.components.stackable:IsFull()
	and 1 <= v.components.stackable:RoomLeft()
end

local function Crop_LegionCheck(v, target)
	return target
	and target.components.crop_legion
	and target.components.crop_legion:IsReadyForHarvest()
	and target.components.crop_legion.product_prefab ~= nil
	and target.components.crop_legion.product_prefab == v.prefab
	and v.components.stackable
	and not v.components.stackable:IsFull()
	and target.components.crop_legion.numfruit <= v.components.stackable:RoomLeft()
end

function CheckInvForViableCheck(inst, target)
	for k,v in pairs(inst.components.container.slots) do
		if target and not target.components.pickable and target.prefab and v and v.prefab and v.prefab == target.prefab and not v.components.stackable:IsFull() and (not target.components.burnable or target.components.burnable and not target.components.burnable:IsBurning()) or (PickableCheck(v, target) or HarvestableCheck(v, target) or DryerCheck(v, target) or CropCheck(v, target) or Crop_LegionCheck(v, target)) then
			return true
		end
	end

	return nil -- OBBY: More explicit in showing what happens if the check fails
end

local function inherentexclusioncheck(target)
	return not target.components.harvestable and true
	or target.components.harvestable:CanBeHarvested() and target.components.harvestable.produce ~= nil and checkharvestconfiguration(target.components.harvestable, target.prefab)
end

-- DEBUG VERSION
--[[
function inherentexclusioncheck(target)
	print("[GM10MM-3R] IEC - Stack: ")
	print(debugstack())

	local doesntHaveHarvestComp = not target.components.harvestable and true
	local isHarvestable; if not doesntHaveHarvestComp then isHarvestable = target.components.harvestable:CanBeHarvested() else isHarvestable = nil end
	local hasProduce; if isHarvestable then hasProduce = target.components.harvestable.produce ~= nil else hasProduce = nil end
	local checkedHarvestConfig; if hasProduce then checkedHarvestConfig = checkharvestconfiguration(target.components.harvestable, target.prefab) else checkedHarvestConfig = nil end

	local Result = doesntHaveHarvestComp
	or isHarvestable and hasProduce and checkedHarvestConfig

	print("[GM10MM-3R] IEC - Target: ", target)
	print("[GM10MM-3R] IEC - Target Missing Harvest Comp: ", doesntHaveHarvestComp)
	print("[GM10MM-3R] IEC - Target Can Be Harvested: ", isHarvestable)
	print("[GM10MM-3R] IEC - Target Has Produce: ", hasProduce)
	print("[GM10MM-3R] IEC - Harvest Config Check: ", checkedHarvestConfig)

	print("[GM10MM-3R] IEC - Result: ", Result)

	return Result
end
--]]

function FindEntityForRobobee(base)
	return FindEntity(base, ROBOBEE_SEE_OBJECT_DIST, function(item)
		return item and item:IsValid() and item.prefab and CheckInvForViableCheck(base, item) or not base.components.container:IsFull() and inherentexclusioncheck(item) or false
	end, nil, STATUEROBOBEE_EXCLUDETAGS, STATUEROBOBEE_INCLUDETAGS)
end


-- DEBUG VERSION
--[[
function FindEntityForRobobee(base)
	return FindEntity(base, ROBOBEE_SEE_OBJECT_DIST, function(item)

		local isItemValid; if item then isItemValid = item:IsValid() else isItemValid = nil end
		local itemPrefab; if isItemValid then itemPrefab = item.prefab else itemPrefab = nil end
		local invViableCheck; if itemPrefab then invViableCheck = CheckInvForViableCheck(base, item) else invViableCheck = nil end
		local baseIsNotFull; if not invViableCheck then baseIsNotFull = not base.components.container:IsFull() else baseIsNotFull = nil end
		local checkedExclusion; if baseIsNotFull then checkedExclusion = inherentexclusioncheck(item) else checkedExclusion = nil end

		local Result = item and isItemValid and itemPrefab and invViableCheck or baseIsNotFull and checkedExclusion or false

		print("[GM10MM-3R] FEF - Item: ", item)
		print("[GM10MM-3R] FEF - Item is Valid: ", isItemValid)
		print("[GM10MM-3R] FEF - Prefab: ", itemPrefab)
		print("[GM10MM-3R] FEF - Inv Viable Check: ", invViableCheck)
		print("[GM10MM-3R] FEF - Base Container Not Full: ", baseIsNotFull)
		print("[GM10MM-3R] FEF - Inher Excl Check: ", checkedExclusion)

		print("[GM10MM-3R] FEF - Result: ", Result)

		return Result
	end, nil, STATUEROBOBEE_EXCLUDETAGS, STATUEROBOBEE_INCLUDETAGS)
end
--]]
