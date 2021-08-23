require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "robobee_util"

local function pickable_test(inst, target)
	return target.components.pickable and target.components.pickable:CanBePicked() and target.components.pickable.product or
		target.components.crop and target.components.crop:IsReadyForHarvest() and target.components.crop.product_prefab or
		target.components.crop_legion and target.components.crop_legion:IsReadyForHarvest() and target.components.crop_legion.product_prefab or
		target.components.dryer and target.components.dryer:IsDone() and target.components.dryer.product or
		target.components.harvestable and target.components.harvestable:CanBeHarvested() and target.components.harvestable.product or nil
end

local function stackable_test(inst, target, stack_in_base)
	local inv_space = nil

	for k, v in pairs(inst.components.inventory.itemslots) do
		if ((v.prefab == target ~= nil and target.prefab) or (v.prefab == pickable_test(inst, target))) and v.components.stackable and not v.components.stackable:IsFull() and not inst.components.inventory:IsFull() then
			inv_space = v.components.stackable:StackSize()
			break
		end
	end

	if inv_space == nil and not inst.components.inventory:IsFull() then
		inv_space = 0
	end

	local tar05 = (target.components.stackable and target) or
	(target.components.pickable and target.components.pickable.product and ((target.components.pickable.jostlepick == nil or target.components.pickable.jostlepick == false) and target.components.pickable.numtoharvest or target.components.pickable.jostlepick == true and 1)) or
	(target.components.crop and 1) or
	(target.components.crop_legion and target.components.crop_legion.numfruit) or
	(target.components.dryer and 1) or
	(target.components.harvestable and target.components.harvestable.produce) or nil

	local tar1 = tar05 and (type(tar05) == "number" and tar05) or tar05.components.stackable:StackSize()
	local stackbase = (stack_in_base ~= nil and stack_in_base.components.stackable and not stack_in_base.components.stackable:IsFull() and stack_in_base.components.stackable:RoomLeft()) or nil


	if stackbase ~= nil and inv_space ~= nil and tar1 ~= nil and (stackbase - inv_space) >= tar1 then
		local shownumber = stackbase - inv_space
		--print("There's space in the stack of this item: ".. shownumber ..".")
		--print("GL0MM3R has " .. inv_space .. " of this item in the stack.")
		--print("Room left at stack in the base is: " .. stackbase .. ".")
		--print("Target item count: " .. tar1 .. ".")
		return true

	elseif target ~= nil and tar1 ~= nil and stackbase ~= nil and tar1 >= stackbase and not inst.components.inventory:IsFull() and
		not target.components.pickable and target.components.stackable and target.components.stackable:IsStack() and
		target.components.inventoryitem and not target.components.inventoryitem:IsHeld() and
		(inst.components.homeseeker and inst.components.homeseeker:HasHome() and inst.components.homeseeker.home.components.container:IsFull())  then

		inst.stacktobreak = target
		target.stackbreaker = inst
		--print("Failed. Will need to break stack...")

	else
		--print("Failed stack check.")
		return false
	end
end

local function potentialtargettest(inst, target, basse)
	if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
		if inst.components.inventory and inst.components.inventory:IsFull() then
			return false
		end

		local base = basse or nil
		local potentialtarget = target or inst.components.homeseeker.home.passtargettobee
		-- try passing target from the base

		if potentialtarget == nil then
			potentialtarget = FindEntityForRobobee(base)
		end

		if base == nil then
			base = inst.components.homeseeker:HasHome() ~= nil and inst.components.homeseeker.home
		end

		local HasSpaceForItem = false

		if base ~= nil and potentialtarget ~= nil then
			for k, v in pairs(base.components.container.slots) do
				if ((v.prefab == potentialtarget.prefab and stackable_test(inst, potentialtarget, v)) or (v.prefab == pickable_test(inst, potentialtarget))) and stackable_test(inst, potentialtarget, v) then
					HasSpaceForItem = true
					break
				else
					--print("Check failed!")
				end
			end

			if not inst.components.follower.leader.components.container:IsFull() then
				HasSpaceForItem = true
			end

			if HasSpaceForItem == true then
				--print("Has space for item.")
				return true
			else
				--print("Test failed.")
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

