
-- cmd_Selection.lua

-- Implements handlers for the selection-related commands




function HandleBiomeInfoCommand(Split, Player)
	-- /biomeinfo

	-- If a "-p" param is present, report the biome at player's position:
	if (Split[2] == "-p") then
		local Biome = GetStringFromBiome(Player:GetWorld():GetBiomeAt(math.floor(Player:GetPosX()), math.floor(Player:GetPosZ())))
		Player:SendMessageInfo("Biome: " .. Biome)
		return true
	end

	-- Get the player state:
	local State = GetPlayerState(Player)
	if not(State.Selection:IsValid()) then
		Player:SendMessageFailure("Make a region selection first.")
		return true
	end
	
	-- Retrieve set of biomes in the selection:
	local BiomesSet = {}
	local MinX, MaxX = State.Selection:GetXCoordsSorted()
	local MinZ, MaxZ = State.Selection:GetZCoordsSorted()
	local World = Player:GetWorld()
	for X = MinX, MaxX do
		for Z = MinZ, MaxZ do
			BiomesSet[World:GetBiomeAt(X, Z)] = true
		end
	end

	-- Convert set to array of names:
	local BiomesArr = {}
	for b, val in pairs(BiomesSet) do
		if (val) then
			table.insert(BiomesArr, GetStringFromBiome(b))
		end
	end
	
	-- Send the list to the player:
	Player:SendMessageInfo("Biomes: " .. table.concat(BiomesArr, ", "))
	return true
end





function HandleRedoCommand(a_Split, a_Player)
	-- //redo
	local State = GetPlayerState(a_Player)
	local IsSuccess, Msg = State.UndoStack:Redo(a_Player:GetWorld())
	if (IsSuccess) then
		a_Player:SendMessageSuccess("Redo successful.")
	else
		a_Player:SendMessageFailure("Cannot redo: " .. (Msg or "unknown error"))
	end
	return true
end



function HandleUndoCommand(a_Split, a_Player)
	-- //undo
	local State = GetPlayerState(a_Player)
	local IsSuccess, Msg = State.UndoStack:Undo(a_Player:GetWorld())
	if (IsSuccess) then
		a_Player:SendMessageSuccess("Undo Successful.")
	else
		a_Player:SendMessageFailure("Cannot undo: " .. (Msg or "unknown error"))
	end
	return true
end





function HandleSizeCommand(a_Split, a_Player)
	-- //size
	local State = GetPlayerState(a_Player)
	if (State.Selection:IsValid()) then
		a_Player:SendMessageInfo("The selection size is " .. State.Selection:GetSizeDesc() .. ".")
	else
		a_Player:SendMessageFailure("Please select a region first")
	end
	return true
end





function HandlePasteCommand(a_Split, a_Player)
	-- //paste

	-- Check if there's anything in the clipboard:
	local State = GetPlayerState(a_Player)
	if not(State.Clipboard:IsValid()) then
		a_Player:SendMessageFailure("Your clipboard is empty. Use //copy or //cut first.")
		return true
	end
	
	-- Check with other plugins if the operation is okay:
	local DstCuboid = State.Clipboard:GetPasteDestCuboid(a_Player)
	if not(CheckAreaCallbacks(DstCuboid, a_Player, a_Player:GetWorld(), "paste")) then
		return
	end
	
	-- Paste:
	State.UndoStack:PushUndoFromCuboid(a_Player:GetWorld(), DstCuboid, "paste")
	local NumBlocks = State.Clipboard:Paste(a_Player, DstCuboid.p1)
	a_Player:SendMessageSuccess(NumBlocks .. " block(s) pasted relative to you.")
	return true
end





