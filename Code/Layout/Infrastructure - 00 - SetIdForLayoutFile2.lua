function OnMsg.ClassesPostprocess()
	if BuildingTemplates.SetIdForLayoutFile2 then
		return
	end

	local id = "SetIdForLayoutFile2"
	local build_category = "Layout Infrastructure"

	PlaceObj("BuildingTemplate", {
		"Id", id,
		"LayoutList", id,
		"Group", build_category,
		"build_category", build_category,
		"build_pos", 0,
		"display_name", "Display Name",
		"display_name_pl", "Display Name",
		"description", "Layout Desctiption",
		"display_icon", "UI/SetIdForLayoutFile2.png",
		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})

	PlaceObj("LayoutConstruction", {
		group = "Default",
		id = id,

		PlaceObj("LayoutConstructionEntry", {
			"template", "UniversalStorageDepot",
			"pos", point(0, 0),
			"dir", 0,
			"entity", "StorageDepot",
			"instant", true,
		}),

	})
end