local function RemoveExclusionFromTargetingPICKABLETag(inst)
	if inst and inst:IsValid() and (inst.components.pickable or inst.components.dryer or inst.components.crop or inst.components.crop_legion or inst.components.harvestable) then
		if inst:HasTag("robobee_target") then
			inst:RemoveTag("robobee_target")
		end
		if inst.robobee_picker ~= nil then
			inst.robobee_picker = nil
		end
	end
end

local function RemoveExclusionFromTargetingINVENTORYITEMTag(inst)
	if inst and inst:IsValid() and inst.components.inventoryitem and not inst.components.inventoryitem.owner then
		if inst:HasTag("robobee_target") then
			inst:RemoveTag("robobee_target")
		end
		if inst.robobee_picker ~= nil then
			inst.robobee_picker = nil
		end
	end
end

local function FindObjectToPickAction(inst)
	local base = inst.components.follower.leader ~= nil and inst.components.follower.leader
	local target = nil

	if inst.components.homeseeker and inst.components.homeseeker:HasHome() and inst.components.homeseeker.home.passtargettobee ~= nil then
		target = inst.components.homeseeker.home.passtargettobee
	else
		target = FindEntityForRobobee(base)
	end

	if target ~= nil and base ~= nil then
		if not target:HasTag("robobee_transportable") and inst.pickable_target == nil and target.robobee_picker == nil and
		(target.components.pickable and target.components.pickable:CanBePicked() or
		target.components.crop and target.components.crop:IsReadyForHarvest() or
		target.components.crop_legion and target.components.crop_legion:IsReadyForHarvest() or
		target.components.dryer and target.components.dryer:IsDone() or
		target.components.harvestable and target.components.harvestable:CanBeHarvested())
		then
			if potentialtargettest(inst, target, base) == true then
				inst.pickable_target = target
				target.robobee_picker = inst

				target:AddTag("robobee_target")
				-- If bee doesn't pick the item up in 10 seconds, force remove the tag
				-- 10 seconds is the max amount of time it should take to get from point A to B for the robobee
				-- If target was valid, we will just re-target
				target:DoTaskInTime(10, function(target) RemoveExclusionFromTargetingPICKABLETag(target) end)
				--print("Success. Picking...")
				if target and target.components.pickable then
					return BufferedAction(inst, target, ACTIONS.PICK)
				else
					return BufferedAction(inst, target, ACTIONS.HARVEST)
				end

			else
				--print("Failed. Going home...")
				inst.components.homeseeker.home.passtargettobee = nil -- reset target sent from base
				inst.components.homeseeker:GoHome(true) -- no space in the base? go home
			end
		elseif target:HasTag("robobee_transportable") and target.components.inventoryitem and target.components.inventoryitem.owner == nil and target:IsValid() and target.components.inventoryitem.canbepickedup and target.components.inventoryitem.canbepickedup == true then
			if potentialtargettest(inst, target, base) == true then
				inst.pickable_target = target
				target.robobee_picker = inst

				target:AddTag("robobee_target")
				-- If bee doesn't pick the item up in 10 seconds, force remove the tag
				-- 10 seconds is the max amount of time it should take to get from point A to B for the robobee
				-- If target was valid, we will just re-target
				target:DoTaskInTime(10, function(target) RemoveExclusionFromTargetingINVENTORYITEMTag(target) end)
				--print("Picking up inventoryitem...")
				return BufferedAction(inst, target, ACTIONS.PICKUP)
			else
				--print("Failed(inventoryitem). Going home...")
				inst.components.homeseeker.home.passtargettobee = nil -- reset target sent from base
				inst.components.homeseeker:GoHome(true) -- no space in the base? go home
			end

		else
			--print("Target stolen. Going home...")
			inst:PushEvent("robobee_targetstolen")
			if inst.components.follower.leader and inst.components.homeseeker and inst.components.homeseeker:HasHome() then
				inst.components.homeseeker.home.passtargettobee = nil -- reset target sent from base
				inst.components.homeseeker:GoHome(true)
			end
		end
	else
		if inst.components.homeseeker and inst.components.homeseeker:HasHome() and inst.components.inventory then
			if inst.components.inventory:NumItems() ~= 0 then

			end
			--print("Total fail. Going home...")
			inst.components.homeseeker.home.passtargettobee = nil -- reset target sent from base
			inst.components.homeseeker:GoHome(true)
		end
	end
