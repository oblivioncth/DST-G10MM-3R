require "prefabutil"
require "robobee_util"

local assets =
{
	Asset("ANIM", "anim/statuerobobee.zip"),
	-- reuse asset from Ice Flingomatic
	Asset("ANIM", "anim/firefighter_placement.zip"),
}

local PLACER_SCALE = 1.55

local function RobobeeIsHome(inst)
	-- Uses 'if' instead of and/or to force false when inst.components.childspawner is nil, so that only true/false can be returned
	if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 then
		return true
	else
		return false
	end
end

local function HandleRobobeeShutdown(inst)
	inst.AnimState:PlayAnimation("turnoff")
	inst.AnimState:PushAnimation("off", true)
	-- PLAY TURN OFF SOUND
end

local function HandleRobobeeStartup(inst)
	inst.AnimState:PlayAnimation("turnon")
	inst.AnimState:PushAnimation("idlehome", true)
	-- PLAY TURN ON SOUND
end

local function HandleRobobeeLeave(inst)
	inst.AnimState:PlayAnimation("idleaway", true)
	inst.MiniMapEntity:SetIcon(STATUEROBOBEE_CONTAINER == "chest" and ("statuerobobee_map" .. inst.robobeeSkinSuffix .. ".tex") or 
	                                                                  ("statuerobobee_map_icebox" .. inst.robobeeSkinSuffix .. ".tex"))
																	  
	if inst.components.sanityaura then
		inst.components.sanityaura.aura = 0
	end
end

local function HandleRobobeeReturn(inst)
	inst.AnimState:PlayAnimation("idlehome", true)
	inst.MiniMapEntity:SetIcon(STATUEROBOBEE_CONTAINER == "chest" and ("statuerobobee_map_full" .. inst.robobeeSkinSuffix .. ".tex") or 
																	  ("statuerobobee_map_full_icebox" .. inst.robobeeSkinSuffix .. ".tex"))
	inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/sleep", "zzz")

	if inst.components.sanityaura then
		inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY/2
	end	
end

local function UpdateContainerTable(inst)
	local inv = inst.components.container
	
	for k, v in pairs(inv.slots) do
		local numStr = tostring(k)
		if v ~= nil then
			inst.AnimState:OverrideSymbol(numStr, "statuerobobee" .. inst.robobeeSkinSuffix, numStr)
		else
			inst.AnimState:OverrideSymbol(numStr, "statuerobobee" .. inst.robobeeSkinSuffix, "blank_frame")
		end
	end
	
end

local function OnRobobeeSpawned(inst, child)
	if inst.components.childspawner and child.components.follower and child.components.follower.leader ~= inst then
		child.components.follower:SetLeader(inst)
		HandleRobobeeLeave(inst)
		--print("Spawned Bee")
	end
end

local function OnRobobeeBackHome(inst, child)
	if child and child.components.inventory then
		if inst.on then
			HandleRobobeeReturn(inst)
		else
			HandleRobobeeShutdown(inst)
		end
		
		if child.components.inventory:NumItems() ~= 0 then
			-- transfer items to base
			local inv = inst.components.container

			if inv and inv:IsOpen() then
				inv:Close()
			end
		
			for k,v in pairs(child.components.inventory.itemslots) do
				inst.components.container:GiveItem(child.components.inventory:RemoveItemBySlot(k))
			end
		
			UpdateContainerTable(inst)
		end
		--print("Bee Going Home")
	end
end

