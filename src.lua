--[[

__/\\\_______________________________________________________________________/\\\__________/\\\\\\\\\\\\\____/\\\_____________________________________________________________________        
 _\/\\\______________________________________________________________________\/\\\_________\/\\\/////////\\\_\/\\\_____________________________________________________________________       
  _\/\\\______________________________________________________________________\/\\\_________\/\\\_______\/\\\_\/\\\____________/\\\__/\\\_______________/\\\____________________________      
   _\/\\\______________/\\\\\\\\\_____/\\\____/\\\__/\\/\\\\\\_______/\\\\\\\\_\/\\\_________\/\\\\\\\\\\\\\/__\/\\\___________\//\\\/\\\___/\\\\\\\\\\_\///______/\\\\\\\\__/\\\\\\\\\\_     
    _\/\\\_____________\////////\\\___\/\\\___\/\\\_\/\\\////\\\____/\\\//////__\/\\\\\\\\\\__\/\\\/////////____\/\\\\\\\\\\_____\//\\\\\___\/\\\//////___/\\\___/\\\//////__\/\\\//////__    
     _\/\\\_______________/\\\\\\\\\\__\/\\\___\/\\\_\/\\\__\//\\\__/\\\_________\/\\\/////\\\_\/\\\_____________\/\\\/////\\\_____\//\\\____\/\\\\\\\\\\_\/\\\__/\\\_________\/\\\\\\\\\\_   
      _\/\\\______________/\\\/////\\\__\/\\\___\/\\\_\/\\\___\/\\\_\//\\\________\/\\\___\/\\\_\/\\\_____________\/\\\___\/\\\__/\\_/\\\_____\////////\\\_\/\\\_\//\\\________\////////\\\_  
       _\/\\\\\\\\\\\\\\\_\//\\\\\\\\/\\_\//\\\\\\\\\__\/\\\___\/\\\__\///\\\\\\\\_\/\\\___\/\\\_\/\\\_____________\/\\\___\/\\\_\//\\\\/_______/\\\\\\\\\\_\/\\\__\///\\\\\\\\__/\\\\\\\\\\_ 
        _\///////////////___\////////\//___\/////////___\///____\///_____\////////__\///____\///__\///______________\///____\///___\////________\//////////__\///_____\////////__\//////////__

		LaunchPhysics is a module library where you can have physics enabled or not, custom blocks, and launch models!
--]]

local lp = {
	["functions"] = {};
	["core_lib"] = {
		["Rocket"] = {
			["Start"] = function(ins, model, core: Configuration)
				local linearvel = Instance.new("VectorForce")
				local attachment = Instance.new("Attachment")
				
				linearvel.Parent = ins
				linearvel.Force = core:GetAttribute("Vector")
				linearvel.Attachment0 = attachment
				
				attachment.Parent = ins
			end,
			
			["Stop"] = function(ins, model, core)
				ins:WaitForChild("VectorForce"):Destroy()
			end,
		};
	};
}

local HttpService = game:GetService("HttpService")

local modelIDS = {}

local function Loop(Table, Callback)
	for i, v in ipairs(Table) do
		Callback(i, v)
	end
end

-------------------------------------------------------------

function lp.functions.Run(model: Model)
	local center = nil
	
	Loop(model:GetDescendants(), function(num, ins)
		if model:FindFirstChild("Center") then
			center = model:WaitForChild("Center")
		end
		
		if ins:IsA("BasePart") then
			ins.Anchored = false
		end
		
		if lp.core_lib[ins.Name] and ins:IsA("Configuration") then
			lp.core_lib[ins.Name].Start(ins.Parent, model, ins)
		end
		
		if center and ins:IsA("BasePart") and ins ~= center then
			local weld = Instance.new("WeldConstraint")

			weld.Parent = ins
			weld.Part1 = ins
			weld.Part0 = center
		end
	end)
end

function lp.functions.Stop(model: Model)
	Loop(model:GetDescendants(), function(num, ins)
		if ins:IsA("WeldConstraint") then
			ins:Destroy()
		elseif ins:IsA("Configuration") then
			if lp.core_lib[ins.Name] then
				lp.core_lib[ins.Name].Stop(ins.Parent, model, ins)
			end
		end
		
		if ins:IsA("BasePart") then
			ins.Anchored = true
		end
	end)
end

return lp
