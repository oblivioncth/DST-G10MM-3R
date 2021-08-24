local assets =
{
	Asset("ANIM", "anim/robobee.zip"),
	Asset("SOUND", "sound/glommer.fsb"),
}

local brain = require("brains/robobeebrain")

local function OnStopFollowing(inst)
	inst:RemoveTag("companion")
end

local function OnStartFollowing(inst)
	if inst.components.follower.leader:HasTag("statuerobobee") then
		inst:AddTag("companion")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	inst.entity:AddLightWatcher()

	inst.DynamicShadow:SetSize(1.2, .4)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(0.75, 0.75, 0.75)

	MakeGhostPhysics(inst, .1, .1)

	inst.MiniMapEntity:SetIcon("robobee.tex")
	inst.MiniMapEntity:SetPriority(5)

	inst.AnimState:SetBank("glommer")
	inst.AnimState:SetBuild("robobee")
	inst.AnimState:PlayAnimation("idle_loop")

	inst:AddTag("robobee")
	inst:AddTag("flying")
	inst:AddTag("scarytoprey")
	inst:AddTag("ignorewalkableplatformdrowning")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("stackbreaker") -- for breaking those pesky stacks

	inst:AddComponent("follower")
	inst:ListenForEvent("stopfollowing", OnStopFollowing)
	inst:ListenForEvent("startfollowing", OnStartFollowing)

	inst:AddComponent("knownlocations")

	inst:AddComponent("inventory")

	inst:AddComponent("lootdropper")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY/2

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = ROBOBEE_MOVESPEED

	inst:ListenForEvent("robobee_targetstolen", function(inst)
		--print("Emergency!")
		if inst.bufferedaction ~= nil then
			inst:ClearBufferedAction()
		end
		if inst.sg ~= nil then
			inst.sg:GoToState("idle")
		end
	end)
	
	inst:ListenForEvent("robobee_homeoff", function(inst)
		--print("[G10MM-3R]: Received Event - robobee_homeoff")
		if inst.bufferedaction ~= nil then
			inst:ClearBufferedAction()
		end
		if inst.sg ~= nil then
			inst.sg:GoToState("idle")
		end
		if inst.components.homeseeker.home and inst.components.homeseeker.home:IsValid() then
			inst.components.homeseeker:GoHome(true)
		end
	end)

	inst:ListenForEvent("freeze", function(inst)
		--print("Frozen!")
		if inst.sg and not inst.sg:HasStateTag("frozen") then
			inst.sg:GoToState("frozen")
		end
	end)

	inst:ListenForEvent("equip", function(inst, data)
		-- G10MM-3R cannot equip items
		if inst.components.inventory and data.eslot then
			--print("Dropping equips...")
			inst.components.inventory:DropEquipped(false)
		end
	end)

	MakeMediumFreezableCharacter(inst, "glommer_body")

	if inst.components.freezable then
		inst.components.freezable.wearofftime = 2
	end

	inst:DoTaskInTime(0, function(inst)
		if not inst.components.homeseeker or inst.components.homeseeker and not inst.components.homeseeker:HasHome() then
			if not inst.components.health then
				inst:AddComponent("health")
			end
			inst.components.health:DoDelta(-1000)
		else
			local base = FindEntity(inst, 20, nil, nil, {"player"}, {"statuerobobee"})
			if base == nil or base and base:IsValid() and base.components.childspawner and base.components.childspawner.numchildrenoutside <= 0 then
				if inst.components.inventory and inst.components.inventory:NumItems() > 0 then
					inst.components.inventory:DropEverything(true, false)
				end
				inst:Remove()
			end
		end
	end)

	inst:SetBrain(brain)
	inst:SetStateGraph("SGrobobee")

	MakeHauntablePanic(inst)

	return inst
end

local function fn_78()
	local inst = fn()
	
	inst.MiniMapEntity:SetIcon("robobee_78.tex")
	inst.AnimState:SetBuild("robobee_78")

	return inst
end

local function fn_caterpillar()
	local inst = fn()
	
	inst.MiniMapEntity:SetIcon("robobee_caterpillar.tex")
	inst.AnimState:SetBuild("robobee_caterpillar")

	return inst
end

return  Prefab("robobee", fn, assets, prefabs),
		CreateModPrefabSkin("robobee_78",
		{
		   assets = ConcatArrays(assets, {
			   Asset("ANIM", "anim/robobee_78.zip"),
		   }),
		   base_prefab = "robobee",
		   fn = fn_78,
		   rarity = "Timeless",
		   reskinable = true,

		   build_name_override = "robobee_78",

		   type = "item",
		   skin_tags = { },
		   release_group = 0,
		}),
		CreateModPrefabSkin("robobee_caterpillar",
		{
		   assets = ConcatArrays(assets, {
			   Asset("ANIM", "anim/robobee_caterpillar.zip"),
		   }),
		   base_prefab = "robobee",
		   fn = fn_caterpillar,
		   rarity = "Timeless",
		   reskinable = true,

		   build_name_override = "robobee_caterpillar",

		   type = "item",
		   skin_tags = { },
		   release_group = 0,
		})