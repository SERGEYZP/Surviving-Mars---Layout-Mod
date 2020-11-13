--[[
DELETE ME
'Depots' = BuildMenuSubcategory (len: Data, Depot)
'Lakes' = BuildMenuSubcategory (len: Data, Lake)
'LandscapeTextureBuildings' = BuildMenuSubcategory (len: Data, Change Surface)
'MechanizedDepots' = BuildMenuSubcategory (len: Data, Storage)
'Rovers' = BuildMenuSubcategory (len: Data, Rover)
]]

-- Ingame table with root menus, which appears on hotkey [B]:
-- Enhanced Cheat Menu -> Console -> ~BuildCategories

-- Ingame table with menu subcategories (example is [Depot] in [Storages]):
-- Enhanced Cheat Menu -> Console -> ~BuildMenuSubcategories

-- Empty menu is not visible. Add building, and menu will appear.

-- GlobalVar("g_MenuId", {"Layout1","Layout2",}) <- this line will not create object, but boolean == false :(
GlobalVar("g_MenuId", {})
local idPrefix = "Layout "
local descrSuffix = " Layouts"
-- Surviving Mars have 14 menus. Look in ~BuildCategories table.
local menuId = {
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
	[15] = "Default",
}

g_MenuId = {
	[1] = "Layout Default",
	[2] = "Layout Infrastructure",
}

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- get menus id and cook some new id for my new submenus
	for i,menu in ipairs(BuildCategories) do
		menuId[i] = idPrefix .. BuildCategories[i].id
	end
	table.insert(menuId, idPrefix .. "Default") -- default menu (in root menu by [B] key), place it after all menus.
	
	do
		local bc = BuildCategories
		-- local id = "LayoutDefault"
		local id = g_MenuId[1]
		if not table.find(bc, "id", id) then
			bc[#bc + 1] = {
				id = id,
				name = "Layouts",
				image = CurrentModPath .. "UI/MenuIcon.png",
				-- highlight = "UI/Icons/Buildings/dinner_shine.tga",
			}
		end
	end
	
	do
		local bmc = BuildMenuSubcategories
		-- local id = "LayoutStorages"
		local id = g_MenuId[2]
		if not table.find(bmc, "id", id) then
			bmc[id] = PlaceObj('BuildMenuSubcategory', {
				id = id,
				build_pos = 0,
				category = "Infrastructure",
				category_name = id,
				display_name = "Layout",
				-- description = "Infrastructure Layouts",
				icon = CurrentModPath .. "UI/MenuIcon.png",
				group = "Default",
				-- If the player can switch between the buildings of this subcategory
				-- using the “cycle visual variant” buttons (by default [ and ]).
				-- This is useful in cases like the “Depots” and “Storage” subcategory.
				-- It is far simpler to use the “cycle visual variant” keys, instead of
				-- going through the build menu, when placing multiple depots for different resources.
				-- allow_template_variants = true -- by default it's true
				-- action = function(self, context, button)
					-- OpenExamine(nil)
				-- end
			})
		end
	end
end