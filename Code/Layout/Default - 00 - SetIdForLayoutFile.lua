function OnMsg.ClassesPostprocess()
	if BuildingTemplates.SetIdForLayoutFile then
		return
	end

	local id = "SetIdForLayoutFile"
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
		"display_icon", "UI/SetIdForLayoutFile.png",
		"template_class", "LayoutConstructionBuilding",
		"entity", "InvisibleObject",
		"construction_mode", "layout",
	})

	PlaceObj("LayoutConstruction", {
		group = "Default",
		id = id,

		PlaceObj("LayoutConstructionEntry", {
			"template", "FuelFactory",
			"pos", point(0, 0),
			"dir", 4,
			"entity", "FuelRefinery",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "RechargeStation",
			"pos", point(-1, -1),
			"dir", 0,
			"entity", "RechargeStation",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "StorageFuel",
			"pos", point(0, -2),
			"dir", 0,
			"entity", "StorageDepotSmall_06",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(6, -4),
			"dir", 5,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(7, -3),
			"dir", 0,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "Battery_WaterFuelCell",
			"pos", point(-1, -6),
			"dir", 0,
			"entity", "FuelCell",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(6, -7),
			"dir", 5,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(7, -6),
			"dir", 0,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "Battery_WaterFuelCell",
			"pos", point(-1, -7),
			"dir", 0,
			"entity", "FuelCell",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(9, -5),
			"dir", 5,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(9, -6),
			"dir", 4,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "Battery_WaterFuelCell",
			"pos", point(-1, -8),
			"dir", 0,
			"entity", "FuelCell",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(9, -8),
			"dir", 5,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(10, -4),
			"dir", 0,
			"entity", "WindTurbine",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "Battery_WaterFuelCell",
			"pos", point(-1, -9),
			"dir", 0,
			"entity", "FuelCell",
		}),

		PlaceObj("LayoutConstructionEntry", {
			"template", "WindTurbine",
			"pos", point(10, -10),
			"dir", 0,
			"entity", "WindTurbine",
		}),

	})
end
