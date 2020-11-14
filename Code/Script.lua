-- TODO -- Ask ChoGGi to add hotkey to "Close dialogs"

---- BUILD MENUS ----

-- Ingame table with root menus, which appears on hotkey [B]:
-- Enhanced Cheat Menu -> Console -> ~BuildCategories

-- Ingame table with menu subcategories (example is [Depot] in [Storages]):
-- Enhanced Cheat Menu -> Console -> ~BuildMenuSubcategories

-- Empty menu is not visible. Add building, and menu will appear.

-- GlobalVar("tmp", {"param1","param2",}) <- this line will not create object, but boolean == false :(
-- GlobalVar("tmp", {}) tmp = {[1] = "param1", [2] = "param2",} <- create empty object, add params

-- pairs() returns key-value pairs and is mostly used for associative tables. key order is unspecified.
-- ipairs() returns index-value pairs and is mostly used for numeric tables. Non numeric keys in an array are ignored, while the index order is deterministic (in numeric order).

-- Order of function definition is essential. Must define before first useage. Search "Lua Function Forward Declaration".

-- Official documentation LuaFunctionDoc_AsyncIO.md.html for all "Async*()" functions in this script.

-- Path to menu icon
local menuIcon = "UI/MenuIcon.png"
-- Disaplay name of each menu
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

-- Use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- Create id for my submenus
	for i, id in ipairs(origMenuId) do
		menuId[i] = idPrefix .. id
	end
	
	-- Create root menu
	local bc = BuildCategories
	local id = menuId[#menuId] -- #var - get size of table "var"
	if not table.find(bc, "id", id) then
		bc[#bc + 1] = {
			id = id,
			name = displayName,
			image = CurrentModPath .. menuIcon,
			-- highlight = "UI/Icons/Buildings/dinner_shine.tga", TODO not needed?
		}
	end
	
	-- Create submenu in each original menu
	for i, id in ipairs(menuId) do
		local bmc = BuildMenuSubcategories
		if not table.find(bmc, "id", id) then
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
				-- allow_template_variants = true -- by default it's true
				-- action = function(self, context, button)
					-- print("You Selected Subcategory")
				-- end
			})
		end
	end
end




---- MAIN CODE ----

local ShortcutCapture   = "Ctrl-Insert"
local ShortcutSetParams = "Shift-Insert"

function TableToString(inputTable)
	local str = ""
	for i, v in ipairs(inputTable) do
		if (i < 10) then
			-- Shift line with one digit [1-9] to right
			str = str .. "   "
		end
		str = str .. i .. "\t== " .. v .. "\n"
	end
	return str
end

