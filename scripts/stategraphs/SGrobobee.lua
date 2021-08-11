require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.GOHOME, "flyaway"),
	ActionHandler(ACTIONS.PICK, "goo"),
	ActionHandler(ACTIONS.PICKUP, "goo"),
	ActionHandler(ACTIONS.HARVEST, "goo"),
	ActionHandler(ACTIONS.BREAKSTACK, "collect"),
}

local events=
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttack(),
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnLocomote(false,true),
}

local function StartFlap(inst)
	if inst.FlapTask then return end
	inst.FlapTask = inst:DoPeriodicTask(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/wing_flap") end)
end

local function StopFlap(inst)
	if inst.FlapTask then
		inst.FlapTask:Cancel()
		inst.FlapTask = nil
	end
end

local states=
{
	State
	{
		name = "idle",
		tags = {"idle"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
			StartFlap(inst)
			if math.random() > 0.75 then
				inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/idle")
			end
		end,

		timeline =
		{
			TimeEvent(3*FRAMES, function(inst)
				if math.random() > 0.75 then
					inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/idle")
				end
			end),
			TimeEvent(15*FRAMES, function(inst)
				if not (inst.components.freezable and inst.components.freezable:IsFrozen()) then
					if inst.pickable_target ~= nil then
						if inst.pickable_target.robobee_picker ~= nil and inst.pickable_target.robobee_picker == inst then
							inst.pickable_target.robobee_picker = nil
							if inst.pickable_target:HasTag("robobee_target") then
								inst.pickable_target:RemoveTag("robobee_target")
							end
						end
						inst.pickable_target = nil
					end
					inst.somethingbroke = true
				else
					inst.sg:GoToState("frozen")
				end
			end)
		},

		events =
		{
			EventHandler("animover", function(inst)
				-- Robobee should never reach the end of its idle animation while the brain is operating correctly.
				-- This is an "emergency reset" option, in case something interrups its working schedule.
				-- Only time it should happen is when it's frozen - let's force it here if it doesn't happen for some reason.
				if not (inst.components.freezable and inst.components.freezable:IsFrozen()) then
					if inst.bufferedaction ~= nil then
						inst:ClearBufferedAction()
					end
					if inst.stacktobreak ~= nil then
						inst.stacktobreak = nil
					end
					if inst.pickable_target ~= nil then
						inst.pickable_target = nil
					end
					inst.somethingbroke = true
				else
					inst.sg:GoToState("frozen")
				end

				--if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
					--inst.components.homeseeker:GoHome(true)
				--end
				--inst.sg:GoToState("emergencystate")
			end)
		},
	},

	State
	{
		name = "goo",
		tags = {"busy", "pausepredict", "nomorph", "nodangle", "beam"},

		onenter = function(inst, fuel)
			inst.Physics:Stop()

			if inst.pickable_target ~= nil and inst.pickable_target:HasTag("robobee_target") and inst.pickable_target.robobee_picker ~= nil and inst.pickable_target.robobee_picker ~= inst then
				inst:ClearBufferedAction()
				--print("BufferedAction cleared")
				inst.sg:GoToState("idle")
			else
				inst.AnimState:PlayAnimation("place")
				StartFlap(inst)
			end

			--inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
		end,

		onexit = function(inst)
			if inst.pickable_target ~= nil and inst.pickable_target:HasTag("robobee_target") and inst.pickable_target.robobee_picker == inst then
				inst.pickable_target:RemoveTag("robobee_target")
				inst.pickable_target.robobee_picker = nil
				inst.pickable_target = nil

			else
				if inst.pickable_target ~= nil then
					inst.pickable_target = nil
				end
			end

			if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
				local base = inst.components.homeseeker.home
				--base.checkarea(base)
				if inst.components.homeseeker.home.passtargettobee ~= nil then
					inst.components.homeseeker.home.passtargettobee = nil -- reset target sent from base
				end
			end
		end,

		timeline =
		{
			TimeEvent(8*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/beam")
			end),
			TimeEvent(10*FRAMES, function(inst)
				if math.random() > 0.5 then
					inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/idle")
				end

				local XYZ = nil

				if inst and inst.prefab and inst.prefab == "robobee_78" then
					XYZ = "sparks_robobee_78"
				elseif inst and inst.prefab and inst.prefab == "robobee_caterpillar" then
					XYZ = "sparks_robobee_caterpillar"
				else
					XYZ = "sparks_robobee"
				end

				local flash = SpawnPrefab(XYZ)
				if flash then
					flash.Transform:SetPosition(inst.Transform:GetWorldPosition())
				end

				local function FadeLoop(inst, item)
					if inst.counttask > 0 then

						inst:DoTaskInTime(FRAMES*1, function(inst, item)
							if inst.bufferedaction and inst.bufferedaction.target then
								local item = inst.bufferedaction.target
								--print("Item is " .. item.prefab ..".")
								if item ~= nil and item.components.inventoryitem and not item.components.inventoryitem.owner and item.AnimState then -- this check is in case player snatches the item before bee finishes picking it up
									inst.counttask = inst.counttask-1

									local alpha = 1

									alpha = 1*(inst.counttask/15)

									if alpha <= 0 then
										alpha = 0
									end

									--print("Alpha channel: " .. alpha .. ".")

									item.AnimState:OverrideMultColour(alpha, alpha, alpha, alpha)
								end

								FadeLoop(inst, item)
							end
						end)

					end
				end

				if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target.components.inventoryitem and not inst.bufferedaction.target.components.inventoryitem.owner and inst.bufferedaction.target.AnimState then
					inst.counttask = 15

					inst.bufferedaction.target.wasmadeclear = true

					FadeLoop(inst, inst.bufferedaction.target)
				end
			end),
			TimeEvent(23*FRAMES, function(inst)
				if inst.bufferedaction and inst.bufferedaction.target and (inst.bufferedaction.target.components.pickable or inst.bufferedaction.target.components.crop or inst.bufferedaction.target.components.crop_legion or inst.bufferedaction.target.components.dryer or inst.bufferedaction.target.components.harvestable) then
					inst:PerformBufferedAction()
				end
			end),
			TimeEvent(30*FRAMES, function(inst)
				--if inst.bufferedaction and inst.bufferedaction.target and inst.bufferedaction.target.components.inventoryitem and (inst.bufferedaction.target.components.inventoryitem.canbepickedup == nil or inst.bufferedaction.target.components.inventoryitem.canbepickedup == false) then
					--inst.bufferedaction.target.components.inventoryitem.canbepickedup = true
				--end
				if inst.bufferedaction and inst.bufferedaction.target and not inst.bufferedaction.target.components.pickable
					and inst.bufferedaction.target.components.inventoryitem and inst.bufferedaction.target.components.inventoryitem.canbepickedup == true then
					inst:PerformBufferedAction()
				end
			end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
		},

	},

	State
	{
		name = "collect",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("collect")
			StartFlap(inst)
		end,

		onexit = function(inst)
			if inst.stacktobreak ~= nil then
				if inst.stacktobreak.stackbreaker ~= nil then
					inst.stacktobreak.stackbreaker = nil
				end
				inst.stacktobreak = nil
			end
			if inst.components.homeseeker and inst.components.homeseeker:HasHome() and inst.components.homeseeker.home.passtargettobee ~= nil then
				inst.components.homeseeker.home.passtargettobee = nil
			end
		end,

		timeline =
		{
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/idle") end),
			TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/bounce_ground")
			if inst.bufferedaction ~= nil then
				inst:PerformBufferedAction()
			end end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
		},
	},

	State{
		name = "frozen",
		tags = {"busy", "frozen"},

		onenter = function(inst)
			if inst.components.locomotor then
				inst.components.locomotor:StopMoving()
			end
			inst.AnimState:PlayAnimation("frozen")
			inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
			inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
			StopFlap(inst)
		end,

		onexit = function(inst)
			inst.AnimState:ClearOverrideSymbol("swap_frozen")
		end,

		events=
		{
			EventHandler("onthaw", function(inst) inst.sg:GoToState("thaw") end ),
		},
	},

	State{
		name = "thaw",
		tags = {"busy", "thawing"},

		onenter = function(inst)
			if inst.components.locomotor then
				inst.components.locomotor:StopMoving()
			end
			inst.AnimState:PlayAnimation("frozen_loop_pst", true)
			inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
			inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
			StopFlap(inst)
		end,

		onexit = function(inst)
			inst.SoundEmitter:KillSound("thawing")
			inst.AnimState:ClearOverrideSymbol("swap_frozen")
		end,

		events =
		{
			EventHandler("unfreeze", function(inst)
				if inst.sg.sg.states.hit then
					inst.sg:GoToState("hit")
				else
					inst.sg:GoToState("idle")
				end
			end ),
		},
	},

	State{
		name = "flyaway",
		tags = {"flight", "busy"},
		onenter = function(inst)
			inst.Physics:Stop()
	        inst.DynamicShadow:Enable(false)
			inst.AnimState:PlayAnimation("walk_pre")
			StartFlap(inst)
		end,

		timeline =
		{
			TimeEvent(3*FRAMES, function(inst) inst:PerformBufferedAction() end)
		}
	},

	State{ -- THIS ONE IS CURRENTLY LEFT UNUSED
		name = "emergencystate", -- this state will NEVER be reached during normal operation of the brain. Robobee will only ever enter it when something breaks.
		tags = {"emergency", "busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("interact_active")
			StartFlap(inst)
			if math.random() > 0.75 then
				inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/idle")
			end
		end,

		timeline =
		{
			TimeEvent(3*FRAMES, function(inst)
				if math.random() > 0.75 then
					inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/idle")
				end
			end),
			TimeEvent(30*FRAMES, function(inst)
				-- Clear EVERYTHING and send robobee to base. The base will provide a new, safe target.
				if inst.bufferedaction ~= nil then
					inst:ClearBufferedAction()
				end
				if inst.stacktobreak ~= nil then
					inst.stacktobreak = nil
				end
				if inst.pickable_target ~= nil then
					inst.pickable_target = nil
				end
				if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
					inst.components.homeseeker:GoHome(true)
				end
			end)
		},

		events =
		{
			EventHandler("animover", function(inst)
				if inst.bufferedaction ~= nil then
					inst:ClearBufferedAction()
				end
				if inst.stacktobreak ~= nil then
					inst.stacktobreak = nil
				end
				if inst.pickable_target ~= nil then
					inst.pickable_target = nil
				end
				if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
					inst.components.homeseeker:GoHome(true)
				end
			end)
		},
	},
}

CommonStates.AddSimpleActionState(states, "action", "idle", FRAMES*5, {"busy"})
CommonStates.AddCombatStates(states,
{
	hittimeline =
	{
		TimeEvent(0, function(inst) StartFlap(inst) end),
		TimeEvent(0, function(inst)	inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/death") end)
	},
	deathtimeline =
	{
		TimeEvent(0, function(inst) StartFlap(inst) end),
		TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/death") end),
		TimeEvent(10*FRAMES, function(inst) StopFlap(inst) end),
		TimeEvent(18*FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/faceplant_ground")
			--inst:DoTaskInTime(2, ErodeAway)
		end)
	},
})

CommonStates.AddWalkStates(states,
{
	starttimeline = {TimeEvent(0, function(inst) StartFlap(inst) end)},
	walktimeline = {TimeEvent(0, function(inst) StartFlap(inst) end)},
	endtimeline = {TimeEvent(0, function(inst) StartFlap(inst) end)},
})

CommonStates.AddSleepStates(states,
{
	starttimeline = {TimeEvent(0, function(inst) StartFlap(inst) end)},
	sleeptimeline =
		{
			TimeEvent(0*FRAMES, function(inst) StopFlap(inst) end),
			TimeEvent(35*FRAMES, function(inst) StartFlap(inst) end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("robobeesounds/robobeesounds/sleep") end)
		},
	endtimeline = {TimeEvent(0, function(inst) StartFlap(inst) end)},
})

return StateGraph("robobee", states, events, "idle", actionhandlers)