function OnMsg.ClassesPostprocess()
	if BuildingTemplates.SetIdForLayoutFile1 then
		return
	end

	local id = "SetIdForLayoutFile1"
	local build_category = "Layout Default"

	PlaceObj("BuildingTemplate", {
		"Id", id,
		"LayoutList", id,
		"Group", build_category,
		"build_category", build_category,
		"build_pos", 0,
		"display_name", "Display Name",
		"display_name_pl", "Display Name",
		"description", "Layout Desctiption",
		"display_icon", "UI/SetIdForLayoutFile1.png",
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