local function OnDestroyed(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 then
		inst.components.childspawner:ReleaseAllChildren()
	end
	
	if inst.components.childspawner then
		for k,v in pairs(inst.components.childspawner.childrenoutside) do
			if v and v:IsValid() then
				if not v.components.health then
					v:AddComponent("health")
					v.components.health:DoDelta(-1000)
				end 
			end
		end
	end
	
	inst.components.lootdropper:DropLoot()
	
	if inst.components.container then
		inst.components.container:DropEverything()
	end
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	if STATUEROBOBEE_CONTAINER == "chest" then
		fx:SetMaterial("wood")
	else
		fx:SetMaterial("metal")
	end
	inst:Remove()
end

local function PreventSpawn(inst)
	if inst.components.lootdropper and inst.prefab then
		local loots = {}
		local pt = Vector3(inst.Transform:GetWorldPosition())
	
		local recipe = AllRecipes["statuerobobee"]
	
		if recipe then
			for k,v in ipairs(recipe.ingredients) do
				local amt = v.amount
				for n = 1, amt do
					table.insert(loots, v.type)
				end
			end
		end
		
		for k, v in ipairs(loots) do
			inst.components.lootdropper:SpawnLootPrefab(v, pt)
		end
	end
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	if STATUEROBOBEE_CONTAINER == "chest" then
		fx:SetMaterial("wood")
	else
		fx:SetMaterial("metal")
	end
	inst:Remove()
end

local function OnHit(inst, worker, workleft)
	if not inst:HasTag("burnt") then
		if RobobeeIsHome(inst) then
			if inst.on then
				inst.AnimState:PlayAnimation("hitidlehome")
				inst.AnimState:PushAnimation("idlehome", true)
			else
				inst.AnimState:PlayAnimation("hitoff")
				inst.AnimState:PushAnimation("off", true)
			end
		else
			inst.AnimState:PlayAnimation("hitidleaway")
			inst.AnimState:PushAnimation("idleaway", true)
		end
	end
	
	local inv = inst.components.container

	if inv and inv:IsOpen() then
		inv:Close()
	end
end

local function CheckAreaAndSpawnBee(inst)
	if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 and inst.on then
		--print("[G10MM-3R]: CheckAreaAndSpawnBee - Proceeding")
		local target = FindEntityForRobobee(inst)
		
		local cantakeitem = nil
		
		local truetarget = target ~= nil and target.components.inventoryitem and target or nil
		local trueproduct = (target ~= nil and target.components.pickable and target.components.pickable.product) or 
			(target ~= nil and target.components.harvestable and target.components.harvestable.product ~= nil and tostring(target.components.harvestable.product)) or
			(target ~= nil and target.components.dryer and target.components.dryer.product) or
			(target ~= nil and target.components.crop_legion and target.components.crop_legion.product_prefab) or
			(target ~= nil and target.components.crop and target.components.crop.product_prefab) or nil
		
		-- search for the item in base's inventory (this doesn't activate if inv is empty)
		for k,v in pairs(inst.components.container.slots) do
			if trueproduct == nil and truetarget and truetarget.components and truetarget:IsValid() and v and v.prefab and truetarget.prefab and truetarget.prefab == v.prefab then
				cantakeitem = true
				--break
				--print ("Can take item (inventoryitem)")
				
			elseif truetarget == nil and trueproduct then
				if v and v.prefab == trueproduct then
					cantakeitem = true
					--break
					--print ("Can take item (pickable)")
				end
			else
				--print ("Cannot take item or no item found!")
			end
		end
		
		-- below function goes through even if the base's inventory is completely empty
		if inst.components.container and not inst.components.container:IsFull() then
			cantakeitem = true
			--print ("Free space in base detected.")
		end
		
		if target and cantakeitem and target.robobee_picker == nil then
			--print("Releasing bee...")
			if inst.components.childspawner.numchildrenoutside <= 0 then
				inst.components.childspawner:ReleaseAllChildren()
			end
			inst.passtargettobee = target -- let's try passing the target
		else
			if inst.passtargettobee ~= nil then
				inst.passtargettobee = nil -- clear the variable if nothing was found
			end
		end
	end
end

