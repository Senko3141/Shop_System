-- Sylvern

-- Variables

local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
local ShopEvent = Events.ShopEvent

-- Functions

ShopEvent.OnClientEvent:Connect(function(action, msg)
	if action == 'Shop' then
		
		script.Parent.TextLabel.Text = msg
		
		for i = 1,0,-0.1 do
			script.Parent.TextLabel.TextTransparency = i
			wait()
		end
		wait(2)
		
		for i = 0,1,0.1 do
			script.Parent.TextLabel.TextTransparency = i
			wait()
		end
		
		script.Parent.TextLabel.Text = ''
		
	end
end)
