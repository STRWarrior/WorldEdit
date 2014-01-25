
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "WorldEdit",
	Version = "0.1",
	Date = "2013-12-29",
	Description = [[This plugin allows you to easily manage the world, edit the world, navigate around or get information. It bears similarity to the Bukkit's WorldEdit plugin and aims to have the same set of commands,however, it has no affiliation to that plugin.
	]],
	Commands =
	{
---------------------------------------------------------------------------------------------------
-- double-slash commands:

		["//"] =
		{
			Alias = "/",
			Permission = "worldedit.superpickaxe",
			Handler = HandleSuperPickCommand,
			HelpString = " Toggle the super pickaxe pickaxe function",
			Category = "Tool",
		},
		
		["//copy"] =
		{
			Permission = "worldedit.clipboard.copy",
			Handler = HandleCopyCommand,
			HelpString = " Copy the selection to the clipboard",
			Category = "Clipboard",
		},
		
		["//cut"] =
		{
			Permission = "worldedit.clipboard.cut",
			Handler = HandleCutCommand,
			HelpString = " Cut the selection to the clipboard",
			Category = "Clipboard",
		},
		
		["//drain"] =
		{
			Permission = "worldedit.drain",
			Handler = HandleDrainCommand,
			HelpString = " Drains all water around you in the given radius.",
			Category = "Terraforming",
		},
		
		["//extinguish"] =
		{
			Alias = { "//ex", "//ext", "/ex", "/ext", "/extinguish", },
			Permission = "worldedit.extinguish",
			Handler = HandleExtinguishCommand,
			HelpString = " Removes all the fires around you in the given radius.",
			Category = "Terraforming",
		},
		
		["//faces"] =
		{
			Permission = "worldedit.region.faces",
			Handler = HandleFacesCommand,
			HelpString = " Build the walls, ceiling, and floor of a selection",
			Category = "Region",
		},
		
		["//green"] =
		{
			Permission = "worldedit.green",
			Handler = HandleGreenCommand,
			HelpString = " Changes all the dirt to grass.",
			Category = "Terraforming",
		},
		
		["//paste"] =
		{
			Permission = "worldedit.clipboard.paste",
			Handler = HandlePasteCommand,
			HelpString = " Pastes the clipboard's contents",
			Category = "Clipboard",
		},
		
		["//pos1"] =
		{
			Permission = "worldedit.selection.pos",
			Handler = HandlePos1Command,
			HelpString = " Set position 1",
			Category = "Selection",
		},
		
		["//pos2"] =
		{
			Permission = "worldedit.selection.pos",
			Handler = HandlePos2Command,
			HelpString = " Set position 2",
			Category = "Selection",
		},
		
		["//redo"] =
		{
			Permission = "worldedit.history.redo",
			Handler = HandleRedoCommand,
			HelpString = " redoes the last action (from history)",
			Category = "History",
		},
		
		["//replace"] =
		{
			Permission = "worldedit.region.replace",
			Handler = HandleReplaceCommand,
			HelpString = " Replace all the blocks in the selection with another",
			Category = "Region",
		},
		
		["//rotate"] =
		{
			Permission = "worldedit.clipboard.rotate",
			Handler = HandleRotateCommand,
			HelpString = " Rotates the contents of the clipboard",
			Category = "Clipboard",
		},
		
		["//schematic"] =
		{
			Permission = "",  -- Multi-commands shouldn't specify a permission
			Handler = nil,  -- Provide a standard multi-command handler
			HelpString = "",  -- Don't show in help
			Category = "Clipboard",
			Subcommands =
			{
				save =
				{
					HelpString = "Saves the current clipboard to a file with the given filename.",
					Permission = "",
					Handler = HandleSchematicSaveCommand,
				},
				s =
				{
					HelpString = "Saves the current clipboard to a file with the given filename.",
					Permission = "",
					Handler = HandleSchematicSaveCommand,
				},
				load =
				{
					HelpString = "Loads the given schematic file.",
					Permission = "",
					Handler = HandleSchematicLoadCommand,
				},
				l =
				{
					HelpString = "Loads the given schematic file.",
					Permission = "",
					Handler = HandleSchematicLoadCommand,
				},
				formats =
				{
					HelpString = "List available schematic formats",
					Permission = "",
					Handler = HandleSchematicFormatsCommand,
				},
				listformats =
				{
					HelpString = "List available schematic formats",
					Permission = "",
					Handler = HandleSchematicFormatsCommand,
				},
				f =
				{
					HelpString = "List available schematic formats",
					Permission = "",
					Handler = HandleSchematicFormatsCommand,
				},
				list =
				{
					HelpString = "List available schematics",
					Permission = "",
					Handler = HandleSchematicListCommand,
				},
				all =
				{
					HelpString = "List available schematics",
					Permission = "",
					Handler = HandleSchematicListCommand,
				},
				ls =
				{
					HelpString = "List available schematics",
					Permission = "",
					Handler = HandleSchematicListCommand,
				},
			},
		},
		
		["//set"] =
		{
			Permission = "worldedit.region.set",
			Handler = HandleSetCommand,
			HelpString = " Set all the blocks inside the selection to a block",
			Category = "Region",
		},
		
		["//setbiome"] =
		{
			Permission = "worldedit.biome.set",
			Handler = HandleSetBiomeCommand,
			HelpString = " Set the biome of the region.",
			Category = "Biome",
		},
		
		["//size"] =
		{
			Permission = "worldedit.selection.size",
			Handler = HandleSizeCommand,
			HelpString = " Get the size of the selection",
			Category = "Selection",
		},
		
		["//undo"] =
		{
			Permission = "worldedit.history.undo",
			Handler = HandleUndoCommand,
			HelpString = " Undoes the last action",
			Category = "History",
		},
		
		["//walls"] =
		{
			Permission = "worldedit.region.walls",
			Handler = HandleWallsCommand,
			HelpString = " Build the four sides of the selection",
			Category = "Region",
		},
		
		["//wand"] =
		{
			Permission = "worldedit.wand",
			Handler = HandleWandCommand,
			HelpString = " Get the wand object",
			Category = "Special",
		},
		
---------------------------------------------------------------------------------------------------
-- Single-slash commands:

		["/ascend"] =
		{
			Alias = "/asc",
			Permission = "worldedit.navigation.ascend", 
			Handler = HandleAscendCommand, 
			HelpString = " go down a floor",
			Category = "Navigation",
		},
		
		["/biomeinfo"] =
		{
			Permission = "worldedit.biome.info",
			Handler = HandleBiomeInfoCommand,
			HelpString = " Get the biome of the targeted block(s).",
			Category = "Biome",
		},
		
		["/biomelist"] =
		{
			Permission = "worldedit.biomelist",
			Handler = HandleBiomeListCommand,
			HelpString = " Gets all biomes available",
			Category = "Biome",
		},
		
		["/butcher"] =
		{
			Permission = "worldedit.butcher",
			Handler = HandleButcherCommand,
			HelpString = " Kills nearby mobs based on the given radius, if no radius is given it uses the default in configuration.",
			Category = "Entities",
		},
		
		["/descend"] = 
		{
			Alias = "/desc",
			Permission = "worldedit.navigation.descend",
			Handler = HandleDescendCommand, 
			HelpString = "go down a floor",
			Category = "Navigation",
		},
		
		["/jumpto"] =
		{
			Permission = "worldedit.navigation.jumpto.command",
			Handler = HandleJumpToCommand,
			HelpString = " Teleport to a location",
			Category = "Navigation",
		},
		
		["/none"] =
		{
			Handler = HandleNoneCommand,
			HelpString = " Unbind a bound tool from your current item",
			Category = "Tool",
		},
		
		["/pumpkins"] =
		{
			Permission = "worldedit.generation.pumpkins",
			Handler = HandlePumpkinsCommand,
			HelpString = " Generates pumpkins at the surface.",
			Category = "Terraforming",
		},	
		
		["/remove"] =
		{
			Alias = { "/rem", "/rement", },
			Permission = "worldedit.remove",
			Handler = HandleRemoveCommand,
			HelpString = " Removes all entities of a type",
			Category = "Entities",
		},
		
		["/removeabove"] =
		{
			Alias = "//removeabove",
			Permission = "worldedit.removeabove",
			Handler = HandleRemoveAboveCommand,
			HelpString = " Remove all the blocks above you.",
			Category = "Terraforming",
		},
		
		["/removebelow"] =
		{
			Alias = "//removebelow",
			Permission = "worldedit.removebelow",
			Handler = HandleRemoveBelowCommand,
			HelpString = " Remove all the blocks below you.",
			Category = "Terraforming",
		},
		
		["/repl"] =
		{
			Permission = "worldedit.tool.replacer",
			Handler = HandleReplCommand,
			HelpString = " Block replace tool",
			Category = "Tool",
		},
		
		["/snow"] =
		{
			Command = "/snow",
			Permission = "worldedit.snow",
			Handler = HandleSnowCommand,
			HelpString = " Makes it look like it has snown.",
			Category = "Terraforming",
		},
		
		["/thaw"] =
		{
			Permission = "worldedit.thaw",
			Handler = HandleThawCommand,
			HelpString = " Removes all the snow around you in the given radius.",
			Category = "Terraforming",
		},
		
		["/thru"] =
		{
			Permission = "worldedit.navigation.thru.command",
			Handler = HandleThruCommand,
			HelpString = " Passthrough walls",
			Category = "Navigation",
		},
		
		["/toggleeditwand"] =
		{
			Permission = "worldedit.wand.toggle",
			Handler = HandleToggleEditWandCommand,
			HelpString = " Toggle functionality of the edit wand",
			Category = "Special",
		},
		
		["/tree"] =
		{
			Permission = "worldedit.tool.tree",
			Handler = HandleTreeCommand,
			HelpString = " Tree generator tool",
			Category = "Tool",
		},
		
		["/up"] =
		{
			Permission = "worldedit.navigation.up",
			Handler = HandleUpCommand,
			HelpString = " go upwards some distance",
			Category = "Navigation",
		},
		
		["/we"] =
		{
			Permission = "",
			Handler = nil,
			HelpString = " World edit command",
			Category = "Special",
			Subcommands =
			{
				version =
				{
					HelpString = "Sends the plugin version to the player.",
					Permission = "",
					Handler = HandleWorldEditVersionCommand,
				},
				reload =
				{
					HelpString = "Reloads the WorldEdit plugin.",
					Permission = "",
					Handler = HandleWorldEditReloadCommand,
				},
				help =
				{
					HelpString = "Sends all the available commands to the player.",
					Permission = "",
					Handler = HandleWorldEditHelpCommand,
				},
			},
		},
		
	},  -- Commands
	
	Categories =
	{
		Navigation =
		{
			Description = "Commands that helps the player moving to locations.",
		},
		Clipboard =
		{
			Description = "All the commands that have anything todo with a players clipboard.",
		},
		Tool =
		{
			Description = "Commands that activate a tool. If a tool is activated you can use it by right or left clicking with your mouse.",
		},
		Region =
		{
			Description = "Commands in this category will allow the player to edit the region he/she has selected using //pos[1/2] or using the wand item.",
		},
		Selection =
		{
			Description = "Commands that give info/help setting the region you have selected.",
		},
		History =
		{
			Description = "Commands that can undo/redo past WorldEdit actions.",
		},
		Terraforming =
		{
			Description = "Commands that help you Modifying the terrain.",
		},
		Biome =
		{
			Description = "Any biome specific commands.",
		},
		Special =
		{
			Description = "Commands that don't realy fit in another category.",
		},
	},
	
	AdditionalInfo =
	{
		{
			Header = "API",
			Contents = [[
			]],
		},
		{
			Header = "Config",
			Contents = [[
			]],
		}
	},  -- AdditionalInfo
}




