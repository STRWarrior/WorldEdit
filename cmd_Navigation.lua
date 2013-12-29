----------------------------------------------
----------------------UP----------------------
----------------------------------------------
function HandleUpCommand(Split, Player)
	if #Split < 2 then
		Player:SendMessage(cChatColor.Rose .. "Too few arguments.")
		Player:SendMessage(cChatColor.Rose .. "/up <block>")
		return true
	elseif #Split > 2 then
		Player:SendMessage(cChatColor.Rose .. "Too many arguments.")
		Player:SendMessage(cChatColor.Rose .. "/up <block>")
		return true
	end
	local Height = tonumber(Split[2])
	if Height == nil then
		Player:SendMessage(cChatColor.Rose .. 'Number expected; string"' .. Split[2] .. '" given.')
		return true
	end
	local Y = math.floor(Player:GetPosY())
	local y = math.floor(Player:GetPosY()) + Height
	local X = math.floor(Player:GetPosX())
	local Z = math.floor(Player:GetPosZ())
	local World = Player:GetWorld()
	for Y = Y, y + 1 do
		if World:GetBlock(X, Y, Z) ~= E_BLOCK_AIR then
			Player:SendMessage(cChatColor.Rose .. "You would hit something above you.")
			return true
		end
	end
	World:SetBlock(X, y - 1, Z, 20, 0)
	Player:TeleportToCoords(X + 0.5, y, Z + 0.5)
	Player:SendMessage(cChatColor.LightPurple .. "Whoosh!")
	return true
end


----------------------------------------------
--------------------JUMPTO--------------------
----------------------------------------------
function HandleJumpToCommand(Split, Player)
	if #Split ~= 1 then
		Player:SendMessage(cChatColor.Rose .. "Too many arguments.")
		Player:SendMessage(cChatColor.Rose .. "/jumpto")
		return true
	end
	LeftClickCompass(Player, Player:GetWorld())
	Player:SendMessage(cChatColor.LightPurple .. "Poof!!")
	return true
end


----------------------------------------------
---------------------THRU---------------------
----------------------------------------------
function HandleThruCommand(Split, Player)
	if #Split ~= 1 then
		Player:SendMessage(cChatColor.Rose .. "Too many arguments.")
		Player:SendMessage(cChatColor.Rose .. "/thru")
		return true
	end
	RightClickCompass(Player, Player:GetWorld())
	Player:SendMessage(cChatColor.LightPurple .. "Whoosh!")
	return true
end


-----------------------------------------------
--------------------DESCEND--------------------
-----------------------------------------------
function HandleDescendCommand(Split, Player)
	local World = Player:GetWorld()
	if Player:GetPosY() > 1 then
		local X = math.floor(Player:GetPosX())
		local Z = math.floor(Player:GetPosZ())
		local Air = false
		for Y=math.floor(Player:GetPosY()), 1, -1 do
			if World:GetBlock(X, Y, Z) == E_BLOCK_AIR then
				if (Air) then -- if the player went through blocks other then air then go further until you can teleport
					for I=Y, 1 , -1 do
						if g_BlockIsSolid[World:GetBlock(X, I, Z)] then
							Y = I
							break
						end
					end
					y = Y
					break
				end
			else
				Air = true
			end
		end
		if y ~= nil then
			if (Air) then
				if Y ~= 1 then
					Player:TeleportToCoords(Player:GetPosX(), y + 1, Player:GetPosZ())
				end
			end
		end		
	end
	Player:SendMessage(cChatColor.LightPurple .. "Descended a level.")
	return true
end


------------------------------------------------
---------------------ASCEND---------------------
------------------------------------------------
function HandleAscendCommand(Split, Player)
	local World = Player:GetWorld()
	if Player:GetPosY() == World:GetHeight(math.floor(Player:GetPosX()), math.floor((Player:GetPosZ()))) then
		Player:SendMessage(cChatColor.LightPurple .. "Ascended a level.")
	else
		local X = math.floor(Player:GetPosX())
		local Z = math.floor(Player:GetPosZ())
		local Air = false
		for Y = math.floor(Player:GetPosY()), World:GetHeight(X, Z) + 1 do
			if World:GetBlock(X, Y, Z) == E_BLOCK_AIR then
				if (Air) then
					y = Y
					break
				end
			else
				Air = true
			end
		end
		if y ~= nil then
			if (Air) then			
				Player:TeleportToCoords(Player:GetPosX(), y, Player:GetPosZ())
			end
		end		
	end	
	Player:SendMessage(cChatColor.LightPurple .. "Ascended a level.")
	return true
end


------------------------------------------------
----------------------CEIL----------------------
------------------------------------------------
function HandleCeilCommand(Split, Player)
	if #Split > 2 then
		Player:SendMessage(cChatColor.Rose .. "Too many arguments.")
		Player:SendMessage(cChatColor.Rose .. "/ceil [cleurance]")
		return true
	end
	if Split[2] == nil then
		ClearAnce = 0
	else
		ClearAnce = tonumber(Split[2])
	end
	if ClearAnce == nil then
		Player:SendMessage(cChatColor.Rose .. 'Number expected; string "' .. Split[2] .. '" given.')
		return true
	end
	local World = Player:GetWorld()
	local X = math.floor(Player:GetPosX())
	local Y = math.floor(Player:GetPosY())
	local Z = math.floor(Player:GetPosZ())
	local WorldHeight = World:GetHeight(X, Z)
	if Y >= WorldHeight + 1 then
		Player:SendMessage(cChatColor.Rose .. "No free spot above you found.")
		return true
	end
	for y=Y, WorldHeight do
		if World:GetBlock(X, y, Z) ~= E_BLOCK_AIR then
			World:SetBlock(X, y - ClearAnce - 3, Z, E_BLOCK_GLASS, 0)
			local I = y - ClearAnce - 2
			if I == Y then
				Player:SendMessage(cChatColor.Rose .. "No free spot above you found.")
				return true
			end
			Player:TeleportToCoords(X + 0.5, I, Z + 0.5)
			break
		end
	end
	Player:SendMessage(cChatColor.LightPurple .. "Whoosh!")
	return true
end