local GUIDE = '\n' .. [[
ChoGGi's Mods: https://github.com/ChoGGi/SurvivingMars_CheatMods/
[REQUIRED] ChoGGi's "Startup HelperMod" to bypass blacklist (we need acces to AsyncIO functions to create lua files).
	Install required mod, then copy "BinAssets" from Layout's mod folder to "%AppData%\Surviving Mars".
[Optional] ChoGGi's "Enhanced Cheat Menu" [F2] -> "Cheats" -> "Toggle Unlock All Buildings" -> Double click "Unlock"
[Optional] ChoGGi's "Fix Layout Construction Tech Lock" mod if you want build buildings, that is locked by tech.
BUILD:
	Place your buildings.
	Press [Alt-B] to instant building.
SET PARAMS:
	Place your mouse cursor in the center of building's layout.
	Press [Ctrl-M] and measure radius of building's layout.
	Press []] .. ShortcutSetParams .. ']\n' .. [[
	Two window will appear: "Examine" and "Edit Object". Move "Examine" to see both windows.
	Set parameters in "Edit Object" window:
		"id" (must be unique) internal script parameter, additionally will be used as part of file name of layout's lua script and as file name for layout's icon.
		"build_category" (allowed number from 1 to 15) in which menu captured layout will be placed. See hint in another window.
		"build_pos" (number from 1 to 99, can be duplicated) position in build menu.
		"radius" (nil or positive number) capture radius, multiply measured value in meters by 100.
		[others] - as you like.
	Close all windows.
CAPTURE:
	Press []] .. ShortcutCapture .. ']\n' .. [[
APPLY:
	To take changes in effect restart game.
	Press [Ctrl-Alt-R] then [Enter].
WHAT TO DO:
	Make some fancy icon and replace the one, located in "]] .. CurrentModPath .. 'UI/%id%.png"\n\n' .. [[
"build_category" (allowed value is number from 1 to 15):]] .. '\n' .. TableToString(origMenuId)

local layoutSettings = {
	id = "SetIdForLayoutFile",
	display_name = "Display Name",
	description = "Layout Desctiption",
	build_category = 15,
	build_pos = 0,
	radius = nil,
}

-- function OnMsg.ClassesPostprocess()
-- end

-- Get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- ChoGGi.ComFuncs.OpenInExamineDlg(ReturnAllNearby(1000, "class")) from ChoGGi's Library v8.7
-- Added 4th argument "class": only get objects inherited from "class", provided by this parameter
function ReturnAllNearby(radius, sort, pt, class)
	-- local is faster then global
	local table_sort = table.sort
	radius = radius or 5000
	pt = pt or GetTerrainCursor()

	-- get all objects within radius
	local list = MapGet(pt, radius, class)

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
		if (string_find(inputTable[i]:GetEntity(), entity)) then
			table_insert(resultTable, inputTable[i])
		end
	end
	return resultTable
end

-- Custom dialog window, show only text, no action
-- TODO ChoGGi can we use simpler DialogBox?
function CancelDialogBox(text, title)
	-- function ChoGGi.ComFuncs.QuestionBox(text, func, title, ok_text, cancel_text, image, context, parent, template, thread)
	ChoGGi.ComFuncs.QuestionBox(
		text,
		nil,
		title,
		"Cancel Layout Capture",
		"Cancel Layout Capture"
	)
end

function FileExist(fileName)
	if (AsyncGetFileAttribute(fileName, "size") == "File Not Found") then
		return false
	else
		return true
	end
end

-- Function forward declaration
local BuildItemsLua, BuildMetadataLua, BuildLayoutHeadLua, BuildLayoutTailLua, BuildLayoutLua

function LayoutCapture()
	-- Capture objects
	local buildings = ReturnAllNearby(layoutSettings.radius, "class", nil, "Building")
	local supply    = ReturnAllNearby(layoutSettings.radius, "class", nil, "BreakableSupplyGridElement")
	local cables = GetObjsByEntity(supply, "Cable")
	local pipes  = GetObjsByEntity(supply, "Tube")
	ex(buildings)
	-- ex(supply)
	-- ex(cables)
	-- ex(pipes)
	
	-- Check params
	local build_category = tonumber(layoutSettings.build_category)
	if (build_category < 1 or build_category > #origMenuId) then
		CancelDialogBox(
			'"build_category" - enter number from 1 to 15',
			'"build_category" - not allowed value: ' .. build_category
		)
		return
	end
	
	local build_pos = tonumber(layoutSettings.build_pos)
	if (build_pos < 0 or build_pos > 99) then
		CancelDialogBox(
			'"build_pos" - enter number from 1 to 99',
			'"build_pos" - not allowed value: ' .. build_pos
		)
		return
	end
	
	-- Files prepare
	local itemsFileName = CurrentModPath .. "items.lua"
	local metadataFileName = CurrentModPath .. "metadata.lua"
	if (build_pos < 10) then
		build_pos = "0" .. build_pos
	end
	-- Concatenate path and name
	local layoutFileName = "" ..
		-- Path to file
		CurrentModPath .. "Layout/" ..
		-- File name without path
		origMenuId[build_category] .. " - " .. build_pos .. " - " .. layoutSettings.id .. ".lua"
	local fileExist = FileExist(layoutFileName)
	local fileOverwrite = false
	
	-- DEBUG
	-- Open in Notepad++, select two strings and hit [Ctrl-Q] to toggle comment
	-- local DEBUG = false
	local DEBUG = true
	
	if (DEBUG) then
		local dbgExt = ".txt"
		itemsFileName = itemsFileName .. dbgExt
		layoutFileName = layoutFileName .. dbgExt
		metadataFileName = metadataFileName .. dbgExt
	end
	print("FileName: " .. layoutFileName)
	-- Can't cocatenate boolean variable
	print("FileExist: " .. tostring(fileExist))
	
	-- string err AsyncStringToFile(...) - by default overwrites file
	print(AsyncStringToFile(metadataFileName, BuildMetadataLua()))
	return
	
	-- if (fileExist) then
		-- -- function ChoGGi.ComFuncs.QuestionBox(text, func, title, ok_text, cancel_text, image, context, parent, template, thread)
		-- ChoGGi.ComFuncs.QuestionBox(
			-- "Layout file with name already exist: " .. layoutFileName,
			-- function(answer)
				-- if answer then
					-- fileOverwrite = true
				-- end
			-- end,
			-- "Overwrite file?",
			-- "Yes",
			-- "Cancel Layout Capture"
		-- )
	-- end
	-- -- TODO 
	-- print("Layout Saved: " .. CurrentModPath .. "Layout\\".. layoutSettings.id .. ".lua")
end

function LayoutSetParams()
	local OpenInObjectEditorDlg = ChoGGi.ComFuncs.OpenInObjectEditorDlg
	OpenExamine(GUIDE)
	OpenInObjectEditorDlg(layoutSettings)
end

-- Create Shortcuts
-- After this message ChoGGi's object is ready to use
function OnMsg.ModsReloaded()
	local Actions = ChoGGi.Temp.Actions
	
	Actions[#Actions + 1] = {ActionName = "Layout Capture",
		ActionId = "Layout.Capture",
		OnAction = LayoutCapture,
		ActionShortcut = ShortcutCapture,
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Set Params",
		ActionId = "Layout.Set.Params",
		OnAction = LayoutSetParams,
		ActionShortcut = ShortcutSetParams,
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Clear Log",
		ActionId = "Layout.Clear.Log",
		OnAction = cls,
		ActionShortcut = "Alt-Insert",
		ActionBindable = true,
	}
end

BuildItemsLua = function()

end

BuildMetadataLua = function()
	local err, layoutFiles = AsyncListFiles(CurrentModPath .. "Layout", "*", "sorted")
	local strLayoutFiles = ""
	for i, strFile in ipairs(layoutFiles) do
		strLayoutFiles = "\t\t" .. strLayoutFiles .. "Layout/" .. strFile .. "\n"
	end
	local str = [[
return PlaceObj('ModDef', {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 7,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_CheatMenu",
			"title", "Expanded Cheat Manu",
			"version_major", 15,
			"version_minor", 7,
		}),
	},
	'title', "Layout Mod",
	'description', "Capture and save building's layout.",
	'image', "ModImage.png",
	'last_changes', "Initial release.",
	'id', "Fixer_Layout_Mod",
	'steam_id', "9876543210",
	'pops_desktop_uuid', "2985b508-0ba0-4f20-8ff3-8bf242be35e3",
	'pops_any_uuid', "bbf577bf-dee0-4346-bad5-1037f6a827e7",
	'author', "Fixer",
	'version_major', 1,
	'version', 1,
	'lua_revision', 233360,
	'saved_with_revision', 249143,
	'code', {
	-- Main Code --
		"Code/Script.lua",
	-- Captured Layout --
]] .. strLayoutFiles .. [[
	},
	'saved', 1604768099,
	-- 'screenshot1', "",
	'TagTools', true,
	'TagOther', true,
})
]]
	return str
end

BuildLayoutHeadLua = function()

end

BuildLayoutTailLua = function()

end

BuildLayoutLua = function()

end
