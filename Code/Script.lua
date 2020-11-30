-- Skip "Tunnels", it make no sense to capture it.
-- LayoutConstruction.lua - did not support "passage_grid", "TubeSwitch" and "CableSwitch"!!!
	-- local supported_grid_contstruction_modes = {
	--		electricity_grid = true,
	--		life_support_grid = true
	-- }

-- On "Reload Lua" game not re-read mod's "metadata.lua", so when we add here path to new layout, it will
	-- not load it. Only on "restart" game will read updated "metadata.lua".
	-- So concatenate all layout files in one "Layout.lua" file, never change "metadata.lua".
	-- "ChoGGi.ComFuncs.UpdateBuildMenu()" to update menus on the fly (if we add layout on runtime
	-- via "PlaceObj(...)"), but we "Reload Lua" instead.

---- LUA STUFF ----

-- GlobalVar("tmp", {"param1","param2",}) <- this line will not create object, but boolean == false :(
-- GlobalVar("tmp", {}) tmp = {[1] = "param1", [2] = "param2",} <- create empty object, add params

-- pairs() returns key-value pairs and is mostly used for associative tables. key order is unspecified.
-- ipairs() returns index-value pairs and is mostly used for numeric tables. Non numeric keys in an array
	-- are ignored, while the index order is deterministic (in numeric order).

-- Order of function definition is essential. Must define before first usage.
	-- Search "Lua Function Forward Declaration".

-- Official documentation LuaFunctionDoc_AsyncIO.md.html for all "Async*()" functions in this script.

-- Boolean value must be tostring()-ed for concatenation.

-- Operator precedence in Lua follows the table below, from the higher to the lower priority:
	-- ^
	-- not  - (unary)
	-- *   /
	-- +   -
	-- ..
	-- <   >   <=  >=  ~=  ==
	-- and
	-- or




local modName = "Layout Mod"

---- DEBUG ----

-- Open in Notepad++, and hit [Ctrl-Q] to toggle comment
local DEBUG = true
-- local DEBUG_EXAMINE = true
-- local DEBUG_LUA = true

-- Print to "Layout Mod" log file
function printL(str)
	-- -1 - append to file
	AsyncStringToFile(CurrentModPath .. "layout_log.txt", str .. "\n", -1)
end

function printD(str)
	if DEBUG then
		printL(str)
		print("[LM] " .. str)
	end
end

local GlobalError = false

function printDMsgOrErr(err, sucess, fail)
	if err then
		GlobalError = true
		printD(fail)
		printD(err)
	else
		if sucess then
			printD(sucess)
		end
	end
end

function MsgPopup(str)
	-- Maximum 2 lines of text
	-- ChoGGi.ComFuncs.MsgPopup(text, title, params)
	-- params = {
		-- expiration = integer, -- how long to show in seconds (default 10)
		-- size = boolean, -- "false" - long text will wrap, "true" - show long text in one line (set default "expiration" to 25)
		-- image = string, -- icon file name
		-- objects = obj or {}, -- click icon to view obj
		-- callback = function,
		-- max_width = integer, -- (default 1000)
	-- }
	printD(str)
	ChoGGi.ComFuncs.MsgPopup(str, modName, {size = true})
end

-- ### Changed:
-- - Debug>Reload LUA (changed how it reloads, so now it works without messing up ECM).
-- Wait for new release with latest commits.
-- TODO ChoGGi will add this function to Expanded Cheat Menu, stay tuned
-- ECM/Lib must be enabled before all others mod
function ChoGGi_ReloadLua()
    if not ModsLoaded then
        return
    end
    -- get list of enabled mods
    local enabled = table.icopy(ModsLoaded)
    -- turn off all mods
    AllModsOff()
    -- re-enable ecm/lib
    TurnModOn(ChoGGi.id)     -- Expanded Cheat Menu
    TurnModOn(ChoGGi.id_lib) -- Library
    -- reload lua code
    ModsReloadItems()
    -- enable disabled mods
    for i = 1, #enabled do
        TurnModOn(enabled[i].id)
    end
    -- reload lua code
    ModsReloadItems()
end

-- ReloadLua() is in-game function name, don't use it!!!
function Fixer_ReloadLua()
	cls()
	-- Remove all layouts from game before reload lua, so we can manually edit layout in text editor and see result after reload
	local bt = BuildingTemplates
	for i, id in ipairs(GetIdList()) do
		bt[id] = nil
	end
	CreateRealTimeThread(function()
		MsgPopup("----BEGIN-RELOAD-LUA----")
		Sleep(1000)
		ChoGGi_ReloadLua()
		MsgPopup("----DONE-RELOAD-LUA----")
	end)
end

function GetDate()
	return "--------" .. os.date("%Y/%m/%d-%H:%M:%S") .. "--------"
end




---- SHORTCUTS ----

local key = "Insert"
local ShortcutCapture              = "" .. key
local ShortcutCaptureWithoutDome   = "Ctrl-" .. key
local ShortcutSetParams            = "Alt-" .. key
local ShortcutShowInfo             = "Shift-" .. key
local ShortcutReloadLua            = "Ctrl-Shift-" .. key
local ShortcutPhotoMode            = "Ctrl-Alt-Shift-" .. key

-- After this message ChoGGi's object is ready to use
function CreateShortcuts()
	printD(GetDate())
	printD("CreateShortcuts()")
	local Actions = ChoGGi.Temp.Actions
	
	-- ActionName = 'Display Name In "Key Bindings" Menu' ("Surviving Mars" -> "Options" -> "Key Bindings")
	-- OnAction = FuncName (for example "cls": clear log)
	Actions[#Actions + 1] = {
		ActionName = "Layout Capture",
		ActionId = "Layout.Capture",
		OnAction = LayoutCaptureAll,
		ActionShortcut = ShortcutCapture,
		ActionBindable = true,
	}

	Actions[#Actions + 1] = {
		ActionName = "Layout Capture without Dome",
		ActionId = "Layout.Capture.without.Dome",
		OnAction = LayoutCaptureWithoutDome,
		ActionShortcut = ShortcutCaptureWithoutDome,
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {
		ActionName = "Layout Set Params",
		ActionId = "Layout.Set.Params",
		OnAction = LayoutSetParams,
		ActionShortcut = ShortcutSetParams,
		ActionBindable = true,
	}

	Actions[#Actions + 1] = {
		ActionName = "Layout Show Info",
		ActionId = "Layout.Show.Info",
		OnAction = LayoutShowInfo,
		ActionShortcut = ShortcutShowInfo,
		ActionBindable = true,
	}

	Actions[#Actions + 1] = {
		ActionName = "Layout Reload Lua",
		ActionId = "Layout.Reload.Lua",
		OnAction = Fixer_ReloadLua,
		ActionShortcut = ShortcutReloadLua,
		ActionBindable = true,
	}

	Actions[#Actions + 1] = {
		ActionName = "Layout Set Green Terrain",
		ActionId = "Layout.Set.Green.Terrain",
		OnAction = PhotoMode,
		ActionShortcut = ShortcutPhotoMode,
		ActionBindable = true,
	}
end




---- MENUS ----

-- In-game table with root menus, which appears on pressing [B]:
-- Enhanced Cheat Menu -> Console -> ~BuildCategories

-- In-game table with menu subcategories (example is [Depot] in [Storages]):
-- Enhanced Cheat Menu -> Console -> ~BuildMenuSubcategories

-- Empty menu is not visible. Add building, and menu will appear.

-- Path to menu icon
local menuIcon = "UI/MenuIcon.png"
-- Display name of each menu
local displayName = "Layout"
-- Add this prefix to id of original menu to create id for my menus: "Layout Infrastructure"
local idPrefix = "Layout "
-- Add suffix to id of original menu to create description for my menus: "Infrastructure Layouts"
local descrSuffix = " Layouts"
-- Table with id of original menus. Surviving Mars have 14 menus. Look in ~BuildCategories table
local origMenuId = {
	[1]  = "Infrastructure",
	[2]  = "Power",
	[3]  = "Production",
	[4]  = "Life-Support",
	[5]  = "Storages",
	[6]  = "Domes",
	[7]  = "Habitats",
	[8]  = "Dome Services",
	[9]  = "Dome Spires",
	[10] = "Decorations",
	[11] = "Outside Decorations",
	[12] = "Wonders",
	[13] = "Landscaping",
	[14] = "Terraforming",
	[15] = "Default", -- add my param on last position, we will use it to create id for my submenu in root menu
}
-- Table with id for my menus
local menuId = {}

function CreateMenus()
	-- Create id for my submenus
	for i, id in ipairs(origMenuId) do
		menuId[i] = idPrefix .. id
	end
	
	-- Create root menu
	local bc = BuildCategories
	local id = menuId[#menuId] -- #var - get size of table "var"
	-- This line was in example, but it not work. Even if "id" is present, "table.find" return "not true" value :(
	-- if not table.find(bc, "id", id) then
	if not bc[id] then
		-- In source code developers don't use PlaceObj(...), so we too
		bc[#bc + 1] = {
			id = id,
			name = displayName,
			image = CurrentModPath .. menuIcon,
			-- “on hover” effects; this should probably always be "UI/Icons/bmc_infrastructure_shine.tga" to have the default “on hover” effect
			-- Not needed? Works well without them
			-- highlight = "UI/Icons/bmc_infrastructure_shine.tga",
			-- highlight = "UI/Icons/bmc_dome_buildings_shine.tga",
			-- highlight = "UI/Icons/Buildings/dinner_shine.tga",
			-- highlight or highlight_img param? From different sources, not sure.
		}
		printD("Menu created: " .. id)
	else
		printD("Menu exist: " .. id)
	end
	
	-- Create submenu in each original menu
	local bmc = BuildMenuSubcategories
	for i, id in ipairs(menuId) do
		-- This line was in example, but it not work. Even if "id" is present, "table.find" return "not true" value :(
		-- if not table.find(bmc, "id", id) then
		if not bmc[id] then
			bmc[id] = PlaceObj('BuildMenuSubcategory', {
				id = id,
				build_pos = 0,
				-- The main category inside which the subcategory will appear
				category = origMenuId[i],
				-- Unknown, will set equal to id
				category_name = id,
				display_name = displayName,
				description = origMenuId[i] .. descrSuffix,
				icon = CurrentModPath .. menuIcon,
				-- Unknown
				group = "Default",
				-- If the player can switch between the buildings of this subcategory
				-- using the “cycle visual variant” buttons (by default [ and ]).
				-- This is useful in cases like the “Depots” and “Storage” subcategory.
				-- It is far simpler to use the “cycle visual variant” keys, instead of
				-- going through the build menu, when placing multiple depots for different resources.
				-- By default it's true.
				-- allow_template_variants = true,
				-- action = function(self, context, button)
					-- print("You Selected Subcategory")
				-- end,
			})
			printD("Menu created: " .. id)
		else
			printD("Menu exist: " .. id)
		end
	end
end




---- MAIN CODE ----

local buildings, cables, tubes

local layoutFilePath, layoutFileNameNoPath, layoutFileName, metadataFileName, layoutsFileName, menuIconFileName, layoutIconFileName

local default_build_category = #origMenuId
local default_build_pos = 0
local default_radius = 400

local layoutSettings = {
	build_category = default_build_category,
	build_pos = default_build_pos,
	description = "Layout Description",
	display_name = "Display Name",
	id = "SetIdForLayoutFile",
	radius = default_radius,
}

-- Forward declaration with this function not work.
-- If make forward declaration and place function's body below "local GUIDE", "local GUIDE" will call nil "TableToString" variable
function TableToString(inputTable)
	local str = ""
	for i, v in ipairs(inputTable) do
		if i < 10 then
			-- Shift line with one digit [1-9] to right
			str = str .. "   "
		end
		str = str .. i .. "\t== " .. v .. "\n"
	end
	return str
end

local GUIDE = '\n' .. [[
ChoGGi's Mods: https://github.com/ChoGGi/SurvivingMars_CheatMods/
[REQUIRED] ChoGGi's "Startup HelperMod" to bypass blacklist (we need access to AsyncIO functions to create lua files).
	Install required mod, then copy "AppData\BinAssets" from "]] .. modName .. [[" folder to "%AppData%\Surviving Mars\BinAssets".
[Optional] ChoGGi's "Enhanced Cheat Menu" [F2] -> "Cheats" -> "Toggle Unlock All Buildings" -> Double click "Unlock"
[Optional] ChoGGi's "Fix Layout Construction Tech Lock" mod if you want build buildings, that is locked by tech.
BUILD:
	Place your buildings (recommend on empty map OR tune capture "radius" to capture only needed buildings).
	"Passage", "Pipe Valve", "Power Switch" not supported. "Tunnel" supported, but mod skips them.
	Mod will skip "dome_required" buildings if you capture all buildings, game will not allow to build such layout.
	Press [Alt-B] to complete constructions.
SET PARAMS:
	Place your mouse cursor in the center of building's layout.
	Press [Ctrl-M] and measure radius of building's layout.
	Press []] .. ShortcutSetParams .. ']\n' .. [[
	Two windows will appear: "Choose Building Menu", "Edit Object".
	Choose building menu by double click, or ignore it (previous selected menu category will be used). Note: "building_category"
		value will not be updated after double click, but will be saved anyway!
	Set parameters in "Edit Object" window:
		"build_category" (allowed number from 1 to ]] .. #origMenuId .. [[) in which menu captured layout will be placed.
		"build_pos" (number from 0 to 99, can be duplicated) position in build menu.
		"description", "display_name" - as you like.
		"id" (must be unique, allowed "CamelCase" or "snake_case" notation [NO space character]) internal script parameter,
			additionally will be used as part of file name of layout's lua script and as file name for layout's icon.
		"radius" ("nil" or positive number [to infinity and beyond]) capture radius in meters.
	Press []] .. ShortcutSetParams .. [[] again to close all dialog windows.
CAPTURE:
	Press []] .. ShortcutCapture .. [[] to capture all.
	Press []] .. ShortcutCaptureWithoutDome .. [[] to capture buildings inside "Dome" without "Dome".
APPLY:
	To take changes in effect restart game (reliable). Press [Ctrl-Alt-R] then [Enter].
	Or reload lua (not reliable). Press []] .. ShortcutReloadLua .. [[].
PHOTO MODE [Optional]:
	To reset changes made below, load savegame.
	Press []] .. ShortcutPhotoMode .. [[], it will change terrain texture to green, brighter light, set game on pause.
	Press [Ctrl-Alt-I] to hide UI, [Ctrl-Alt-U] to toggle signs.
	Make screenshot [PrintScreen]. It will be saved in "%AppData%\Surviving Mars"
	Make some fancy icon and replace the one, located in "]] .. CurrentModPath .. 'UI/%id%.png"\n' .. [[
	Icon template: "Surviving Mars\ModTools\Samples\Mods\User Interface Elements\UI\Buildings Icons.png"
I WANT DELETE LAYOUT:
	Delete layout file in "]] .. CurrentModPath .. "Code/Layout" .. [[" folder, then capture layout on empty space.
	In dialog window choose "Yes" to update "Layouts.lua". Look [APPLY] above.

"build_category" (allowed value is number from 1 to ]] .. #origMenuId .. [[):]] .. '\n' .. TableToString(origMenuId)

-- Get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- ChoGGi.ComFuncs.OpenInExamineDlg(ReturnAllNearby(1000, "class")) from ChoGGi's Library v8.7
-- Removed "pt" parameter. "radius" in meters. Added parameter "class": only get objects inherited from "class", provided by this parameter
function ReturnAllNearby(radius, sort, class)
	-- local is faster then global
	local table_sort = table.sort

	-- "radius" = meters * 100
	radius = radius or 50

	-- get objects inherited from "class" within radius
	local list = MapGet(GetTerrainCursor(), radius * 100, class)

	-- sort list custom
	if sort then
		table_sort(list, function(a, b)
			return a[sort] < b[sort]
		end)
	else
		-- sort nearest
		table_sort(list, function(a, b)
			return a:GetVisualDist(pt) < b:GetVisualDist(pt)
		end)
	end

	return list
end

-- Return table with objects, that match "entity" parameter
function GetObjsByEntity(inputTable, entity)
	local string_find = string.find
	local table_insert = table.insert
	local resultTable = {}
	for i, v in ipairs(inputTable) do
		if string_find(inputTable[i]:GetEntity(), entity) then
			table_insert(resultTable, inputTable[i])
		end
	end
	return resultTable
end

-- Trim space http://lua-users.org/wiki/StringTrim
function TrimSpace(str)
	-- "%s" - space
	-- "."  - any character
	-- "-"  - 'lazy' zero or more times
	-- ".-" - 'lazy' any character
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

-- Return "false" - params OK, "true" - params WRONG
function CheckInputParams()
	local MsgWait = ChoGGi.ComFuncs.MsgWait
	local build_category = tonumber(layoutSettings.build_category)
	layoutSettings.build_category = build_category
	if build_category < 1 or build_category > #origMenuId then
		-- Restore default value
		layoutSettings.build_category = default_build_category
		MsgWait(
			'"build_category" - enter number from 1 to ' .. #origMenuId,
			'"build_category" - not allowed value: ' .. build_category
		)
		return true
	end
	
	local build_pos = tonumber(layoutSettings.build_pos)
	layoutSettings.build_pos = build_pos
	if build_pos < 0 or build_pos > 99 then
		layoutSettings.build_pos = default_build_pos
		MsgWait(
			'"build_pos" - enter number from 1 to 99',
			'"build_pos" - not allowed value: ' .. build_pos
		)
		return true
	end
	
	-- No need to check them, they will be automatically tostring() on string concatenation
	-- layoutSettings.description
	-- layoutSettings.display_name
	
	local id = TrimSpace(tostring(layoutSettings.id))
	layoutSettings.id = id
	if string.find(id, " ") or string.find(id, "\t") then
		-- Do not restore default value, user can edit yourself
		MsgWait(
			'"id" - space or tab not allowed, allowed "CamelCase" or "snake_case" notation',
			'"id" - not allowed value: ' .. id
		)
		return true
	end
	
	local radius = tonumber(layoutSettings.radius)
	layoutSettings.radius = radius
	if radius < 1 then
	layoutSettings.radius = default_radius
		MsgWait(
			'"radius" - enter positive number [to infinity and beyond]',
			'"radius" - not allowed value: ' .. radius
		)
		return true
	end
	
	return false
end

function SetAllFileNames()
	-- metadata.lua
	metadataFileName = CurrentModPath .. "metadata.lua"
	-- Layouts.lua
	layoutsFileName = CurrentModPath .. "Code/Layouts.lua"
	
	-- Code/Layout/layout.lua
	-- Path to file
	layoutFilePath = CurrentModPath .. "Code/Layout/"
	-- File name without path
	layoutFileNameNoPath = origMenuId[layoutSettings.build_category] .. " - " .. string.format("%02d", layoutSettings.build_pos) .. " - " .. layoutSettings.id .. ".lua"
	-- Concatenate path and name
	layoutFileName = layoutFilePath ..layoutFileNameNoPath

	-- Icons
	menuIconFileName = CurrentModPath .. menuIcon
	layoutIconFileName = CurrentModPath .. "UI/Layout/" .. layoutSettings.id .. ".png"
	
	-- Do not overwrite existing lua files
	if DEBUG_LUA then
		local dbgExt = ".txt"
		layoutsFileName = layoutsFileName .. dbgExt
		layoutFileName = layoutFileName .. dbgExt
		layoutFileNameNoPath = layoutFileNameNoPath .. dbgExt
		metadataFileName = metadataFileName .. dbgExt
	end
end

function FileExist(fileName)
	if AsyncGetFileAttribute(fileName, "size") == "File Not Found" then
		return false
	else
		return true
	end
end

function GetIdList()
	local idList = {}
	local layoutListFiles = GetLayoutListFiles()
	for i, fileName in ipairs(layoutListFiles) do
		-- %w - alphanumeric character
		idList[#idList + 1] = string.match(fileName, " - ([%w_]+).lua")
	end
	return idList
end

function IsIdPresentInLayoutFolder(id)
	local layoutListFiles = GetLayoutListFiles()
	for i, fileName in ipairs(layoutListFiles) do
		-- %w - alphanumeric character
		if string.match(fileName, " - ([%w_]+).lua") == id then
			return true
		end
	end
	return false
end

function IsIdUnique(layoutFileExist)
	local MsgWait = ChoGGi.ComFuncs.MsgWait
	local id = layoutSettings.id
	-- If "id" is present in "Layout" folder in different file - Not unique - return false
	-- If "id" is present in "Layout" folder in file with same name - Not unique, but we can overwrite it and it will be unique - return true
	if IsIdPresentInLayoutFolder(id) then
		if layoutFileExist then
			return true
		else
			MsgWait(
				'"id" - is already used by one of your layouts, must be unique, change "id" value',
				'"id" - not allowed value: ' .. id
			)
			return false
		end
	-- BuildingTemplates[id] check must be last. If it will be sooner, then on ReloadLua() user's layouts will stay in "BuildingTemplates" and this check will return false-positive result.
	elseif BuildingTemplates[id] then
		MsgWait(
			'"id" - is already used by game, must be unique, change "id" value',
			'"id" - not allowed value: ' .. id
		)
		return false
	end
	return true
end

function RemoveBuildings(worldObjs, skipDome)
	-- Local is faster
	local string_find = string.find
	local table_remove = table.remove
	for i = #worldObjs, 1, -1 do
		local dome_required = worldObjs[i].dome_required
		local entity = worldObjs[i]:GetEntity()
		local template_name = worldObjs[i].template_name
		-- "Passages" not supported by in-game "LayoutConstruction", remove them
		-- "Passages" between "Domes" are "Building", but they don't have "template_name"
		if template_name == "" or template_name == "Tunnel"
			-- Remove domes, when we capture without domes
			or (skipDome and string_find(entity, "Dome"))
			-- Remove "dome_required" buildings if we capture all buildings, game will not allow build such layout
			or (not skipDome and dome_required) then
			table_remove(worldObjs, i)
		end
	end
end

function CaptureObjects(skipDome)
	buildings        = ReturnAllNearby(layoutSettings.radius, "template_name", "Building")
	RemoveBuildings(buildings, skipDome)
	local supplyGrid = ReturnAllNearby(layoutSettings.radius, nil, "BreakableSupplyGridElement")
	cables = GetObjsByEntity(supplyGrid, "Cable")
	tubes  = GetObjsByEntity(supplyGrid, "Tube")

	local numCapturedObjects = #buildings + #cables + #tubes
	printD("Captured Objects: " .. numCapturedObjects .. " = #buildings=" .. #buildings .. " + #cables=" .. #cables .. " + #tubes=" .. #tubes)
	if DEBUG_EXAMINE then
		OpenExamine(buildings)
	end
end

function TableEmpty(table)
	-- next(table) == nil -- Is Empty Table Check
	if next(table) == nil then
		return true
	else
		return false
	end
end

-- Is all object's tables empty
function AllObjectsTablesEmpty()
	if TableEmpty(buildings) and TableEmpty(cables) and TableEmpty(tubes) then
		return true
	else
		return false
	end
end

function LayoutCapture(skipDome)
	printD(GetDate())
	local QuestionBox = ChoGGi.ComFuncs.QuestionBox

	-- After this all params in layoutSettings are correct
	if CheckInputParams() then
		return
	end
	
	SetAllFileNames()
	local layoutFileExist = FileExist(layoutFileName)
	
	if not IsIdUnique(layoutFileExist) then
		return
	end
	
	CaptureObjects(skipDome)
	if AllObjectsTablesEmpty() then
		QuestionBox(
			'Update "Layouts.lua"?',
			function(answer)
				if answer then
					SaveLayoutsLua()
					MsgPopup('"Layouts.lua" Updated')
				else
					MsgPopup("Nothing captured!")
				end
			end,
			"Nothing captured!",
			"Yes",
			"No"
		)
		return
	end
	
	if layoutFileExist then
		-- function ChoGGi.ComFuncs.QuestionBox(text, function, title, ok_text, cancel_text, image, context, parent, template, thread)
		QuestionBox(
			'Path to "Layout" folder: \n\t"' .. CurrentModPath .. 'Code/Layout"\nLayout file with this name already exist in "Layout" folder: \n\t"' .. layoutFileNameNoPath .. '"',
			function(answer)
				if answer then
					-- If we reload lua, our old layout object still be present in building's table.
					-- Layout script by default skip creating object if it already exist in game.
					-- Delete our layout object from in-game building's table.
					-- So after reloading lua updated layout become visible.
					-- I commented here, because I do it in Fixer_ReloadLua()
					-- BuildingTemplates[layoutSettings.id] = nil
					WriteToFiles()
				end
			end,
			"Overwrite file?",
			"Yes",
			"Cancel Layout Capture"
		)
	else
		WriteToFiles()
	end
end

function LayoutCaptureAll()
	LayoutCapture(false)
end

function LayoutCaptureWithoutDome()
	LayoutCapture(true)
end

function CreateLayoutPath()
	printDMsgOrErr(
		AsyncCreatePath(CurrentModPath .. "Code/Layout"),
		'"Code/Layout" Folder Created (if not exist before)',
		'"Code/Layout" Folder Not Created')
	printDMsgOrErr(
		AsyncCreatePath(CurrentModPath .. "UI/Layout"),
		'"UI/Layout" Folder Created (if not exist before)',
		'"UI/Layout" Folder Not Created')
end

function SaveLayoutLua()
	-- string err AsyncStringToFile(...) - by default overwrites file
	printDMsgOrErr(
		AsyncStringToFile(layoutFileName, BuildLayoutLua()),
		"Layout Saved: " .. layoutFileNameNoPath,
		"Layout Saving Failed: " .. layoutFileNameNoPath)
end

function SaveLayoutsLua()
	printDMsgOrErr(
		AsyncStringToFile(layoutsFileName, BuildLayoutsLua()),
		'"Layouts.lua" Updated',
		'"Layouts.lua" Update Failed')
end

-- function SaveMetadataLua()
	-- printDMsgOrErr(
		-- AsyncStringToFile(metadataFileName, BuildMetadataLua()),
		-- '"metadata.lua" Updated',
		-- '"metadata.lua" Update Failed')
-- end

function WriteToFiles()
	-- "items.lua" not needed. Empty is OK. It used by in-game "Mod Editor". ChoGGi says "Mod Editor" may corrupt mods on saving.
	CreateLayoutPath()
	SaveLayoutLua()
	SaveLayoutsLua()
	-- SaveMetadataLua()
	if not FileExist(layoutIconFileName) then
		printDMsgOrErr(
			AsyncCopyFile(menuIconFileName, layoutIconFileName),
			"Icon Copied: " .. layoutSettings.id .. ".png",
			"Icon Copy Failed: " .. layoutSettings.id .. ".png")
	else
		local str = "Icon Not Copied (already exist): " .. layoutSettings.id .. ".png"
		printD(str)
	end
	if GlobalError == true then
		GlobalError = false
		MsgPopup("Something went wrong :(")
	else
		MsgPopup("Layout Saved: " .. layoutFileNameNoPath .. '\n"Reload Lua" [' .. ShortcutReloadLua .. '] to update building menus.')
	end
end

function SetBuildCategory()
	local itemList = {}
	for i, v in ipairs(origMenuId) do
		itemList[#itemList + 1] = {text = origMenuId[i], value = i}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		layoutSettings.build_category = choice[1].value
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = itemList,
		title = "Choose Building Menu",
		skip_sort = true,
		height = 350.0,
		width = 150.0,
	}
end

local IsDialogWindowOpen_Info = false
local IsDialogWindowOpen_Params = false

function LayoutSetParams()
	local OpenInObjectEditorDlg = ChoGGi.ComFuncs.OpenInObjectEditorDlg
	local CloseDialogsECM = ChoGGi.ComFuncs.CloseDialogsECM
	if IsDialogWindowOpen_Params then
		-- If we close "Info" dialog window here, flag "IsDialogWindowOpen_Info" will remain "true".
			-- If we hit hotkey to show "Info" window, it will not appear. So clear this flag.
		IsDialogWindowOpen_Info = false
		IsDialogWindowOpen_Params = false
		-- Close ALL windows
		CloseDialogsECM()
	else
		IsDialogWindowOpen_Params = true
		OpenInObjectEditorDlg(layoutSettings)
		SetBuildCategory()
	end
end

function LayoutShowInfo()
	local OpenInObjectEditorDlg = ChoGGi.ComFuncs.OpenInObjectEditorDlg
	local CloseDialogsECM = ChoGGi.ComFuncs.CloseDialogsECM
	if IsDialogWindowOpen_Info then
		IsDialogWindowOpen_Info = false
		IsDialogWindowOpen_Params = false
		CloseDialogsECM()
	else
		IsDialogWindowOpen_Info = true
		OpenExamine(GUIDE)
	end
end

function BuildLayoutHeadLua()
	local str = [[
-- File is generated by "]] .. modName .. [["
function OnMsg.ClassesPostprocess()
	local id = "]] .. layoutSettings.id .. [["
	if BuildingTemplates[id] then
		return
	end

	local build_category = "]] .. menuId[layoutSettings.build_category] .. [["

	PlaceObj("BuildingTemplate", {
		"Id", id,
		"LayoutList", id,
		"Group", build_category,
		"build_category", build_category,
		"build_pos", ]] .. layoutSettings.build_pos .. [[,
		"display_name", "]] .. layoutSettings.display_name .. [[",
		"display_name_pl", "]] .. layoutSettings.display_name .. [[",
		"description", "]] .. layoutSettings.description .. [[",
		"display_icon", "]] .. CurrentModPath .. "UI/Layout/" .. layoutSettings.id .. ".png" .. [[",
		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})

	PlaceObj("LayoutConstruction", {
		group = "Default",
		id = id,

]]

	return str
end

-- Line = Hub-segment-...-segment-Hub
-- Hub = "TubeHub" or "CableHub", segment = "Tube" or "CableTerrain"
-- To build grid of tubes or cables we need build objects in straight line. Game engine do that by clicking mouse
	-- on "begin position" and then clicking on	"end position". Segments built automatically, we not needed them
	-- in result.
-- Cable line begins on hub and ends on hub. If line has smooth turn, we assume	that turn as a hub and build two
	-- lines which connects on turn.
-- Tube line begins on hub but ends on hub (usual case) or segment (when tube line ends for example on "Oxygen Tank").
	-- Tube line does not have smooth turns.
-- Orphan - object with no connections. Segments cannot be orphan, Hub can be orphan.
-- Save orphans then find and save lines. Algorithm of finding lines:
	-- Find first hub, get direction of connection, remove that direction from hub, find position of neighbor in
	-- that direction, find object on that position. If it is not hub, so it is segment, so line is not finished,
	-- delete connection from where we came and to where we go (segment always has two connections	with opposite
	-- directions, so we do not need clear two flags, just assign 0 to "conn" field), find again new neighbor in that
	-- direction, traverse objects till we find hub. If it is hub, delete connection from where we came. We found the
	-- end	of line, save line. Delete objects with no connections. Loop this algorithm	until we cannot find hub.
	-- When loop is stopped, table with objects must be empty.

function IsCables(type)
	if string.lower(type) == "cables" then
		return true
	else
		return false
	end
end

function IsTubes(type)
	if string.lower(type) == "tubes" then
		return true
	else
		return false
	end
end

function Hex(q, r)
	return { q = q, r = r, }
end

function HexEqual(hexA, hexB)
	return hexA.q == hexB.q and hexA.r == hexB.r
end

function HexObjLineAsStr(hexBegin, hexEnd, type, saveOrphan)
	saveOrphan = saveOrphan or false
	local str = ""
	local template
	if IsCables(type) then
		template = "electricity_grid"
	elseif IsTubes(type) then
		template = "life_support_grid"
	else
		printD('HexObjLineAsStr(): Wrong "type" argument: ' .. type)
		return ""
	end
	
	-- Do not save objects if begin and end position is equal (example: "Moisture Vaporator")
	-- OR save it if we saving orphans
	if not HexEqual(hexBegin, hexEnd) or saveOrphan then
		-- Tubes and Cables don't have "template_name" parameter, write it explicitly
		str = str .. [[
		PlaceObj("LayoutConstructionEntry", {
			"template", "]] .. template .. [[",
			"pos", point(]] .. hexBegin.q .. [[, ]] .. hexBegin.r .. [[),
			"cur_pos1", point(]] .. hexEnd.q .. [[, ]] .. hexEnd.r .. [[),
		}),]] .. "\n\n"
		printD(type .. ": Line=" .. hexBegin.q .. "," .. hexBegin.r .. "|" .. hexEnd.q .. "," .. hexEnd.r)
	end
	return str
end

function IsHub(worldObj)
	local entity = worldObj:GetEntity()
	return	entity == "CableHub"       or entity == "TubeHub"       or
			entity == "CableSwitch"    or entity == "TubeSwitch"    or
			entity == "CableSoftLeft"  or entity == "CableHardLeft" or
			entity == "CableSoftRight" or entity == "CableHardRight"
end

-- Make our objects - simpler version of in-game objects
function HexObjs(worldObjs, baseHex)
	local hexObjs ={}
	for id, obj in pairs(worldObjs) do
		local q, r = WorldToHex(obj)
		local hex = Hex(q - baseHex.q, r - baseHex.r)
		local entity = obj:GetEntity()
		local hub = false
		
		if IsHub(obj) then
			hub = true
		end
		
		hexObjs[#hexObjs + 1] = {
			-- "conn" is a variable with 6 flags (bits from 0 to 5) representing
			--	direction of connection (counts from 1 to 6) beginning from "left", continue clockwise:
			--   0 bit - connection from left side of hex
			-- 1st bit - up-left
			-- 2nd bit - up-right
			-- 3rd bit - right
			-- 4th bit - bottom-right
			-- 5th bit - bottom-left
			-- 16256 - initial value, if no connection; subtract it and we will have only flags we need
			conn = obj.conn - 16256,
			entity = entity,
			hex = hex,
			hub = hub,
		}
	end
	return hexObjs
end

function HexNeighbor(hex, direction)
	if direction < 1 or direction > 6 then
		printD('HexNeighbor(): wrong "direction" parameter: ' .. direction)
	end
	local axialDirections = {
		Hex( 1,  0),
		Hex( 0,  1),
		Hex(-1,  1),
		Hex(-1,  0),
		Hex( 0, -1),
		Hex( 1, -1),
	}
	local dir = axialDirections[direction]
	return Hex(hex.q + dir.q, hex.r + dir.r)
end

function CheckBitConn(hexObj, direction)
	-- Direction numeration begins from one. Bit numeration begins from zero.
	local bitNum = direction - 1
	if hexObj.conn & (1 << bitNum) ~= 0 then
		return true
	else
		return false
	end
end

function ClearBitConn(hexObj, direction)
	-- Direction numeration begins from one. Bit numeration begins from zero.
	local bitNum = direction - 1
	-- "~" - invert operator
	hexObj.conn = hexObj.conn & ~(1 << bitNum)
end

function AxialDirection(hexObj)
	local direction = 0
	local noMoreConnection = false
	for i = 1, 6, 1 do
		if CheckBitConn(hexObj, i) then
			ClearBitConn(hexObj, i)
			direction = i
			if hexObj.conn == 0 then
				noMoreConnection = true
			end
			break
		end
	end
	return direction, noMoreConnection
end

function BuildOrphans(hexObjs, type, strTbl)
	local orphanNum = 0
	for i = #hexObjs, 1, -1 do
		local hexObj = hexObjs[i]
		if hexObj.conn == 0 then
			orphanNum = orphanNum + 1
			strTbl[#strTbl + 1] = HexObjLineAsStr(hexObj.hex, hexObj.hex, type, true)
			table.remove(hexObjs, i)
		end
	end
	return orphanNum
end

function FindHub(hexObjs)
	for i, hexObj in ipairs(hexObjs) do
		if hexObj.hub then
			return hexObj
		end
	end
	return nil
end

function FindObjByHex(hexObjs, hex)
	for i, hexObj in ipairs(hexObjs) do
		if HexEqual(hexObj.hex, hex) then
			return hexObj
		end
	end
	return nil
end

function FindEndObj(hexObjs, hexObjBegin, direction)
	local hexObjPrev = hexObjBegin
	while (true) do
		local hexNext = HexNeighbor(hexObjPrev.hex, direction)
		local hexObjNext = FindObjByHex(hexObjs, hexNext)
		-- Tube line can end not on "TubeHub" (example: "Oxygen Tank")
		if not hexObjNext then
			return hexObjPrev
		end
		if hexObjNext.hub then
			-- Hex grid have 6 directions, so plus 3 gives opposite direction
			-- Limit result to 6 by "%" operator (module)
			-- Subtract 1 from direction to make it zero-based, because "%" operator is zero-based
			-- Add 1 to result to make numeration starts from one.
			local oppositeDir = ((direction - 1) + 3) % 6 + 1
			-- Clear direction, from which we came
			ClearBitConn(hexObjNext, oppositeDir)
			return hexObjNext
		else
			-- "Segments" between "Hubs" have only two directions: one from which
			--	we came and second - where we continue go trying find hub or end of line
			hexObjNext.conn = 0
		end
		hexObjPrev = hexObjNext
	end
end

function RemoveNoConn(hexObjs)
	for i = #hexObjs, 1, -1 do
		if hexObjs[i].conn == 0 then
			table.remove(hexObjs, i)
		end
	end
end

function BuildLines(hexObjs, type, strTbl)
	local lineNum = 0
	while(true) do
		local hexObjBegin = FindHub(hexObjs)
		if not hexObjBegin then
			break
		end
		
		local noConn = false
		while (not noConn) do
			local direction
			direction, noConn = AxialDirection(hexObjBegin)
			local hexObjEnd = FindEndObj(hexObjs, hexObjBegin, direction)
			local str = HexObjLineAsStr(hexObjBegin.hex, hexObjEnd.hex, type)
			if str ~= "" then
				strTbl[#strTbl + 1] = str
				lineNum = lineNum + 1
			end
		end
		
		RemoveNoConn(hexObjs)
	end
	return lineNum
end

function IsAllNeighbors(hexObjs, hexObj)
	-- AxialDirection() will change "conn" value, save it
	local conn = hexObj.conn
	local allNeighborsExist = true
	local allNeighborsNotExist = true
	local noConn = false
	while (not noConn) do
		local direction
		direction, noConn = AxialDirection(hexObj)
		local hexNeighbor = HexNeighbor(hexObj.hex, direction)
		local hexObjNeighbor = FindObjByHex(hexObjs, hexNeighbor)
		if hexObjNeighbor then
			allNeighborsNotExist = false
		else
			allNeighborsExist = false
		end
	end
	-- Restore previous value
	hexObj.conn = conn
	return allNeighborsExist, allNeighborsNotExist
end

function SetAdditionalOrphans(hexObjs)
	for i, hexObj in ipairs(hexObjs) do
		if hexObj.conn ~= 0 then
			-- If "conn" parameter says object has neighbors, but actually all of them are absent -> this is orphan
			local allNeighborsExist, allNeighborsNotExist = IsAllNeighbors(hexObjs, hexObj)
			if allNeighborsNotExist then
				-- Orphan must don't have connections
				hexObj.conn = 0
			end
		end
	end
end

function SetHubOnLineEnding(hexObjs)
	for i, hexObj in ipairs(hexObjs) do
		-- If "conn" parameter says object has neighbors, but actually at least one is absent -> this is end of line
		local allNeighborsExist, allNeighborsNotExist = IsAllNeighbors(hexObjs, hexObj)
		if not allNeighborsExist then
			hexObj.hub = true
		end
	end
end

function BuildGrid(worldObjs, baseHex, type)
	local strTbl = {"",}
	if not TableEmpty(worldObjs) then
		local comment
		if IsCables(type) then
			comment = "\t\t-- Cables\n"
		elseif IsTubes(type) then
			comment = "\t\t-- Tubes\n"
		else
			printD('BuildGrid(): Wrong "type" argument: ' .. type)
			return ""
		end
		table.insert(strTbl, comment)

		-- After successful finding or saving, objects removed from "hexObjs"
		-- At the end, hexObjs must be empty
		local hexObjs = HexObjs(worldObjs, baseHex)
		-- Set additional orphans
		SetAdditionalOrphans(hexObjs)
		
		local orphanNum = BuildOrphans(hexObjs, type, strTbl)
		local lineNum = BuildLines(hexObjs, type, strTbl)
		
		-- Tube line without hubs at both ends (example straight line between two domes)
		if IsTubes(type) then
			SetHubOnLineEnding(hexObjs)
			lineNum = lineNum + BuildLines(hexObjs, type, strTbl)
		end

		printD(type .. ": GridOrphan = " .. orphanNum .. " GridLine = " .. lineNum)
		if not TableEmpty(hexObjs) then
			MsgPopup(type .. " ERROR: table not empty, some objects not saved")
		end
	end
	return table.concat(strTbl)
end

-- Get position of "base object". Position offset of all other objects will be calculated relative to it.
function GetBaseObjectPosition()
	local baseObj
	-- ~= is equivalent of !=
	-- Check if table is not empty
	if not TableEmpty(buildings) then
		baseObj = buildings[1]
	elseif not TableEmpty(cables) then
		baseObj = cables[1]
	elseif not TableEmpty(tubes) then
		baseObj = tubes[1]
	end

	local q, r = WorldToHex(baseObj)
	if DEBUG_EXAMINE then
		OpenExamine(baseObj)
	end
	
	return Hex(q, r)
end

function BuildBuildings(worldObjs, baseHex)
	local str = ""
	if not TableEmpty(worldObjs) then
		str = str .. "\t\t-- Buildings\n"
		for i, obj in ipairs(worldObjs) do
			local q, r = WorldToHex(obj)
			-- Calculate offset from "base object"
			q = q - baseHex.q
			r = r - baseHex.r
			str = str .. [[
		PlaceObj("LayoutConstructionEntry", {
			"template", "]] .. obj.template_name .. [[",
			"pos", point(]] .. q .. [[, ]] .. r .. [[),
			"dir", ]] .. HexAngleToDirection(obj) .. [[,
			"entity", "]] .. obj:GetEntity() .. [[",]] .. "\n"
			-- "instant" parameter not needed at all, game build "Storages" instantly in any case
			-- if string.find(obj.template_name, "Storage") then
				-- str = str .. [[
			-- "instant", true,]] .. "\n"
			-- end
			str = str .. [[
		}),]] .. "\n\n"
		end
	end
	return str
end

function BuildCables(worldObjs, baseHex)
	local str = ""
	-- Don't have "template_name" parameter, write it explicitly
	-- Brute force variant, ugly result in game
	if not TableEmpty(worldObjs) then
		str = str .. "\t\t-- Cables\n"
		for i, obj in ipairs(worldObjs) do
			local q, r = WorldToHex(obj)
			q = q - baseHex.q
			r = r - baseHex.r
			str = str .. [[
		PlaceObj("LayoutConstructionEntry", {
			"template", "electricity_grid",
			"pos", point(]] .. q .. [[, ]] .. r .. [[),
			"cur_pos1", point(]] .. q .. [[, ]] .. r .. [[),
		}),]] .. "\n\n"
		end
	end
	return str
end

-- Save tube objects as lua objects, that can be used in "ZeroBrane Studio" (LUA IDE) for debugging
function BuildTubesTesting(worldObjs, baseHex)
	local str = ""
	-- Brute force variant
	if not TableEmpty(worldObjs) then
		str = str .. "\t\t-- Tubes\n"
		for i, obj in ipairs(worldObjs) do
			local q, r = WorldToHex(obj)
			q = q - baseHex.q
			r = r - baseHex.r
			local hub = false
			local entity = obj:GetEntity()
			if IsHub(obj) then
				hub = true
			end
			str = str .. [[{ conn = ]] .. obj.conn - 16256 .. [[, hex = Hex(]] .. q .. [[,]] .. r .. [[), hub = ]] .. tostring(hub) .. [[, entity = "]] .. entity .. [["},]] .. "\n"
		end
	end
	return str
end

function BuildLayoutBodyLua()
	-- Official documentation LuaFunctionDoc_hex.md.html
	local str = ""
	-- Base point (zero point)
	local baseHex = GetBaseObjectPosition()
	str = str .. BuildBuildings(buildings, baseHex)
	str = str .. BuildGrid(cables, baseHex, "Cables")
	str = str .. BuildGrid(tubes, baseHex, "Tubes")
	-- str = str .. BuildTubesTesting(tubes, baseHex)
	return str
end

function BuildLayoutTailLua()
	local str = [[
	})
end
]]
	return str .. "\n\n\n\n"
end

function BuildLayoutLua()
	return BuildLayoutHeadLua() .. BuildLayoutBodyLua() .. BuildLayoutTailLua()
end

-- Return list of files in "Code/Layout" folder
function GetLayoutListFiles()
	local err, layoutListFiles = AsyncListFiles(CurrentModPath .. "Code/Layout", "*.lua", "relative, sorted")
	printDMsgOrErr(
		err,
		nil,
		"Error AsyncListFiles():")
	return layoutListFiles
end

-- Not used anymore, only for history
-- function BuildMetadataLua()
	-- local layoutListFiles = GetLayoutListFiles()
	-- local strLayoutFiles = ""
	-- for i, strFileName in ipairs(layoutListFiles) do
		-- strLayoutFiles = strLayoutFiles .. '\t\t"' .. 'Code/Layout/' .. strFileName .. '",\n'
	-- end
	-- local str = [[
-- return PlaceObj('ModDef', {
	-- "dependencies", {
		-- PlaceObj("ModDependency", {
			-- "id", "ChoGGi_Library",
			-- "title", "ChoGGi's Library",
			-- "version_major", 8,
			-- "version_minor", 7,
		-- }),
		-- PlaceObj("ModDependency", {
			-- "id", "ChoGGi_CheatMenu",
			-- "title", "Expanded Cheat Menu",
			-- "version_major", 15,
			-- "version_minor", 7,
		-- }),
	-- },
	-- 'title', "Layout Mod",
	-- 'description', "Capture and save building's layout.",
	-- 'image', "ModImage.png",
	-- 'last_changes', "Initial release.",
	-- 'id', "Fixer_Layout_Mod",
	-- 'steam_id', "9876543210",
	-- 'pops_desktop_uuid', "2985b508-0ba0-4f20-8ff3-8bf242be35e3",
	-- 'pops_any_uuid', "bbf577bf-dee0-4346-bad5-1037f6a827e7",
	-- 'author', "Fixer",
	-- 'version_major', 1,
	-- 'version', 1,
	-- 'lua_revision', 233360,
	-- 'saved_with_revision', 249143,
	-- 'code', {
		-- -- Main Code --
		-- "Code/Script.lua",
		-- -- Captured Layout --
-- ]] .. strLayoutFiles .. [[
	-- },
	-- 'saved', 1604768099,
	-- 'TagTools', true,
	-- 'TagOther', true,
-- })
-- ]]
	-- return str
-- end

function BuildLayoutsLua()
	local layoutListFiles = GetLayoutListFiles()
	local str = ""
	for i, strFileName in ipairs(layoutListFiles) do
		local err, data = AsyncFileToString(CurrentModPath .. "Code/Layout/" .. strFileName)
		printDMsgOrErr(
			err,
			nil,
			"Error AsyncFileToString():")
		str = str .. data
	end
	return str
end




---- Photo Mode ----

function PhotoMode()
	-- Pause game
	UICity:SetGameSpeed(0)
	UISpeedState = "pause"
	-- Set bright light
	SetLightmodelOverride(1)
	SetLightmodel(1, "ArtPreview")
	-- Set green color for terrain to make screenshot
	TerrainTextureChange({ text = "Prefab_Green", value = 27, })
end

-- Copy-Paste from ChoGGi.MenuFuncs.TerrainTextureChange()
function TerrainTextureChange(choice)
	local function RestoreSkins(label, temp_skin, idx)
		for i = 1, #(label or "") do
			local o = label[i]
			-- If i don't set waste skins to the ground texture then it won't be the right texture for GetCurrentSkin
			-- got me
			if temp_skin then
				o.orig_terrain1 = idx
				o.orig_terrain2 = nil
				o:ChangeSkin("Terrain" .. temp_skin)
			end
			o:ChangeSkin(o:GetCurrentSkin())
		end
	end

	local GridOpFree = GridOpFree
	local AsyncSetTypeGrid = AsyncSetTypeGrid
	local MulDivRound = MulDivRound
	local sqrt = sqrt

	local NoisePreset = DataInstances.NoisePreset
	local guim = guim

	local TerrainTextures = TerrainTextures

	local function CallBackFunc(choice)
		if TerrainTextures[choice.value] then
			SuspendPassEdits("ChoGGi.MenuFuncs.TerrainTextureChange")
			terrain.SetTerrainType{type = choice.value}

			-- add back dome grass
			RestoreSkins(UICity.labels.Dome)
			-- restore waste piles
			RestoreSkins(UICity.labels.WasteRockDumpSite, choice.text, choice.value)

			-- re-build concrete marker textures
			local texture_idx1 = table.find(TerrainTextures, "name", "Regolith") + 1
			local texture_idx2 = table.find(TerrainTextures, "name", "Regolith_02") + 1

			local deposits = UICity.labels.TerrainDeposit or ""
			for i = 1, #deposits do
				local d = deposits[i]
				if IsValid(d) then
					local pattern = NoisePreset.ConcreteForm:GetNoise(128, Random())
					pattern:land_i(NoisePreset.ConcreteNoise:GetNoise(128, Random()))
					-- any over 1000 get the more noticeable texture
					if d.max_amount > 1000000 then
						pattern:mul_i(texture_idx2, 1)
					else
						pattern:mul_i(texture_idx1, 1)
					end
					-- blend in with surrounding ground
					pattern:sub_i(1, 1)
					-- ?
					pattern = GridOpFree(pattern, "repack", 8)
					-- paint deposit
					AsyncSetTypeGrid{
						type_grid = pattern,
						pos = d:GetPos(),
						scale = sqrt(MulDivRound(10000, d.max_amount / guim, d.radius_max)),
						centered = true,
						invalid_type = -1,
					}
				end
			end -- for

			ResumePassEdits("ChoGGi.MenuFuncs.TerrainTextureChange")
		end -- If TerrainTextures

	end -- CallBackFunc

	CallBackFunc(choice)
	printD("Terrain texture changed")
end




---- OnMsg ----

-- Use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- printD("msg_ClassesBuilt")
	CreateShortcuts() -- in other places not work :(
	CreateMenus() -- original place
end

-- -- New_Game + Load_Save
-- function OnMsg.ModsReloaded()
	-- -- printD("msg_ModsReloaded")
-- end

-- -- Load_Save
-- function OnMsg.LoadGame()
	-- -- printD("msg_LoadGame")
	-- -- CreateMenus()
-- end

-- -- New_Game
-- function OnMsg.CityStart()
	-- -- printD("CityStart")
	-- -- CreateMenus()
-- end