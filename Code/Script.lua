-- Build Menus --

-- Ingame table with root menus, which appears on hotkey [B]:
-- Enhanced Cheat Menu -> Console -> ~BuildCategories

-- Ingame table with menu subcategories (example is [Depot] in [Storages]):
-- Enhanced Cheat Menu -> Console -> ~BuildMenuSubcategories

-- Empty menu is not visible. Add building, and menu will appear.

-- GlobalVar("tmp", {"param1","param2",}) <- this line will not create object, but boolean == false :(
-- GlobalVar("tmp", {}) tmp = {[1] = "param1", [2] = "param2",} <- create empty object, add params

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
local GUIDE = [[

Capture
Save
Bla bla bla
]]
local extension = ".lua"
local layoutSettings = {
	_GUIDE_ = GUIDE,
	name = "SetNameForLayoutFile",
	description = "Describe layout",
	display_name = "Display Name",
	build_category = "",
	build_pos = 0,
}

-- function OnMsg.ClassesPostprocess()
-- end

-- After this message ChoGGi's object is ready to use (if you don't use dependencies)
function OnMsg.ModsReloaded()
	local Actions = ChoGGi.Temp.Actions
	
	Actions[#Actions + 1] = {ActionName = "Layout Capture",
		ActionId = "Layout.Capture",
		OnAction = CaptureLayout,
		ActionShortcut = "Insert",
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Save",
		ActionId = "Layout.Save",
		OnAction = SaveLayout,
		ActionShortcut = "Shift-Insert",
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Clear Log",
		ActionId = "Layout.Clear.Log",
		OnAction = cls,
		ActionShortcut = "Ctrl-Insert",
		ActionBindable = true,
	}
end

-- DefineClass.LayoutSettings = {
	-- _GUIDE_ = GUIDE,
	-- name = "SetNameForLayoutFile",
	-- description = "Describe layout",
	-- display_name = "Name above/under icon",
	-- build_category = "",
	-- build_pos = 0,
-- }

-- function LayoutSettings:Init()
	-- print("layoutSettings created.")
-- end

-- function LayoutSettings:GameInit()
	-- print("layoutSettings Game Initialized.")
-- end

-- function LayoutSettings:Done()
	-- print("layoutSettings deleted.")
	-- self.delete()
-- end

function CaptureLayout()
	print("Capture Layout")
	OpenExamine(layoutSettings)
end

function SaveLayout()
	print("Save Layout: " .. layoutSettings.name)
	OpenExamine(layoutSettings)
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