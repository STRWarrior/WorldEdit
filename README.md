This plugin allows you to easily manage the world, edit the world, navigate around or get information. It bears similarity to the Bukkit's WorldEdit plugin and aims to have the same set of commands,however, it has no affiliation to that plugin. 	

# Commands

### General
| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//schematic formats | worldedit.schematic.list | List available schematic formats| 
|//schematic list | worldedit.schematic.list | List available schematics| 
|//schematic load | worldedit.schematic.load | Loads the given schematic file.| 
|//schematic save | worldedit.schematic.save | Saves the current clipboard to a file with the given filename.| 
|/we help |  | Sends all the available commands to the player.| 
|/we reload |  | Reloads the WorldEdit plugin.| 
|/we version |  | Sends the plugin version to the player.| 



### Biome
Any biome specific commands.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//setbiome | worldedit.biome.set |  Set the biome of the region.| 
|/biomeinfo | worldedit.biome.info |  Get the biome of the targeted block(s).| 
|/biomelist | worldedit.biomelist |  Gets all biomes available| 



### Clipboard
All the commands that have anything todo with a players clipboard.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//copy | worldedit.clipboard.copy |  Copy the selection to the clipboard| 
|//cut | worldedit.clipboard.cut |  Cut the selection to the clipboard| 
|//expand | worldedit.selection.expand |  Expand the selection area| 
|//paste | worldedit.clipboard.paste |  Pastes the clipboard's contents| 
|//rotate | worldedit.clipboard.rotate |  Rotates the contents of the clipboard| 



### Entities
| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|/butcher | worldedit.butcher |  Kills nearby mobs based on the given radius, if no radius is given it uses the default in configuration.| 
|/remove | worldedit.remove |  Removes all entities of a type| 



### Generation
Commands that generates structures.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//hsphere | worldedit.generation.hsphere |  Generates a hollow sphere.| 
|//sphere | worldedit.generation.sphere |  Generates a filled sphere.| 



### History
Commands that can undo/redo past WorldEdit actions.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//redo | worldedit.history.redo |  redoes the last action (from history)| 
|//undo | worldedit.history.undo |  Undoes the last action| 



### Navigation
Commands that helps the player moving to locations.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|/ascend | worldedit.navigation.ascend |  go down a floor| 
|/descend | worldedit.navigation.descend | go down a floor| 
|/jumpto | worldedit.navigation.jumpto.command |  Teleport to a location| 
|/thru | worldedit.navigation.thru.command |  Passthrough walls| 
|/up | worldedit.navigation.up |  go upwards some distance| 



### Region
Commands in this category will allow the player to edit the region he/she has selected using //pos[1/2] or using the wand item.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//faces | worldedit.region.faces |  Build the walls, ceiling, and floor of a selection| 
|//replace | worldedit.region.replace |  Replace all the blocks in the selection with another| 
|//set | worldedit.region.set |  Set all the blocks inside the selection to a block| 
|//walls | worldedit.region.walls |  Build the four sides of the selection| 



### Selection
Commands that give info/help setting the region you have selected.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//hpos1 | worldedit.selection.pos |  Set position 1 to the position you are looking at.| 
|//hpos2 | worldedit.selection.pos |  Set position 2 to the position you are looking at.| 
|//pos1 | worldedit.selection.pos |  Set position 1| 
|//pos2 | worldedit.selection.pos |  Set position 2| 
|//shift | worldedit.selection.size |  Move the selection area| 
|//size | worldedit.selection.size |  Get the size of the selection| 



### Special
Commands that don't realy fit in another category.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//wand | worldedit.wand |  Get the wand object| 
|/toggleeditwand | worldedit.wand.toggle |  Toggle functionality of the edit wand| 
|/we |  |  World edit command| 



### Terraforming
Commands that help you Modifying the terrain.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|//drain | worldedit.drain |  Drains all water around you in the given radius.| 
|//extinguish | worldedit.extinguish |  Removes all the fires around you in the given radius.| 
|//green | worldedit.green |  Changes all the dirt to grass.| 
|/pumpkins | worldedit.generation.pumpkins |  Generates pumpkins at the surface.| 
|/removeabove | worldedit.removeabove |  Remove all the blocks above you.| 
|/removebelow | worldedit.removebelow |  Remove all the blocks below you.| 
|/snow | worldedit.snow |  Makes it look like it has snown.| 
|/thaw | worldedit.thaw |  Removes all the snow around you in the given radius.| 



### Tool
Commands that activate a tool. If a tool is activated you can use it by right or left clicking with your mouse.

| Command | Permission | Description | 
| ------- | ---------- | ----------- | 
|// | worldedit.superpickaxe |  Toggle the super pickaxe pickaxe function| 
|/none |  |  Unbind a bound tool from your current item| 
|/repl | worldedit.tool.replacer |  Block replace tool| 
|/tree | worldedit.tool.tree |  Tree generator tool| 



# Permissions
| Permissions | Description | Commands | Recommended groups |
| ----------- | ----------- | -------- | ------------------ |
worldedit.biome.info |  | `/biomeinfo` | 
worldedit.biome.set |  | `//setbiome` | 
worldedit.biomelist |  | `/biomelist` | 
worldedit.butcher |  | `/butcher` | 
worldedit.clipboard.copy |  | `//copy` | 
worldedit.clipboard.cut |  | `//cut` | 
worldedit.clipboard.paste |  | `//paste` | 
worldedit.clipboard.rotate |  | `//rotate` | 
worldedit.drain |  | `//drain` | 
worldedit.extinguish |  | `//extinguish` | 
worldedit.generation.hsphere |  | `//hsphere` | 
worldedit.generation.pumpkins |  | `/pumpkins` | 
worldedit.generation.sphere |  | `//sphere` | 
worldedit.green |  | `//green` | 
worldedit.history.redo |  | `//redo` | 
worldedit.history.undo |  | `//undo` | 
worldedit.navigation.ascend |  | `/ascend` | 
worldedit.navigation.descend |  | `/descend` | 
worldedit.navigation.jumpto.command |  | `/jumpto` | 
worldedit.navigation.thru.command |  | `/thru` | 
worldedit.navigation.up |  | `/up` | 
worldedit.region.faces |  | `//faces` | 
worldedit.region.replace |  | `//replace` | 
worldedit.region.set |  | `//set` | 
worldedit.region.walls |  | `//walls` | 
worldedit.remove |  | `/remove` | 
worldedit.removeabove |  | `/removeabove` | 
worldedit.removebelow |  | `/removebelow` | 
worldedit.schematic.list |  | `//schematic formats`, `//schematic list` | 
worldedit.schematic.load |  | `//schematic load` | 
worldedit.schematic.save |  | `//schematic save` | 
worldedit.selection.expand |  | `//expand` | 
worldedit.selection.pos |  | `//hpos2`, `//hpos1`, `//pos2`, `//pos1` | 
worldedit.selection.size |  | `//size`, `//shift` | 
worldedit.snow |  | `/snow` | 
worldedit.superpickaxe |  | `//` | 
worldedit.thaw |  | `/thaw` | 
worldedit.tool.replacer |  | `/repl` | 
worldedit.tool.tree |  | `/tree` | 
worldedit.wand |  | `//wand` | 
worldedit.wand.toggle |  | `/toggleeditwand` | 