function HandleCopyCommand(a_Split, a_Player)
	-- //copy
	
	-- Get the player state:
	local State = GetPlayerState(a_Player)
	if not(State.Selection:IsValid()) then
		a_Player:SendMessage(cChatColor.Rose .. "Make a region selection first.")
		return true
	end
	
	-- Check with other plugins if the operation is okay:
	local SrcCuboid = State.Selection:GetSortedCuboid()
	local World = a_Player:GetWorld()
	if not(CheckAreaCallbacks(SrcCuboid, a_Player, World, "copy")) then
		return
	end
	
	-- Cut into the clipboard:
	local NumBlocks = State.Clipboard:Copy(World, SrcCuboid)
	a_Player:SendMessageSuccess(NumBlocks .. " block(s) copied.")
	a_Player:SendMessageInfo("Clipboard size: " .. State.Clipboard:GetSizeDesc())
	return true
end





function HandleCutCommand(a_Split, a_Player)
	-- //cut
	
	-- Get the player state:
	local State = GetPlayerState(a_Player)
	if not(State.Selection:IsValid()) then
		a_Player:SendMessageFailure("Make a region selection first.")
		return true
	end
	
	-- Check with other plugins if the operation is okay:
	local SrcCuboid = State.Selection:GetSortedCuboid()
	local World = a_Player:GetWorld()
	if not(CheckAreaCallbacks(SrcCuboid, a_Player, World, "copy")) then
		return
	end
	
	-- Push an undo snapshot:
	State.UndoStack:PushUndoFromCuboid(World, SrcCuboid, "cut")
	
	-- Cut into the clipboard:
	local NumBlocks = State.Clipboard:Cut(World, SrcCuboid)
	a_Player:SendMessageSuccess(NumBlocks .. " block(s) cut.")
	a_Player:SendMessageInfo("Clipboard size: " .. State.Clipboard:GetSizeDesc())

	return true
end





function HandleSetCommand(a_Split, a_Player)
	-- //set <blocktype>
	
	local State = GetPlayerState(a_Player)

	-- Check the selection:
	if not(State.Selection:IsValid()) then
		a_Player:SendMessageFailure("No region set")
		return true
	end
	
	-- Check the params:
	if (a_Split[2] == nil) then
		a_Player:SendMessageInfo("Usage: //set <blocktype>")
		return true
	end
	
	-- Retrieve the blocktype from the params:
	local BlockType, BlockMeta = GetBlockTypeMeta(a_Split[2])
	if not(BlockType) then
		a_Player:SendMessageFailure("Unknown block type: '" .. a_Split[2] .. "'.")
		return true
	end
	
	-- Fill the selection:
	local NumBlocks = FillSelection(State, a_Player, a_Player:GetWorld(), BlockType, BlockMeta)
	if (NumBlocks) then
		a_Player:SendMessageSuccess(NumBlocks .. " block(s) have been changed.")
	end
	return true
end





function HandleReplaceCommand(a_Split, a_Player)
	-- //replace <srcblocktype> <dstblocktype>
	
	local State = GetPlayerState(a_Player)
	
	-- Check the selection:
	if not(State.Selection:IsValid()) then
		a_Player:SendMessageFailure("No region set")
		return true
	end
	
	-- Check the params:
	if ((a_Split[2] == nil) or (a_Split[3] == nil)) then
		a_Player:SendMessageInfo("Usage: //replace <srcblocktype> <dstblocktype>")
		return true
	end
	
	-- Retrieve the blocktypes from the params:
	local RawSrcBlockTable = StringSplit(a_Split[2], ";")
	local SrcBlockTable = {}
	for Idx, Value in ipairs(RawSrcBlockTable) do
		local SrcBlockType, SrcBlockMeta, TypeOnly = GetBlockTypeMeta(Value)
		if not(SrcBlockType) then
			a_Player:SendMessageFailure("Unknown src block type: '" .. Value .. "'.")
			return true
		end
		SrcBlockTable[SrcBlockType] = {SrcBlockMeta = SrcBlockMeta, TypeOnly = TypeOnly or false}
	end
	
	local RawDstBlockTable = StringSplit(a_Split[3], ";")
	local DstBlockTable = {}
	for Idx, Value in ipairs(RawDstBlockTable) do
		local DstBlockType, DstBlockMeta = GetBlockTypeMeta(Value)
		if not(DstBlockType) then
			a_Player:SendMessageFailure("Unknown dst block type: '" .. Value .. "'.")
			return true
		end
		DstBlockTable[Idx] = {DstBlockType = DstBlockType, DstBlockMeta = DstBlockMeta}
	end
	
	-- Replace the blocks:
	local NumBlocks = ReplaceSelection(State, a_Player, a_Player:GetWorld(), SrcBlockTable, DstBlockTable)
	if (NumBlocks) then
		a_Player:SendMessageSuccess(NumBlocks .. " block(s) have been changed.")
	end
	return true
