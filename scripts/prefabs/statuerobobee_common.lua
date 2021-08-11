local function MakeStatueRobobeeSkin( name )
	require "prefabutil"
	require "robobeeutil"

	local assets =
	{
		Asset("ANIM", "anim/statuerobobee" .. name .. ".zip"),
		-- reuse asset from Ice Flingomatic
		Asset("ANIM", "anim/firefighter_placement.zip"),
	}

	local PLACER_SCALE = 1.55

	local function UpdateSwapBee(inst)
		if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 then
			inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/sleep", "zzz") 
			inst.AnimState:Show("SWAP_ROBOBEE") 
			if inst.components.sanityaura then
				inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY/2
			end
		else 
			inst.AnimState:Hide("SWAP_ROBOBEE") 
			inst.SoundEmitter:KillSound("zzz")
			if inst.components.sanityaura then
				inst.components.sanityaura.aura = 0
			end
		end
	end

	local function UpdateContainerTable(inst)
		local inv = inst.components.container
		
		local allslots = {1, 2, 3, 4, 5, 6, 7, 8, 9}
		
		for k, v in pairs (allslots) do
			inst.AnimState:OverrideSymbol(tostring(k), "statuerobobee" .. name, "blank_frame")
		end
		
		for k, v in pairs(inv.slots) do
			if v ~= nil then
				inst.AnimState:OverrideSymbol(tostring(k), "statuerobobee" .. name, tostring(k))
			end
		end
		
	end

	local function OnRobobeeSpawned(inst, child)
		if inst.components.childspawner and child.components.follower and child.components.follower.leader ~= inst then
			child.components.follower:SetLeader(inst)
			inst.AnimState:Hide("SWAP_ROBOBEE")
			if STATUEROBOBEE_CONTAINER == "chest" then
				inst.MiniMapEntity:SetIcon("statuerobobee_map" .. name .. ".tex")
			else
				inst.MiniMapEntity:SetIcon("statuerobobee_map_icebox" .. name .. ".tex")
			end
			--print("Spawned Bee")
		end
	end

	local function OnRobobeeBackHome(inst, child)
		if child and child.components.inventory then
			inst.AnimState:Show("SWAP_ROBOBEE")
			
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
			
			if STATUEROBOBEE_CONTAINER == "chest" then
				inst.MiniMapEntity:SetIcon("statuerobobee_map_full" .. name .. ".tex")
			else
				inst.MiniMapEntity:SetIcon("statuerobobee_map_full_icebox" .. name .. ".tex")
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
						--v:PushEvent("death")
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
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("idle", true)
		end
		
		local inv = inst.components.container

		if inv and inv:IsOpen() then
			inv:Close()
		end
	end

	local function CheckAreaAndSpawnBee(inst)
		if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 then
			
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
			inst.AnimState:OverrideSymbol("chest", "statuerobobee" .. name, STATUEROBOBEE_CONTAINER .. "_lid_open")
			if STATUEROBOBEE_CONTAINER == "chest" then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
			else
				inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
			end
		end
		--UpdateContainerTable(inst)
	end 

	local function onclose(inst)
		if not inst:HasTag("burnt") then
			inst.AnimState:OverrideSymbol("chest", "statuerobobee" .. name, STATUEROBOBEE_CONTAINER)
			if STATUEROBOBEE_CONTAINER == "chest" then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
			else
				inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
			end
		end
		UpdateContainerTable(inst)
	end

	local function OnBuilt(inst)
		inst.AnimState:PlayAnimation("building")
		inst.AnimState:PushAnimation("idle", true)
	end

	local function UpdateMapIcon(inst)
		if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 then
			if STATUEROBOBEE_CONTAINER == "chest" then
				inst.MiniMapEntity:SetIcon("statuerobobee_map_full" .. name .. ".tex")
			else
				inst.MiniMapEntity:SetIcon("statuerobobee_map_full_icebox" .. name .. ".tex")
			end
		else
			if STATUEROBOBEE_CONTAINER == "chest" then
				inst.MiniMapEntity:SetIcon("statuerobobee_map" .. name .. ".tex")
			else
				inst.MiniMapEntity:SetIcon("statuerobobee_map_icebox" .. name .. ".tex")
			end
		end
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
				UpdateSwapBee(inst)
			end
		-- In case there's no bee inside nor outside, force add it
		elseif inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 and inst.components.childspawner.childreninside <= 0 then
			inst.components.childspawner.numchildrenoutside = 0
			inst.components.childspawner.childreninside = 1
			UpdateSwapBee(inst)
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

	local function placer_postinit_fn(inst)
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
	end

	local function placer_postinit_fn_78(inst)
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

		placer2.AnimState:SetBank("statuerobobee_78")
		placer2.AnimState:SetBuild("statuerobobee_78")
		placer2.AnimState:PlayAnimation("anim_" .. STATUEROBOBEE_CONTAINER)
		placer2.AnimState:SetLightOverride(1)

		placer2.entity:SetParent(inst.entity)

		inst.components.placer:LinkEntity(placer2)
	end

	local function placer_postinit_fn_caterpillar(inst)
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

		placer2.AnimState:SetBank("statuerobobee_caterpillar")
		placer2.AnimState:SetBuild("statuerobobee_caterpillar")
		placer2.AnimState:PlayAnimation("anim_" .. STATUEROBOBEE_CONTAINER)
		placer2.AnimState:SetLightOverride(1)

		placer2.entity:SetParent(inst.entity)

		inst.components.placer:LinkEntity(placer2)
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		MakeObstaclePhysics(inst, .5)

		inst.MiniMapEntity:SetPriority(5)
		if STATUEROBOBEE_CONTAINER == "chest" then
			inst.MiniMapEntity:SetIcon("statuerobobee_map" .. name .. ".tex")
		else
			inst.MiniMapEntity:SetIcon("statuerobobee_map_icebox" .. name .. ".tex")
		end

		inst.AnimState:SetBank("statuerobobee" .. name)
		inst.AnimState:SetBuild("statuerobobee" .. name)
		inst.AnimState:PlayAnimation("idle", true)
		inst.AnimState:OverrideSymbol("chest", "statuerobobee" .. name, STATUEROBOBEE_CONTAINER)

		inst:AddTag("statue")
		inst:AddTag("statuerobobee")
		if STATUEROBOBEE_CONTAINER == "chest" then
			inst:AddTag("chest")
		else
			inst:AddTag("fridge")
		end
		
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
		inst.components.childspawner.childname = "robobee" .. name
		inst.components.childspawner:SetMaxChildren(1)
		inst.components.childspawner:SetSpawnedFn(OnRobobeeSpawned)
		inst.components.childspawner:SetGoHomeFn(OnRobobeeBackHome)
		--inst.components.childspawner:SetRegenPeriod(1)
		inst.components.childspawner:StopRegen()
		
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("treasurechest")
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose
		--inst.components.container.itemtestfn = nil

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(6)
		inst.components.workable:SetOnFinishCallback(OnDestroyed)
		inst.components.workable:SetOnWorkCallback(OnHit)
		inst:ListenForEvent("onbuilt", OnBuilt)

		inst:AddComponent("lootdropper")
		--inst.components.lootdropper:SetChanceLootTable("statueglommer")
		
		inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = 0

		MakeHauntableWork(inst)
		
		inst.updateswapbee = UpdateSwapBee
		inst.checkarea = CheckAreaAndSpawnBee
		
		inst:DoPeriodicTask(3, function(inst) CheckAreaAndSpawnBee(inst) end)
		
		--inst:DoPeriodicTask(0.4, function(inst) if inst.components.childspawner and inst.components.childspawner.numchildrenoutside <= 0 then inst.AnimState:Show("SWAP_ROBOBEE") else inst.AnimState:Hide("SWAP_ROBOBEE") end end)
		
		inst:DoPeriodicTask(100*FRAMES, function(inst)
			UpdateSwapBee(inst)
		end)
		
		inst:DoTaskInTime(0, function(inst)
			local pt = Vector3(inst.Transform:GetWorldPosition())
		
			if TheWorld.Map:IsPassableAtPoint(pt.x, pt.y, pt.z, false, true) then
				UpdateContainerTable(inst) 
				UpdateSwapBee(inst)
				UpdateMapIcon(inst)
				MakeSureHasChild(inst)
			else
				--G10MM-3R Statue CANNOT be spawned in ANY CASE in an invalid area
				--If it is, destroy it immediately to prevent crashes
				--Drop all ingredients though, we don't want the player to get annoyed in case the spawn placement seemed correct
				PreventSpawn(inst)
			end
		end)
		
		--inst:ListenForEvent("gotnewitem", UpdateContainerTable(inst))
		--inst:ListenForEvent("itemget", UpdateContainerTable(inst))
		--inst:ListenForEvent("itemlose", UpdateContainerTable(inst))
		
		return inst	
	end
		
	local function GetPlacerFn(var)
		if var and var == "_78" then 
			return placer_postinit_fn_78 
		elseif var and var == "_caterpillar" then 
			return placer_postinit_fn_caterpillar
		else
			return placer_postinit_fn 
		end
	end

	return Prefab("statuerobobee" .. name, fn, assets),
		   MakePlacer("statuerobobee_placer" .. name, "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, GetPlacerFn(name))
end

return MakeStatueRobobeeSkin