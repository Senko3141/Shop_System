-- Sylvern

-- Variables

local Shop = workspace:WaitForChild("Shop")
local Items = Shop.Items

local Modules = game:GetService("ReplicatedStorage"):WaitForChild('Modules')
local itemInfo = require(Modules.ItemsInfo)

local Players = game:GetService("Players")

local Cooldowns = {};
local Inventories = {};

local Clicks = {};

local ShopEvent = game:GetService("ReplicatedStorage").Events.ShopEvent

-- Functions

Players.PlayerAdded:Connect(function(plr)
	
	-- Add datastore later.
	
	Inventories[plr.Name] = {
		Items = {};
		
	};
	
end)

ShopEvent.OnServerEvent:Connect(function(plr)
	local v = plr.Valis
	
	v.Value = v.Value + 10
end)



for _,v in pairs(Items:GetChildren()) do
	if v:FindFirstChild('Click') then
		
		local Success, Item = itemInfo:Get('Item', v.ItemName.Value)
		
		if not Success then return end
		if not Item then return end
		
		local Price = Item['Price']
		local ItemName = Item['Name']
		local Type = Item['Type']
		local CanStack = Item['Stackable']
		
		
		v.Click.MouseClick:Connect(function(plr)
			if Clicks[plr.Name] then return end
			
			if Cooldowns[plr.Name..'-'.. ItemName] then 
			ShopEvent:FireClient(plr, 'Shop', 'Please wait 2 seconds before buying this item again.')
			-- Fire client here for cooldown.
			warn"Please wait 2 seconds before buying this item again." return end
			
			local ValisAmount = plr:WaitForChild('Valis')
			
			coroutine.wrap(function()
				Clicks[plr.Name] = true
				wait(3)
				Clicks[plr.Name] = nil
			end)()
			
			if ValisAmount then
				
				if ValisAmount.Value < Price then
					ShopEvent:FireClient(plr, 'Shop', 'You do not have enough money to buy this item.')
					
					warn'You do not have enough money to purchase this.'
					return
				end
				
				if ValisAmount.Value >= Price then
					
					ValisAmount.Value = ValisAmount.Value - Price
					
					if CanStack == true then -- Stackable.
						
						if Inventories[plr.Name].Items[ItemName] then -- already has item
							local CurrentAmount = Inventories[plr.Name].Items[ItemName].Amount
							local NewAmount = CurrentAmount + 1
							
							Inventories[plr.Name].Items[ItemName].Amount = NewAmount
							
							print(Inventories[plr.Name].Items[ItemName].Amount)
						else
							
							Inventories[plr.Name].Items[ItemName] = {
								Stackable = true;
								Amount = 1,
							};
							print'ee'
							
						end
						
					end
					
					if CanStack == false then -- Non stackable.
						Inventories[plr.Name].Items[ItemName] = {
							Stackable = false;
						};
						print'nunu'
					end
					
					warn("Successfully bought item: ".. ItemName)
					ShopEvent:FireClient(plr, 'Shop', 'Successfully bought: '.. ItemName)
					
					coroutine.wrap(function()
						Cooldowns[plr.Name..'-'.. ItemName] = true
						wait(2)
						Cooldowns[plr.Name..'-'.. ItemName] = nil
						
					end)()
					
				end
			end
			
		end)
		
		
	end
end


