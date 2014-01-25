-----------------------------------------------
-------------------BIOMEINFO-------------------
-----------------------------------------------
function HandleBiomeInfoCommand(Split, Player)
	if Split[2] == "-p" then
		local Biome = GetStringFromBiome(Player:GetWorld():GetBiomeAt(math.floor(Player:GetPosX()), math.floor(Player:GetPosZ())))
		Player:SendMessage(cChatColor.LightPurple .. "Biome: " .. Biome)
		return true
	end
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then
		Player:SendMessage(cChatColor.Rose .. "Make a region selection first.")
		return true
	end
	local BiomeList = {}
	local World = Player:GetWorld()
	local OneX, TwoX, OneZ, TwoZ = GetXZCoords(Player)
	for X = OneX, TwoX do
		for Z = OneZ, TwoZ do
			if not table.contains(BiomeList, GetStringFromBiome(World:GetBiomeAt(X, Z))) then
				BiomeList[#BiomeList + 1] = GetStringFromBiome(World:GetBiomeAt(X, Z))
			end
		end
	end
	Player:SendMessage(cChatColor.LightPurple .. "Biomes:\n " .. table.concat(BiomeList, "\n "))
	return true
end


------------------------------------------------
---------------------EXPAND---------------------
------------------------------------------------
function HandleExpandCommand(Split, Player)
	if Split[2] == nil or tonumber(Split[2]) == nil then
		Player:SendMessage(cChatColor.Rose .. "Invaild arguments.\n//expand <amount>")
		return true
	end
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then
		Player:SendMessage(cChatColor.Rose .. "Make a region selection first.")
		return true
	end
	if OnePlayer[Player:GetName()].y > TwoPlayer[Player:GetName()].y then
		OnePlayer[Player:GetName()].y = OnePlayer[Player:GetName()].y + tonumber(Split[2])
	else
		TwoPlayer[Player:GetName()].y = TwoPlayer[Player:GetName()].y + tonumber(Split[2])
	end
	Player:SendMessage(cChatColor.LightPurple .. "Region expanded " .. Split[2] .. " blocks.")
	return true
end


------------------------------------------------
----------------------REDO----------------------
------------------------------------------------
function HandleRedoCommand(Split, Player)
	if PersonalRedo[Player:GetName()]:GetSizeX() == 0 and PersonalRedo[Player:GetName()]:GetSizeY() == 0 and PersonalRedo[Player:GetName()]:GetSizeZ() == 0 or LastRedoCoords[Player:GetName()] == nil then
		Player:SendMessage(cChatColor.Rose .. "Nothing left to redo")
		return true
	end
	local Coords = StringSplit(LastRedoCoords[Player:GetName()], ",")
	local World = cRoot:Get():GetWorld(Coords[4])
	PersonalUndo[Player:GetName()]:Read(World, Coords[1], Coords[1] + PersonalRedo[Player:GetName()]:GetSizeX() - 1, Coords[2], Coords[2] + PersonalRedo[Player:GetName()]:GetSizeY() - 1,Coords[3],  Coords[3] + PersonalRedo[Player:GetName()]:GetSizeZ() - 1)
	LastCoords[Player:GetName()] = LastRedoCoords[Player:GetName()]
	PersonalRedo[Player:GetName()]:Write(World, Coords[1], Coords[2], Coords[3], 3)
	LastRedoCoords[Player:GetName()] = nil
	Player:SendMessage(cChatColor.LightPurple .. "Redo Successful.")
	return true
end


------------------------------------------------
----------------------UNDO----------------------
------------------------------------------------
function HandleUndoCommand(Split, Player)
	if PersonalUndo[Player:GetName()]:GetSizeX() == 0 and PersonalUndo[Player:GetName()]:GetSizeY() == 0 and PersonalUndo[Player:GetName()]:GetSizeZ() == 0 or LastCoords[Player:GetName()] == nil then
		Player:SendMessage(cChatColor.Rose .. "Nothing left to undo")
		return true
	end
	local Coords = StringSplit(LastCoords[Player:GetName()], ",")
	local World = cRoot:Get():GetWorld(Coords[4]) 
	PersonalRedo[Player:GetName()]:Read(World, Coords[1], Coords[1] + PersonalUndo[Player:GetName()]:GetSizeX() - 1, Coords[2], Coords[2] + PersonalUndo[Player:GetName()]:GetSizeY() - 1,Coords[3],  Coords[3] + PersonalUndo[Player:GetName()]:GetSizeZ() - 1)
	LastRedoCoords[Player:GetName()] = LastCoords[Player:GetName()]
	PersonalUndo[Player:GetName()]:Write(World, Coords[1], Coords[2], Coords[3], 3)
	Player:SendMessage(cChatColor.LightPurple .. "Undo Successful.")
	LastCoords[Player:GetName()] = nil
	return true
end


------------------------------------------------
----------------------SIZE----------------------
------------------------------------------------
function HandleSizeCommand(Split, Player)
	if OnePlayerX[Player:GetName()] ~= nil and TwoPlayerX[Player:GetName()] ~= nil then -- Check if there is a region selected 
		Player:SendMessage(cChatColor.LightPurple .. "the selection is " .. GetSize(Player) .. " block(s) big")
	else
		Player:SendMessage(cChatColor.LightPurple .. "Please select a region first")
	end
	return true
end


-------------------------------------------------
----------------------PASTE----------------------
-------------------------------------------------
function HandlePasteCommand(Split, Player)
	if PersonalClipboard[Player:GetName()]:GetSizeX() == 0 and PersonalClipboard[Player:GetName()]:GetSizeY() == 0 and PersonalClipboard[Player:GetName()]:GetSizeZ() == 0 then
		Player:SendMessage(cChatColor.Rose .. "Your clipboard is empty. Use //copy first.")
		return true
	end
	local PlayerName = Player:GetName()
	local World = Player:GetWorld()
	local MinX = Player:GetPosX()
	local MinY = Player:GetPosY()
	local MinZ = Player:GetPosZ()
	local MaxX = MinX + PersonalClipboard[PlayerName]:GetSizeX()
	local MaxY = MinY + PersonalClipboard[PlayerName]:GetSizeY()
	local MaxZ = MinZ + PersonalClipboard[PlayerName]:GetSizeZ()
	
	if CheckIfInsideAreas(MinX, MaxX, MinY, MaxY, MinZ, MaxZ, Player, Player:GetWorld(), "paste") then -- Check if the clipboard intersects with any of the areas.
		return true
	end
	
	LastCoords[PlayerName] = MinX .. "," .. MinY .. "," .. MinZ .. "," .. World:GetName()
	PersonalUndo[PlayerName]:Read(World, MinX, MaxX, MinY, MaxY, MinZ, MaxZ)
	PersonalClipboard[PlayerName]:Write(World, MinX, MinY, MinZ, 3) -- paste the area that the player copied
	World:WakeUpSimulatorsInArea(MinX - 1, MaxX + 1, MinY - 1, MaxY + 1, MinZ - 1, MaxZ + 1)
	Player:SendMessage(cChatColor.LightPurple .. "Pasted relative to you.")
	return true
end


------------------------------------------------
----------------------COPY----------------------
------------------------------------------------
function HandleCopyCommand(Split, Player)
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then -- Check if there is a region selected
		Player:SendMessage(cChatColor.Rose .. "No Region set")
		return true
	end
	local OneX, TwoX, OneY, TwoY, OneZ, TwoZ = GetXYZCoords(Player) -- get the right coordinates
	local World = Player:GetWorld()
	PersonalClipboard[Player:GetName()]:Read(World, OneX, TwoX, OneY, TwoY, OneZ, TwoZ) -- read the area
	Player:SendMessage(cChatColor.LightPurple .. "Block(s) copied.")
	return true
end


-----------------------------------------------
----------------------CUT----------------------
-----------------------------------------------
function HandleCutCommand(Split, Player)
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then -- Check if there is a region selected
		Player:SendMessage(cChatColor.Rose .. "No Region set")
		return true
	end
	local OneX, TwoX, OneY, TwoY, OneZ, TwoZ = GetXYZCoords(Player) -- get the right coordinates
	
	if CheckIfInsideAreas(OneX, TwoX, OneY, TwoY, OneZ, TwoZ, Player, Player:GetWorld(), "cut") then -- Check if the clipboard intersects with any of the areas.
		return true
	end
	
	local World = Player:GetWorld() -- get the world
	LastCoords[Player:GetName()] = OneX .. "," .. OneY .. "," .. OneZ .. "," .. Player:GetWorld():GetName()
	PersonalUndo[Player:GetName()]:Read(World, OneX, TwoX, OneY, TwoY, OneZ, TwoZ)
	local Cut = cBlockArea()
	PersonalClipboard[Player:GetName()]:Read(World, OneX, TwoX, OneY, TwoY, OneZ, TwoZ) -- read the area
	Cut:Read(World, OneX, TwoX, OneY, TwoY, OneZ, TwoZ) -- read the area
	Cut:Fill(3, 0, 0) -- delete the area
	Cut:Write(World, OneX, OneY, OneZ) -- write the area
	World:WakeUpSimulatorsInArea(OneX - 1, TwoX + 1, OneY - 1, TwoY + 1, OneZ - 1, TwoZ + 1)
	Player:SendMessage(cChatColor. LightPurple .. "Block(s) cut.")
	return true
end


-----------------------------------------------
----------------------SET----------------------
-----------------------------------------------
function HandleSetCommand(Split, Player)
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then -- Check if there is a region selected
		Player:SendMessage(cChatColor.Rose .. "No Region set")
		return true
	end
	
	if Split[2] == nil then
		Player:SendMessage(cChatColor.Rose .. "Please say a block ID")
		return true
	end
	
	local BlockType, BlockMeta = GetBlockTypeMeta(Player, Split[2])
	if BlockType ~= false then
		local Blocks = HandleFillSelection(Player, Player:GetWorld(), BlockType, BlockMeta)
		if Blocks then
			Player:SendMessage(cChatColor.LightPurple .. Blocks .. " block(s) have been changed.")
		end
	end
	return true
end


-------------------------------------------------
---------------------REPLACE---------------------
-------------------------------------------------
function HandleReplaceCommand(Split, Player)
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then -- Check if there is a region selected
		Player:SendMessage(cChatColor.Rose .. "No Region set")
		return true
	end
	if Split[2] == nil or Split[3] == nil then -- check if the player noted a blocktype
		Player:SendMessage(cChatColor.Rose .. "Please say a block ID")
		return true
	end
	local ChangeBlockType, ChangeBlockMeta, TypeOnly = GetBlockTypeMeta(Player, Split[2])
	local ToChangeBlockType, ToChangeBlockMeta = GetBlockTypeMeta(Player, Split[3])
	if ChangeBlockType ~= false and ToChangeBlockType ~= false then
		local Blocks = HandleReplaceSelection(Player, Player:GetWorld(), ChangeBlockType, ChangeBlockMeta, ToChangeBlockType, ToChangeBlockMeta, TypeOnly)
		if Blocks then
			Player:SendMessage(cChatColor.LightPurple .. Blocks .. " block(s) have been changed.")
		end
	end
	return true
end



-------------------------------------------------
----------------------FACES----------------------
-------------------------------------------------
function HandleFacesCommand(Split, Player)
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then -- Check if there is a region selected
		Player:SendMessage(cChatColor.Rose .. "No Region set")
		return true -- stop
	end
	if Split[2] == nil then
		Player:SendMessage(cChatColor.Rose .. "Please say a block ID")
		return true
	end
	local BlockType, BlockMeta = GetBlockTypeMeta(Player, Split[2])
	if BlockType ~= false then
		local Blocks = HandleCreateFaces(Player, Player:GetWorld(), BlockType, BlockMeta)
		if not Blocks then
			Player:SendMessage(cChatColor.Rose .. "Region intersects with an area")
		else
			Player:SendMessage(cChatColor.LightPurple .. Blocks .. " block(s) have been changed.")
		end
	end
	return true
end


-------------------------------------------------
----------------------WALLS----------------------
-------------------------------------------------
function HandleWallsCommand(Split, Player)
	if OnePlayer[Player:GetName()] == nil or TwoPlayer[Player:GetName()] == nil then -- Check if there is a region selected
		Player:SendMessage(cChatColor.Rose .. "No Region set")
		return true
	end
	if Split[2] == nil then
		Player:SendMessage(cChatColor.Rose .. "Please say a block ID")
		return true
	end
	local BlockType, BlockMeta = GetBlockTypeMeta(Player, Split[2])
	if BlockType ~= false then
		local Blocks = HandleCreateWalls(Player, Player:GetWorld(), BlockType, BlockMeta)
		if not Blocks then
			Player:SendMessage(cChatColor.Rose .. "Region intersects with an area")
		else
			Player:SendMessage(cChatColor.LightPurple .. Blocks .. " block(s) have been changed.")
		end
	end
	return true
end


------------------------------------------------
---------------------ROTATE---------------------
------------------------------------------------
function HandleRotateCommand(Split, Player)
	if Split[2] == nil or tonumber(Split[2]) == nil then -- Check if the player gave an angle
		Player:SendMessage(cChatColor.Rose .. "Too few arguments.\n//rotate [90, 180, 270]")
		return true
	end
	if tonumber(Split[2]) == 90 or tonumber(Split[2]) == 180 or tonumber(Split[2]) == 270 then
		for I =1, tonumber(Split[2]) / 90 do -- rotate the area some times.
			PersonalClipboard[Player:GetName()]:RotateCCW() -- Rotate the area
		end
		Player:SendMessage(cChatColor.Rose .. "Rotated clipboard " .. Split[2] .. " degrees")
	else
		Player:SendMessage(cChatColor.Rose .. "usage: /rotate [90, 180, 270]")
	end
	return true
end


-----------------------------------------------
-------------------SCHEMATIC-------------------
-----------------------------------------------
-- Handles the schematic's save subcommand
function HandleSchematicSaveCommand(Split, Player)
	if not PlayerHasWEPermission(Player, "worldedit.schematic.save", "worldedit.clipboard.save") then
		Player:SendMessage(cChatColor.Rose .. "You do not have permission to save schematic files.")
		return true
	end
	if #Split ~= 4 then
		Player:SendMessage(cChatColor.Rose .. "Usage: /schematic save <Format> <Name>")
		return true
	end
	local Scheme = string.upper(Split[3])
	
	if Scheme == "MCEDIT" then
		local SchematicName = Split[4]
		PersonalClipboard[Player:GetName()]:SaveToSchematicFile("Schematics/" .. Split[4] .. ".Schematic") -- save the schematic.
		Player:SendMessage(cChatColor.LightPurple .. Split[4] .. " saved.")
	else
		Player:SendMessage("Scheme " .. Split[3] .. "Does not exist.")
	end
	return true
end


-- Handles the schematic's load subcommand.
function HandleSchematicLoadCommand(Split, Player)
	if not PlayerHasWEPermission(Player, "worldeidt.schematic.load", "worldedit.clipboard.load") then
		Player:SendMessage(cChatColor.Rose .. "You do not have permission to load schematic file.")
		return true
	end
	if #Split ~= 3 then
		Player:SendMessage(cChatColor.Rose .. "Usage: /schematic load <name>")
		return true
	end
	local Path = "Schematics/" .. Split[3] .. ".Schematic"
	if not cFile:Exists(Path) then
		Player:SendMessage(cChatColor.LightPurple .. "schematic does not exist.")
		return true
	end
	PersonalClipboard[Player:GetName()]:LoadFromSchematicFile(Path) -- load the schematic file
	Player:SendMessage(cChatColor.LightPurple .. "You loaded " .. Split[3])
	return true
end


-- Handles the schematic's formats subcommand.
function HandleSchematicFormatsCommand(Split, Player)
	if not PlayerHasWEPermission(Player, "worldedit.schematic.formats") then
		Player:SendMessage(cChatColor.Rose .. "You do not have permission to use this command.")
		return true
	end
	Player:SendMessage(cChatColor.LightPurple .. 'Available formats: "MCEdit"')
	return true
end


-- Handles the schematic's list subcommand.
function HandleSchematicListCommand(Split, Player)
	if not PlayerHasWEPermission(Player, "worldeidt.schematic.list") then
		Player:SendMessage(cChatColor.Rose .. "You do not have permission to use this command.")
		return true
	end
	local FileList = cFile:GetFolderContents("Schematics")
	for Idx, FileName in ipairs(FileList) do
			FileList[Idx] = FileName:sub(1, FileName:len() - 10) -- Remove the extension part of the filename.
	end
	
	Player:SendMessage(cChatColor.LightPurple .. "Available schematics: " .. table.concat(FileList, ", ", 3))
	return true
end