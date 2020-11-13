function OnMsg.ClassesPostprocess()
	if BuildingTemplates.Service_Slice_Simple then
		return
	end

	-- Info from ChoGGi's Layout Example
	PlaceObj("BuildingTemplate", {
		-- "Id, LayoutList, Group" must begin with capital letter!!!
		-- keep it unique folks 
		"Id", "Service_Slice_Simple",
		-- LayoutList id corresponds to the LayoutConstruction below
		"LayoutList", "Service_Slice_Simple",
		-- what group to add it to
		-- "Group", "Dome Services",
		-- "build_category", "Dome Services",
		-- "Group", "LayoutStorages",
		-- "build_category", "LayoutStorages",
		"Group", "Layout Infrastructure",
		"build_category", "Layout Infrastructure",
		-- pos in build menu
		"build_pos", 0,
		-- don't look at me (0 means no id, use in-game mod editor to generate ids)
		"display_name", "Service Slice Simple",
		"display_name_pl", "Service Slice Simple",
		"description", "Diner + Infirmary + Grocery + Statue",
		"display_icon", "UI/Icons/Buildings/dinner.tga",
		-- hands off
		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})
	
	-- PlaceObj('BuildMenuSubcategory', {
		-- "id", "Fixer.Menu",
		-- "display_name", "Fixer Menu",
		-- "icon", "UI/Icons/Buildings/dinner.tga",
		-- "description", "Description Fixer Menu",
		-- "build_pos", 0,
		-- "category", "Storages",
		-- "allow_template_variants", true,
		-- "close_parent", true,
		-- action = function(self, context, button)
				-- print("Selected Subcategory")
			-- end
	-- })

	PlaceObj("LayoutConstruction", {
		group = "Default",
		id = "Service_Slice_Simple",

		-- "template" -> String -> Class Template.
		--		Open: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Object" -> "Examine Object" (F4) -> "Tools" -> "Ged Editor".
		--		Open: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Object" -> "Open In Ged Objects Editor".
		--		Find: "Root Object" on left screen (Selected by default) -> "Misc" on right screen -> "Class Template".
		-- "pos" -> point(x,y) -> Relative position ("base point" of 3D model).
		--		By default (if you skip parameter) it will be point(0,0).
		--		Help: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Grids" -> "Toggle Building Grid Position" (Shift+F3).
		--		Help: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Object" -> "Examine Object" (F4) -> "Eye" icon ("Mark Object") on top of dialog window.
		--		Help: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Object" -> "Examine Object" (F4) -> "Object" -> "Hex Shape Toggle" -> "HexPeripheralShapes".
		--		"Mark" object to find out "base point" of 3D model (see above). You rotate building around base point. For example "Diner" has base point not on center of 3D model.
		--		Place all buildings. Choose in mind, where will be center of your layout. Find positions relative to center of layout.
		-- "dir" -> Integer -> Building direction.
		--		Possible values: 0-5. 1 click is 60 degree.
		--		Use keys "R" (counterclockwise) and "T" (clockwise) to rotate when build.
		--		Count: "dir" is how many times you press "T" key when build.
		--		Open: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Object" -> "Examine Object" (F4).
		--		Find: "GetAngle()" and divide it by 3600.
		-- "entity" -> String -> 3D model of building.
		--		Use keys "[" and "]" to cycle bitween visual variants when build.
		--		Open: "Enchanced Cheat Menu" (F2) -> "Debug" -> "Object" -> "Examine Object" (F4).
		--		Find: "GetEntity()" or "entity" field.
		--		Example: "Diner" building have default "entity" "Restaurant".
		-- "instant" -> Boolean -> Instant build.
		--		Possible values: true, false.
		--		Example: For "Universal Depot" must be "true".
		
		PlaceObj("LayoutConstructionEntry", {
			"template", "Diner",
			"dir", 5,
			"entity", "Restaurant",
		}),
		
		PlaceObj("LayoutConstructionEntry", {
			"template", "Infirmary",
			"pos", point(-2,2),
			"dir", 4,
			"entity", "Infirmary",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "ShopsFood",
			"pos", point(-1,0),
			"dir", 1,
			"entity", "ShopsFood",
		}),
		
		PlaceObj("LayoutConstructionEntry", {
			"template", "Statue",
			"pos", point(-2,3),
			"entity", "GardenStatue_01",
		}),	
	})

end
