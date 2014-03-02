------------------------------------------------
----------------------REPL----------------------
------------------------------------------------
function HandleReplCommand(Split, Player)
	if Split[2] == nil then -- check if the player gave a block id
		Player:SendMessage(cChatColor.Rose .. "Too few arguments.")
		Player:SendMessage(cChatColor.Rose .. "/repl <block ID>")
		return true
	end
	
	local BlockType = tonumber(Split[2]) -- ToDo: block metas
	
	if BlockType == nil then
		Player:SendMessage(cChatColor.Rose .. "Unknown character \"" .. Split[2] .. "\"")
		return true
	end
	
	local PlayerName = Player:GetName()
	
	if not IsValidBlock(BlockType) then -- check if the player gave a valid block id
		Player:SendMessage(cChatColor.Rose .. Split[2] .. " isn't a valid block")
		return true
	end
	
	if not ItemCategory.IsTool(Player:GetEquippedItem().m_ItemType) then -- Check if the player has a tool in equipped
		Player:SendMessage(cChatColor.Rose .. "Can't bind tool to \"" .. ItemToString(Player:GetEquippedItem()) .. "\": Blocks can't be used")
		return true
	end

	-- ToDo: Check if another tool is using the equipped item.
	Repl[PlayerName] = BlockType
	ReplItem[PlayerName] = Player:GetEquippedItem().m_ItemType -- bind tool to the "repl" tool
	Player:SendMessage(cChatColor.LightPurple .. "Block replacer tool bound to " .. ItemToString(Player:GetEquippedItem()))
	return true
end


------------------------------------------------
----------------------NONE----------------------
------------------------------------------------
function HandleNoneCommand(Split, Player)
	if Player:GetEquippedItem().m_ItemType == ReplItem[Player:GetName()] then -- check if the item is bound to //repl
		Repl[Player:GetName()] = nil -- unbind the item
		ReplItem[Player:GetName()] = nil -- unbind the item
	elseif Player:GetEquippedItem().m_ItemType == GrowTreeItem[Player:GetName()] then -- check if the item is bound to /tree
		GrowTreeItem[Player:GetName()] = nil -- unbind the item
	end
	Player:SendMessage(cChatColor.LightPurple .. "Tool unbound from your current item.")
	return true
end
		
	
------------------------------------------------
----------------------TREE----------------------
------------------------------------------------
function HandleTreeCommand(Split, Player)
	if ItemCategory.IsTool(Player:GetEquippedItem().m_ItemType) then -- check if the player has a tool in his hand
		GrowTreeItem[Player:GetName()] = Player:GetEquippedItem().m_ItemType -- bind tool to /tree
		Player:SendMessage(cChatColor.LightPurple .. "Tree tool bound to " .. ItemToString(Player:GetEquippedItem()))
	else
		Player:SendMessage(cChatColor.Rose .. "Can't bind tool to " .. ItemToString(Player:GetEquippedItem()) .. ": Blocks can't be used")
	end
	return true
end


-----------------------------------------------
-------------------SUPERPICK-------------------
-----------------------------------------------
function HandleSuperPickCommand(Split, Player)
	local State = GetPlayerState(Player)
	if (State.Tools:SwichSuperPickaxeActivated()) then -- check if super pickaxe is activated
		Player:SendMessage(cChatColor.LightPurple .. "Super pick activated")
	else -- else deactivate the superpickaxe
		Player:SendMessage(cChatColor.LightPurple .. "Super pick deactivated")
	end
	return true
end




