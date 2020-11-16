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
		"Code/Layout/Default - 00 - SetIdForLayoutFile.lua",
		"Code/Layout/Default - 00 - SetIdForLayoutFile1.lua",
		"Code/Layout/Infrastructure - 00 - Service_Slice_Simple.lua",
		"Code/Layout/Infrastructure - 00 - SetIdForLayoutFile2.lua",
		"Code/Layout/Power - 00 - SetIdForLayoutFile3.lua",
	},
	'saved', 1604768099,
	-- 'screenshot1', "",
	'TagTools', true,
	'TagOther', true,
})