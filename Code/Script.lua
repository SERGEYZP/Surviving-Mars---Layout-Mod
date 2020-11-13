-- Build Menus --

-- Ingame table with root menus, which appears on hotkey [B]:
-- Enhanced Cheat Menu -> Console -> ~BuildCategories

-- Ingame table with menu subcategories (example is [Depot] in [Storages]):
-- Enhanced Cheat Menu -> Console -> ~BuildMenuSubcategories

-- Empty menu is not visible. Add building, and menu will appear.

-- GlobalVar("tmp", {"param1","param2",}) <- this line will not create object, but boolean == false :(
-- GlobalVar("tmp", {}) tmp = {[1] = "param1", [2] = "param2",} <- create empty object, add params

-- pairs() returns key-value pairs and is mostly used for associative tables. key order is unspecified.
-- ipairs() returns index-value pairs and is mostly used for numeric tables. Non numeric keys in an array are ignored, while the index order is deterministic (in numeric order).

-- Order of function definition is essential. Must define before first useage.

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




-- Main Code --

local ShortcutCapture = "Ctrl-Insert"
local ShortcutSave = "Shift-Insert"

function TableToString(tbl)
	local str = ""
	for i, v in ipairs(tbl) do
		if (i < 10) then
			-- Shift line with one digit [1-9] to right
			str = str .. " "
		end
		str = str .. i .. " == " .. v .. "\n"
	end
	return str
end

local GUIDE = '\n' .. [[
[Optional] "Enhanced Cheat Menu" [F2] -> "Cheats" -> "Toggle Unlock All Buildings" -> Double click "Unlock"
[Optional] Enable ChoGGi's "Fix Layout Construction Tech Lock" mod if you want build buildings, that is locked by tech.
BUILD:
	Place your buildings.
	Press [Alt+B] to instant building.
CAPTURE LAYOUT:
	Place your mouse cursor in the center of building's layout.
	Press []] .. ShortcutCapture .. ']\n' .. [[
	Two window will appear: "Examine" and "Edit Object". Move "Examine" to see both windows.
	Set all parameters in "Edit Object" window:
		"id" (must be unique) internal script parameter, additionally will be used as part of file name of layout's lua script and as file name for layout's icon.
		"build_category" (allowed number from 1 to 15) in which menu captured layout will be placed. See hint in another window.
		"build_pos" (number from 1 to ?) position in build menu.
		[others] - as you like.
	
SAVE:
	Press []] .. ShortcutSave .. ']\n' .. [[
APPLY:
	To take changes in effect restart game.
	Press [Ctrl-Alt-R] then [Enter].
WHAT TO DO:
	Make some fancy icon and replace the one, located in "]] .. CurrentModPath .. 'UI/%id%.png"\n\n' .. [[
"build_category" (allowed value is number from 1 to 15):]] .. '\n' .. TableToString(origMenuId) .. '\n\n'

local layoutSettings = {
	id = "SetIdForLayoutFile",
	display_name = "Display Name",
	description = "Layout Desctiption",
	build_category = 15,
	build_pos = 0,
}

-- function OnMsg.ClassesPostprocess()
-- end

-- Create Shortcuts
-- After this message ChoGGi's object is ready to use
function OnMsg.ModsReloaded()
	local Actions = ChoGGi.Temp.Actions
	
	Actions[#Actions + 1] = {ActionName = "Layout Capture",
		ActionId = "Layout.Capture",
		OnAction = CaptureLayout,
		ActionShortcut = ShortcutCapture,
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Save",
		ActionId = "Layout.Save",
		OnAction = SaveLayout,
		ActionShortcut = ShortcutSave,
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Clear Log",
		ActionId = "Layout.Clear.Log",
		OnAction = cls,
		ActionShortcut = "Insert",
		ActionBindable = true,
	}
end

function CaptureLayout()
	local OpenInObjectEditorDlg = ChoGGi.ComFuncs.OpenInObjectEditorDlg
	print("Layout Captured")
	OpenInObjectEditorDlg(layoutSettings)
	OpenExamine(GUIDE)
end

function SaveLayout()
	print("Layout Saved: " .. CurrentModPath .. "Layout\\".. layoutSettings.id .. ".lua")
	-- OpenExamine(layoutSettings)
end

-- get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- ChoGGi.ComFuncs.OpenInExamineDlg(ReturnAllNearby(1000, "class")) from ChoGGi's Library  v8.7
-- added 4th argument "class": only get objects inherited from class provided this argument
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