local function onopen(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:OverrideSymbol("chest", "statuerobobee" .. inst.robobeeSkinSuffix, STATUEROBOBEE_CONTAINER .. "_lid_open")
		inst.SoundEmitter:PlaySound(STATUEROBOBEE_CONTAINER == "chest" and "dontstarve/wilson/chest_open" or "dontstarve/common/icebox_open")
	end
end 

local function onclose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:OverrideSymbol("chest", "statuerobobee" .. inst.robobeeSkinSuffix, STATUEROBOBEE_CONTAINER)
		inst.SoundEmitter:PlaySound(STATUEROBOBEE_CONTAINER == "chest" and "dontstarve/wilson/chest_close" or "dontstarve/common/icebox_close")
	end
	UpdateContainerTable(inst)
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("building")
	inst.AnimState:PushAnimation("idlehome", true)
end

local function MakeSureHasChild(inst)
	-- In case the robobee bugged out for some reason and is not near the base while loading, remove the bee, add a new bee to base
	if inst.components.childspawner and inst.components.childspawner.numchildrenoutside > 0 then
		local bee = FindEntity(inst, 20, nil, nil, {"player"}, {"robobee"})
		if bee == nil then
			local childtokill = inst.components.childspawner.childrenoutside[1]
			if childtokill ~= nil then
				childtokill:Remove()
				table.remove(inst.components.childspawner.childrenoutside, childtokill)
			end
			inst.components.childspawner.childrenoutside = {}
			inst.components.childspawner.numchildrenoutside = 0
			inst.components.childspawner.childreninside = 1
			HandleRobobeeReturn(inst)
		end
	-- In case there's no bee inside nor outside, force add it
	elseif inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 and inst.components.childspawner.childreninside <= 0 then
		inst.components.childspawner.numchildrenoutside = 0
		inst.components.childspawner.childreninside = 1
		HandleRobobeeReturn(inst)
	end
end

local function getstatus(inst)
	return inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 and "BEEINSIDE" or nil
end

local function OnEnableHelper(inst, enabled)
	if enabled then
		--print("enabling helper")
		if inst.helper == nil then
			inst.helper = CreateEntity()

			--[[Non-networked entity]]
			inst.helper.entity:SetCanSleep(false)
			inst.helper.persists = false

			inst.helper.entity:AddTransform()
			inst.helper.entity:AddAnimState()

			inst.helper:AddTag("CLASSIFIED")
			inst.helper:AddTag("NOCLICK")
			inst.helper:AddTag("placer")

			inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

			inst.helper.AnimState:SetBank("firefighter_placement")
			inst.helper.AnimState:SetBuild("firefighter_placement")
			inst.helper.AnimState:PlayAnimation("idle")
			inst.helper.AnimState:SetLightOverride(1)
			inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
			inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
			inst.helper.AnimState:SetSortOrder(1)
			inst.helper.AnimState:SetAddColour(0, .2, .5, 0)

			inst.helper.entity:SetParent(inst.entity)
		end
	elseif inst.helper ~= nil then
		--print("disabling helper")
		inst.helper:Remove()
		inst.helper = nil
	end
end

local function TurnOff(inst, instant)
	inst.on = false
	
	if inst.components.childspawner then
		for _,child in pairs(inst.components.childspawner.childrenoutside) do
			if child and child:IsValid() then
				--print("[G10MM-3R]: Pushed Event - robobee_homeoff")
				child:PushEvent("robobee_homeoff")
			end
		end
	end
	
	if RobobeeIsHome(inst) then
		HandleRobobeeShutdown(inst)
	end
end

local function TurnOn(inst, instant)
	inst.on = true
	
	if RobobeeIsHome(inst) then
		HandleRobobeeStartup(inst)
	end
end

local function overrideskinsuffix(inst, suffix)
	inst.robobeeSkinSuffix = suffix

	inst.MiniMapEntity:SetIcon(STATUEROBOBEE_CONTAINER == "chest" and ("statuerobobee_map_full" .. suffix ..".tex") or 
																	  ("statuerobobee_map_full_icebox" .. suffix .. ".tex"))

	inst.AnimState:SetBank("statuerobobee" .. suffix)
	inst.AnimState:SetBuild("statuerobobee" .. suffix)
	inst.AnimState:OverrideSymbol("chest", "statuerobobee" .. suffix, STATUEROBOBEE_CONTAINER)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.childspawner.childname = "robobee" .. suffix
end

local function fn()
	local inst = CreateEntity()

	inst.robobeeSkinSuffix = ""

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .5)

	inst.MiniMapEntity:SetPriority(5)
	inst.MiniMapEntity:SetIcon(STATUEROBOBEE_CONTAINER == "chest" and ("statuerobobee_map_full.tex") or 
																	  ("statuerobobee_map_full_icebox.tex"))
	inst.AnimState:SetBank("statuerobobee")
	inst.AnimState:SetBuild("statuerobobee")
	inst.AnimState:PlayAnimation("idlehome", true)
	inst.AnimState:OverrideSymbol("chest", "statuerobobee", STATUEROBOBEE_CONTAINER)
	
	inst:AddTag("statue")
	inst:AddTag("statuerobobee")
	inst:AddTag(STATUEROBOBEE_CONTAINER == "chest" and "chest" or "fridge")
	
	--Dedicated server does not need deployhelper
	if not TheNet:IsDedicated() then
		inst:AddComponent("deployhelper")
		inst.components.deployhelper.onenablehelper = OnEnableHelper
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("leader")

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "robobee"
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner:SetSpawnedFn(OnRobobeeSpawned)
	inst.components.childspawner:SetGoHomeFn(OnRobobeeBackHome)
	inst.components.childspawner:StopRegen()
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("treasurechest")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(6)
	inst.components.workable:SetOnFinishCallback(OnDestroyed)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst:ListenForEvent("onbuilt", OnBuilt)

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY/2

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = function(inst) return true end
	inst.components.machine.cooldowntime = 0.5
	inst.on = false; -- Makes it clear this variable exists, since otherwise it would be dynamically added in TurnOn()
	
	inst.components.machine:TurnOn()

	MakeHauntableWork(inst)
			
	inst:DoPeriodicTask(3, function(inst) CheckAreaAndSpawnBee(inst) end)
			
	inst:DoTaskInTime(0, function(inst)
		local pt = Vector3(inst.Transform:GetWorldPosition())
	
		if TheWorld.Map:IsPassableAtPoint(pt.x, pt.y, pt.z, false, true) then
			UpdateContainerTable(inst) 
			MakeSureHasChild(inst)
		else
			--G10MM-3R Statue CANNOT be spawned in ANY CASE in an invalid area
			--If it is, destroy it immediately to prevent crashes
			--Drop all ingredients though, we don't want the player to get annoyed in case the spawn placement seemed correct
			PreventSpawn(inst)
		end
	end)
		
	return inst	
