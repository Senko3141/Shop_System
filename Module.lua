-- FoodInfo.lua

local module = {}

local items = {
	['Food Bowl'] = {
		Name = 'Food Bowl',
		Price = 50,
		Type = 'Food',
		Stackable = true,
	};
	
	['Wooden Sword'] = {
		Name = 'Wooden Sword',
		Price = 100,
		Type = 'Sword',
		Stackable = false,
	};
	
};

function module:Get(action, name)
	if action == 'Item' then
		
		if name then
			
			if items[name] then
				
				return true, items[name]
			else
				return false
			end
			
		end
		
	end
end


return module
