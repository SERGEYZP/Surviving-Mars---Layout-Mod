function OnMsg.ClassesPostprocess()
	if BuildingTemplates.SetIdForLayoutFile3 then
		return
	end

	local id = "SetIdForLayoutFile3"
	local build_category = "Layout Power"

	PlaceObj("BuildingTemplate", {
		"Id", id,
		"LayoutList", id,
		"Group", build_category,
		"build_category", build_category,
		"build_pos", 0,
		"display_name", "Display Name",
		"display_name_pl", "Display Name",
		"description", "Layout Desctiption",
		"display_icon", "UI/SetIdForLayoutFile3.png",
		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})

	PlaceObj("LayoutConstruction", {
		group = "Default",
		id = id,

		PlaceObj("LayoutConstructionEntry", {
			"template", "SolarPanelBig",
			"pos", point(0, 0),
			"dir", 0,
			"entity", "SolarPanelBig",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "SolarPanelBig",
			"pos", point(2, 0),
			"dir", 0,
			"entity", "SolarPanelBig",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "SolarPanelBig",
			"pos", point(1, -1),
			"dir", 5,
			"entity", "SolarPanelBig",
		}),

	})
end