end

local function fn_78()
	local inst = fn()
	overrideskinsuffix(inst, "_78")

	return inst
end

local function fn_caterpillar()
	local inst = fn()
	overrideskinsuffix(inst, "_caterpillar")

	return inst
end
	
local function placer(inst, ...)	
	--Show the placer on top of the range ground placer
	local placer2 = CreateEntity()

	--[[Non-networked entity]]
	placer2.entity:SetCanSleep(false)
	placer2.persists = false

	placer2.entity:AddTransform()
	placer2.entity:AddAnimState()

	placer2:AddTag("CLASSIFIED")
	placer2:AddTag("NOCLICK")
	placer2:AddTag("placer")

	local s = 1 / PLACER_SCALE
	placer2.Transform:SetScale(s, s, s)

	placer2.AnimState:SetBank("statuerobobee")
	placer2.AnimState:SetBuild("statuerobobee")
	placer2.AnimState:PlayAnimation("anim_" .. STATUEROBOBEE_CONTAINER)
	placer2.AnimState:SetLightOverride(1)

	placer2.entity:SetParent(inst.entity)

	inst.components.placer:LinkEntity(placer2)
	
	inst.ApplySkin = function(inst, skin)
			placer2.AnimState:SetBank(skin)
			placer2.AnimState:SetBuild(skin)
	end
end

return 	Prefab("statuerobobee", fn, assets),
		MakePlacer("statuerobobee_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer),
		CreateModPrefabSkin("statuerobobee_78",
		{
		   assets = ConcatArrays(assets, {
			   Asset("ANIM", "anim/statuerobobee_78.zip"),
		   }),
		   base_prefab = "statuerobobee",
		   fn = fn_78,
		   rarity = "Timeless",
		   reskinable = true,

		   build_name_override = "statuerobobee_78",

		   type = "item",
		   skin_tags = { },
		   release_group = 0,
		}),
		CreateModPrefabSkin("statuerobobee_caterpillar",
		{
		   assets = ConcatArrays(assets, {
			   Asset("ANIM", "anim/statuerobobee_caterpillar.zip"),
		   }),
		   base_prefab = "statuerobobee",
		   fn = fn_caterpillar,
		   rarity = "Timeless",
		   reskinable = true,

		   build_name_override = "statuerobobee_caterpillar",

		   type = "item",
		   skin_tags = { },
		   release_group = 0,
		})