end

local function StartPickingCondition(inst)
	if inst.somethingbroke == nil then
		return inst.pickable_target == nil
			and inst.stacktobreak == nil
			and inst:IsNear(inst.components.follower.leader, ROBOBEE_KEEP_PICKING_DIST)
			and inst.components.follower.leader
			and inst.components.follower.leader.components.childspawner.numchildrenoutside > 0
			and ((inst.components.homeseeker and inst.components.homeseeker:HasHome() and inst.components.homeseeker.home.passtargettobee ~= nil and inst.components.homeseeker.home.passtargettobee.robobee_picker == nil) or true)
			and potentialtargettest(inst, (inst.components.homeseeker.home.passtargettobee ~= nil and inst.components.homeseeker.home.passtargettobee or nil), inst.components.homeseeker.home) == true
			and not (inst.components.freezable and inst.components.freezable:IsFrozen())
	else
		return false
	end
end

local function KeepPickingAction(inst)
	if StartPickingCondition(inst) then
		--print("KeepPickingAction initiated.")
		return true
	else
		--print("KeepPickingAction failed.")
		return false
	end
end

local function StackBreakerCheck(inst)
	if inst.somethingbroke == nil then
		return inst.stacktobreak ~= nil and inst.stacktobreak:IsValid() and inst.stacktobreak.components.stackable and inst.stacktobreak.components.stackable:IsStack() and not (inst.components.freezable and inst.components.freezable:IsFrozen())
	else
		return false
	end
end

local function StackBreakerAction(inst)
	if StackBreakerCheck(inst) then
		--print("StackBreakerAction initiated.")
		return BufferedAction(inst, inst.stacktobreak, ACTIONS.BREAKSTACK)
	end
end

local function GoHomeCheck(inst)
	if inst.somethingbroke == nil then
		return inst.pickable_target == nil
		and inst.stacktobreak == nil
		and inst.components.homeseeker
		and inst.components.homeseeker:HasHome()
		and inst.components.homeseeker.home:IsValid()
		and inst.components.homeseeker.home.passtargettobee == nil
		and potentialtargettest(inst, (inst.components.homeseeker.home.passtargettobee ~= nil and inst.components.homeseeker.home.passtargettobee or nil), inst.components.homeseeker.home) == false
		and inst.bufferedaction == nil
		and inst.components.homeseeker.home.components.childspawner.numchildrenoutside > 0
		and not (inst.sg and inst.sg:HasStateTag("beam"))
		and not (inst.components.freezable and inst.components.freezable:IsFrozen())
		and true or nil
	else
		if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
			return true
		else
			if not inst.components.health then
				inst:AddComponent("health")
			end
			inst.components.health:DoDelta(-1000)
		end
	end
end

local function GoHomeAction(inst)
	if GoHomeCheck(inst) then
		--print("GoHomeAction initated.")
		return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
	end
end

local RobobeeBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function RobobeeBrain:OnStart()
	local root =
	PriorityNode(
	{
		IfNode(function() return StartPickingCondition(self.inst) end, "pick",
				WhileNode(function() return KeepPickingAction(self.inst) end, "keep picking",
					LoopNode{
							DoAction(self.inst, FindObjectToPickAction )})),
		WhileNode(function() return StackBreakerCheck(self.inst) end, "BreakStack",
			DoAction(self.inst, StackBreakerAction, "break stack", true )),
		WhileNode(function() return GoHomeCheck(self.inst) end, "GoingHome",
			DoAction(self.inst, GoHomeAction, "go home", true )),
	}, .25)
	self.bt = BT(self.inst, root)
end

return RobobeeBrain