local Stackbreaker = Class(function(self, inst)
	self.inst = inst
end)

function Stackbreaker:BreakStack(stack)
	if stack and stack.components.stackable and stack.components.stackable:IsStack() and stack.components.inventoryitem and not stack.components.inventoryitem:IsHeld() and not stack:HasTag("preventduplicationtag") then
		stack:AddTag("preventduplicationtag")
		local v = stack.components.stackable.stacksize
		for k = 1, v do
			local object = SpawnPrefab(stack.prefab)
			if object then
				object.Transform:SetPosition(stack.Transform:GetWorldPosition())
				object.components.inventoryitem:OnDropped(true)
				if object.robobee_picker ~= nil then
					object.robobee_picker = nil
				end
			end
			if k and k == v then
				stack:Remove()
				break
			end
		end

	end
	return true
end

return Stackbreaker