end





function HandleFacesCommand(a_Split, a_Player)
	-- //faces <blocktype>
	
	local State = GetPlayerState(a_Player)

	-- Check the selection:
	if not(State.Selection:IsValid()) then
		a_Player:SendMessageFailure("No region set")
		return true
	end
	
	-- Check the params:
	if (a_Split[2] == nil) then
		a_Player:SendMessageInfo(Usage: //faces <blocktype>")
		return true
	end
	
	-- Retrieve the blocktype from the params:
	local BlockType, BlockMeta = GetBlockTypeMeta(a_Split[2])
	if not(BlockType) then
		a_Player:SendMessageFailure("Unknown block type: '" .. a_Split[2] .. "'.")
		return true
	end
	
	-- Fill the selection:
	local NumBlocks = FillFaces(State, a_Player, a_Player:GetWorld(), BlockType, BlockMeta)
	if (NumBlocks) then
		a_Player:SendMessageSuccess(NumBlocks .. " block(s) have been changed.")
	end
	return true
end





function HandleWallsCommand(a_Split, a_Player)
	-- //walls <blocktype>

	local State = GetPlayerState(a_Player)

	-- Check the selection:
	if not(State.Selection:IsValid()) then
		a_Player:SendMessageFailure("No region set")
		return true
	end
	
	-- Check the params:
	if (a_Split[2] == nil) then
		a_Player:SendMessageInfo("Usage: //walls <blocktype>")
		return true
	end
	
	-- Retrieve the blocktype from the params:
	local BlockType, BlockMeta = GetBlockTypeMeta(a_Split[2])
	if not(BlockType) then
		a_Player:SendMessageFailure("Unknown block type: '" .. a_Split[2] .. "'.")
		return true
	end
	
	-- Fill the selection:
	local NumBlocks = FillWalls(State, a_Player, a_Player:GetWorld(), BlockType, BlockMeta)
	if (NumBlocks) then
		a_Player:SendMessageSuccess(NumBlocks .. " block(s) have been changed.")
	end
	return true
end





function HandleRotateCommand(a_Split, a_Player)
	-- //rotate [NumDegrees]
	
	-- Check if the clipboard is valid:
	local State = GetPlayerState(a_Player)
	if not(State.Clipboard:IsValid()) then
		a_Player:SendMessageFailure("Nothing in the clipboard. Use //copy or //cut first.")
		return true
	end
	
	-- Check if the player gave an angle:
	local Angle = tonumber(a_Split[2])
	if (Angle == nil) then
		a_Player:SendMessageInfo("Usage: //rotate [90, 180, 270, -90, -180, -270]")
		return true
	end
	
	-- Rotate the clipboard:
	local NumRots = math.floor(Angle / 90 + 0.5)  -- round to nearest 90-degree step
	State.Clipboard:Rotate(NumRots)
	a_Player:SendMessageSuccess("Rotated the clipboard by " .. (NumRots * 90) .. " degrees CCW")
	a_Player:SendMessageInfo("Clipboard size: " .. State.Clipboard:GetSizeDesc())
	return true
end





function HandleSchematicSaveCommand(a_Split, a_Player)
	-- //schematic save [<format>] <FileName>

	-- Get the parameters from the command arguments:
	local FileName
	if (#a_Split == 4) then
		FileName = a_Split[4]
	elseif (#a_Split == 3) then
		FileName = a_Split[3]
	else
		a_Player:SendMessageInfo("Usage: //schematic save [<format>] <FileName>")
		return true
	end

	-- Check that there's data in the clipboard:
	local State = GetPlayerState(a_Player)
	if not(State.Clipboard:IsValid()) then
		a_Player:SendMessageFailure("There's no data in the clipboard. Use //copy or //cut first.")
		return true
	end

	-- Save the clipboard:
	State.Clipboard:SaveToSchematicFile("schematics/" .. FileName .. ".schematic")
	a_Player:SendMessageSuccess("Clipboard saved to " .. FileName .. ".")
	return true
end





function HandleSchematicLoadCommand(a_Split, a_Player)
	-- //schematic load <FileName>
	
	-- Check the FileName parameter:
	if (#a_Split ~= 3) then
		a_Player:SendMessageInfo("Usage: /schematic load <FileName>")
		return true
	end
	local FileName = a_Split[3]
	
	-- Check if the file exists:
	local Path = "schematics/" .. FileName .. ".schematic"
	if not(cFile:Exists(Path)) then
		a_Player:SendMessageFailure(FileName .. " schematic does not exist.")
		return true
	end
	
	-- Load the file into clipboard:
	local State = GetPlayerState(a_Player)
	if not(State.Clipboard:LoadFromSchematicFile(Path)) then
		a_Player:SendMessageFailure(FileName .. " schematic does not exist.")
		return true
	end
	a_Player:SendMessageSuccess(FileName .. " schematic was loaded into your clipboard.")
	a_Player:SendMessageInfo("Clipboard size: " .. State.Clipboard:GetSizeDesc())

	return true
end





function HandleSchematicFormatsCommand(a_Split, a_Player)
	-- //schematic listformats
	
	-- We support only one format, MCEdit:
	a_Player:SendMessageInfo('Available formats: "MCEdit"')

	return true
end





function HandleSchematicListCommand(Split, Player)
	-- //schematic list
	
	-- Retrieve all the objects in the folder:
	local FolderContents = cFile:GetFolderContents("schematics")
	
	-- Filter out non-files and non-".schematic" files:
	local FileList = {}
	for idx, fnam in ipairs(FolderContents) do
		if (
			cFile:IsFile("schematics/" .. fnam) and
			fnam:match(".*%.schematic")
		) then
			table.insert(FileList, fnam:sub(1, fnam:len() - 10))  -- cut off the ".schematic" part of the name
		end
	end
	table.sort(FileList,
		function(f1, f2)
			return (string.lower(f1) < string.lower(f2))
		end
	)
	
	Player:SendMessageInfo("Available schematics: " .. table.concat(FileList, ", "))
	return true
end





function HandlePos1Command(a_Split, a_Player)
	-- //pos1
	local State = GetPlayerState(a_Player)
	local BlockX = math.floor(a_Player:GetPosX())
	local BlockY = math.floor(a_Player:GetPosY())
	local BlockZ = math.floor(a_Player:GetPosZ())
	State.Selection:SetFirstPoint(BlockX, BlockY, BlockZ)
	a_Player:SendMessage("First position set to {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "}.")
	return true
end





function HandlePos2Command(a_Split, a_Player)
	-- //pos2
	local State = GetPlayerState(a_Player)
	local BlockX = math.floor(a_Player:GetPosX())
	local BlockY = math.floor(a_Player:GetPosY())
	local BlockZ = math.floor(a_Player:GetPosZ())
	State.Selection:SetSecondPoint(BlockX, BlockY, BlockZ)
	a_Player:SendMessage("Second position set to {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "}.")
	return true
end





function HandleHPos1Command(a_Split, a_Player)
	-- //hpos1
	
	-- Trace the blocks along the player's look vector until a hit is found:
	local Target = HPosSelect(a_Player)
	if not(Target) then
		a_Player:SendMessageFailure("You were not looking at a block.")
		return true
	end
	
	-- Select the block:
	local State = GetPlayerState(a_Player)
	State.Selection:SetFirstPoint(Target.x, Target.y, Target.z)
	a_Player:SendMessage("First position set to {" .. Target.x .. ", " .. Target.y .. ", " .. Target.z .. "}.")
	return true
end





function HandleHPos2Command(a_Split, a_Player)
	-- //hpos2
	
	-- Trace the blocks along the player's look vector until a hit is found:
	local Target = HPosSelect(a_Player)
	if not(Target) then
		a_Player:SendMessage(cChatColor.Rose .. "You were not looking at a block.")
		return true
	end

	-- Select the block:
	local State = GetPlayerState(a_Player)
	State.Selection:SetSecondPoint(Target.x, Target.y, Target.z)
	a_Player:SendMessageSuccess("Second position set to {" .. Target.x .. ", " .. Target.y .. ", " .. Target.z .. "}.")

	return true
end





function HandleExpandCommand(a_Split, a_Player)
	-- //expand [Amount] [Direction]
	
	-- Check the selection:
	local State = GetPlayerState(a_Player)
	if not(State.Selection:IsValid()) then
		a_Player:SendMessageFailure("No region set")
		return true
	end
	
	if (a_Split[2] ~= nil) and (tonumber(a_Split[2]) == nil) then
		a_Player:SendMessageInfo("Usage: //expand [blocks] [direction]")
		return true
	end
	
	local NumBlocks = a_Split[2] or 1 -- Use the given amount or 1 if nil
	local Direction = string.lower(a_Split[3] or ((a_Player:GetPitch() > 70) and "down") or ((a_Player:GetPitch() < -70) and "up") or "forward")
	local SubMinX, SubMinY, SubMinZ, AddMaxX, AddMaxY, AddMaxZ = 0, 0, 0, 0, 0, 0
	local LookDirection = Round((a_Player:GetYaw() + 180) / 90)
	

	if (Direction == "up") then
		AddMaxY = NumBlocks
	elseif (Direction == "down") then
		SubMinY = NumBlocks
	elseif (Direction == "left") then
		if (LookDirection == E_DIRECTION_SOUTH) then
			AddMaxX = NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			SubMinZ = NumBlocks
		elseif (LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2) then
			SubMinX = NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			AddMaxZ = NumBlocks
		end
	elseif (Direction == "right") then
		if (LookDirection == E_DIRECTION_SOUTH) then
			SubMinX = NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			AddMaxZ = NumBlocks
		elseif (LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2) then
			AddMaxX = NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			SubMinZ = NumBlocks
		end
	elseif (Direction == "south") then
		AddMaxZ = NumBlocks
	elseif (Direction == "east") then
		AddMaxX = NumBlocks
	elseif (Direction == "north") then
		SubMinZ = NumBlocks
	elseif (Direction == "west") then
		SubMinX = NumBlocks
	elseif ((Direction == "forward") or (Direction == "me")) then
		if (LookDirection == E_DIRECTION_SOUTH) then
			AddMaxZ = NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			AddMaxX = NumBlocks
		elseif ((LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2)) then
			SubMinZ = NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			SubMinX = NumBlocks
		end
	elseif ((Direction == "backwards") or (Direction == "back")) then
		if (LookDirection == E_DIRECTION_SOUTH) then
			SubMinZ = NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			SubMinX = NumBlocks
		elseif ((LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2)) then
			AddMaxZ = NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			AddMaxX = NumBlocks
		end
	else
		a_Player:SendMessageFailure("Unknown direction \"" .. Direction .. "\".")
		return true
	end
	
	State.Selection:Expand(SubMinX, SubMinY, SubMinZ, AddMaxX, AddMaxY, AddMaxZ)
	a_Player:SendMessageSuccess("Expaned the selection.")
	a_Player:SendMessageInfo("Selection is now " .. State.Selection:GetSizeDesc())
	return true
end





function HandleShiftCommand(a_Split, a_Player)
	-- //shift [Amount] [Direction]
	
	-- Check the selection:
	local State = GetPlayerState(a_Player)
	if not(State.Selection:IsValid()) then
		a_Player:SendMessage(cChatColor.Rose .. "No region set")
		return true
	end
	
	if (a_Split[2] ~= nil) and (tonumber(a_Split[2]) == nil) then
		a_Player:SendMessage(cChatColor.Rose .. "Usage: //shift [Blocks] [Direction]")
		return true
	end
	
	local NumBlocks = a_Split[2] or 1 -- Use the given amount or 1 if nil
	local Direction = string.lower(a_Split[3] or ((a_Player:GetPitch() > 70) and "down") or ((a_Player:GetPitch() < -70) and "up") or "forward")
	local X, Y, Z = 0, 0, 0
	local LookDirection = Round((a_Player:GetYaw() + 180) / 90)
	
	if (Direction == "up") then
		Y = NumBlocks
	elseif (Direction == "down") then
		Y = -NumBlocks
	elseif (Direction == "left") then
		if (LookDirection == E_DIRECTION_SOUTH) then
			X = NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			Z = -NumBlocks
		elseif (LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2) then
			X = -NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			Z = NumBlocks
		end
	elseif (Direction == "right") then
		if (LookDirection == E_DIRECTION_SOUTH) then
			X = -NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			Z = NumBlocks
		elseif (LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2) then
			X = NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			Z = -NumBlocks
		end
	elseif (Direction == "south") then
		Z = NumBlocks
	elseif (Direction == "east") then
		X = NumBlocks
	elseif (Direction == "north") then
		Z = -NumBlocks
	elseif (Direction == "west") then
		X = -NumBlocks
	elseif ((Direction == "forward") or (Direction == "me")) then
		if (LookDirection == E_DIRECTION_SOUTH) then
			Z = NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			X = NumBlocks
		elseif ((LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2)) then
			Z = -NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			X = -NumBlocks
		end
	elseif ((Direction == "backwards") or (Direction == "back")) then
		if (LookDirection == E_DIRECTION_SOUTH) then
			Z = -NumBlocks
		elseif (LookDirection == E_DIRECTION_EAST) then
			X = -NumBlocks
		elseif ((LookDirection == E_DIRECTION_NORTH1) or (LookDirection == E_DIRECTION_NORTH2)) then
			Z = NumBlocks
		elseif (LookDirection == E_DIRECTION_WEST) then
			X = NumBlocks
		end
	else
		a_Player:SendMessage(cChatColor.Rose .. "Unknown direction \"" .. Direction .. "\".")
		return true
	end
	
	State.Selection:Move(X, Y, Z)
	a_Player:SendMessage(cChatColor.LightPurple .. "Region shifted.")
	return true
end





function HandleAddLeavesCommand(a_Split, a_Player)
	-- //addleaves <LeafType>
	
	-- Parse the LeafType:
	local LeafType = a_Split[2]
	local LeafBlockType = 0
	local LeafBlockMeta = 0
	if (LeafType == "oak") then
		LeafBlockType = E_BLOCK_LEAVES
		LeafBlockMeta = 0
	elseif ((LeafType == "pine") or (LeafType == "spruce") or (LeafType == "conifer")) then
		LeafBlockType = E_BLOCK_LEAVES
		LeafBlockMeta = 1
	elseif (LeafType == "birch") then
		LeafBlockType = E_BLOCK_LEAVES
		LeafBlockMeta = 2
	elseif (LeafType == "jungle") then
		LeafBlockType = E_BLOCK_LEAVES
		LeafBlockMeta = 3
	elseif (LeafType == "acacia") then
		LeafBlockType = E_BLOCK_NEW_LEAVES
		LeafBlockMeta = 0
	elseif ((LeafType == "darkoak") or (LeafType == "dark")) then
		LeafBlockType = E_BLOCK_NEW_LEAVES
		LeafBlockMeta = 1
	else
		a_Player:SendMessage(cChatColor.Rose .. "Unknown leaf type: " .. (LeafType or "<no argument>").. ".")
		return true
	end

	-- Check the selection:
	local State = GetPlayerState(a_Player)
	if not(State.Selection:IsValid()) then
		a_Player:SendMessage(cChatColor.Rose .. "No region set")
		return true
	end
	
	-- Check with other plugins if the operation is okay:
	local SrcCuboid = State.Selection:GetSortedCuboid()
	local World = a_Player:GetWorld()
	if not(CheckAreaCallbacks(SrcCuboid, a_Player, World, "copy")) then
		return
	end
	
	-- Push an undo snapshot:
	State.UndoStack:PushUndoFromCuboid(World, SrcCuboid, "addleaves")
	
	-- Read the selected cuboid into a cBlockArea:
	local BA = cBlockArea()
	BA:Read(World, SrcCuboid)
	local MaxX, MaxY, MaxZ = BA:GetSize()
	MaxX = MaxX - 1
	MaxY = MaxY - 1
	MaxZ = MaxZ - 1
	
	-- Create an image for the leaves to be added at each log:
	--[[
	The image is like this:
	level 0 and 1:
	.xxx.
	xxxxx
	xxxxx
	xxxxx
	.xxx.
	
	level 2:
	.....
	..x..
	.xxx.
	..x..
	.....
	--]]
	local LeavesImg = cBlockArea()
	LeavesImg:Create(5, 3, 5)
	LeavesImg:FillRelCuboid(0, 4, 0, 1, 0, 4, cBlockArea.baTypes + cBlockArea.baMetas, LeafBlockType, LeafBlockMeta)
	LeavesImg:SetRelBlockType(0, 0, 0, 0)
	LeavesImg:SetRelBlockType(4, 0, 0, 0)
	LeavesImg:SetRelBlockType(0, 0, 4, 0)
	LeavesImg:SetRelBlockType(4, 0, 4, 0)
	LeavesImg:SetRelBlockType(0, 1, 0, 0)
	LeavesImg:SetRelBlockType(4, 1, 0, 0)
	LeavesImg:SetRelBlockType(0, 1, 4, 0)
	LeavesImg:SetRelBlockType(4, 1, 4, 0)
	LeavesImg:SetRelBlockTypeMeta(1, 2, 2, LeafBlockType, LeafBlockMeta)
	LeavesImg:SetRelBlockTypeMeta(2, 2, 1, LeafBlockType, LeafBlockMeta)
	LeavesImg:SetRelBlockTypeMeta(3, 2, 2, LeafBlockType, LeafBlockMeta)
	LeavesImg:SetRelBlockTypeMeta(2, 2, 3, LeafBlockType, LeafBlockMeta)
	LeavesImg:SetRelBlockTypeMeta(2, 2, 2, LeafBlockType, LeafBlockMeta)
	
	-- Process the block area - add leaves next to all log blocks:
	local LogBlock = E_BLOCK_LOG
	local NewLogBlock = E_BLOCK_NEW_LOG
	for y = 0, MaxY do
		for z = 0, MaxZ do
			for x = 0, MaxX do
				local BlockType = BA:GetRelBlockType(x, y, z)
				if ((BlockType == LogBlock) or (BlockType == NewLogBlock)) then
					BA:Merge(LeavesImg, x - 2, y, z - 2, cBlockArea.msFillAir)
				end
			end
		end
	end
	
	-- Write the block area back to world:
	BA:Write(World, BA:GetOrigin())
	return true
end




