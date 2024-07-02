local RunService = game:GetService("RunService")

if RunService:IsServer() then
	return {
		Launch = function(Model: Model, callback)
			local clone = Model:Clone()
			clone.Name = Model.Name.."#"..math.random(1, 5000)
			clone:SetAttribute("Pivot", Model:GetPivot())
			clone.Parent = script
			
			local center = Instance.new("Part")
			center.Size = Vector3.new(1, 1, 1)
			center.CanCollide = false
			center.Transparency = 0.5
			center.Color = Color3.new(1, 0, 0)
			center.Position = Model:GetPivot().Position
			center.Anchored = true
			center.Parent = Model
			
			for i, part in pairs(Model:GetDescendants()) do
				if part:IsA("Part") or part:IsA("MeshPart") and part ~= center then
					part.Transparency = 1
					
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = part
					weld.Part1 = center
					weld.Parent = part
					
					if callback then
						callback(part, weld)
					end
					
					RunService.Heartbeat:Wait()
					part.Transparency = 0
					part.Anchored = false
				end
			end
		end,
		
		Stop = function(Model: Model)
			local name = Model.Name
			
			Model:Destroy()
			
			for i, child in pairs(script:GetChildren()) do
				if string.find(child.Name, name) then
					if child:GetAttribute("Pivot") then
						local cf = child:GetAttribute("Pivot")

						child:PivotTo(cf)
						child.Name = name
						child.Parent = workspace
						
						child:SetAttribute("Pivot", nil)
					end
				end
			end
		end,
	}
end
