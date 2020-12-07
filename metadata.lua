return PlaceObj('ModDef', {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 6,
		}),
		PlaceObj("ModDependency", {
			"id", "ChoGGi_CheatMenu",
			"title", "Expanded Cheat Menu",
			"version_major", 15,
			"version_minor", 6,
		}),
	},
	'title', "Layout Capture Mod",
	'description', "Capture and save building's layout.",
	'image', "Preview.png",
	'last_changes', "Initial release.",
	'id', "Kyklish_Layout_Capture_Mod",
	'steam_id', "9876543210",
	'pops_desktop_uuid', "2985b508-0ba0-4f20-8ff3-8bf242be35e3",
	'pops_any_uuid', "bbf577bf-dee0-4346-bad5-1037f6a827e7",
	'author', "Kyklish",
	'version_major', 1,
	'version_minor', 0,
	'version', 3,
	'lua_revision', 233360,
	'saved_with_revision', 249143,
	'code', {
		-- Main Code --
		"Code/Script.lua",
		-- All Captured Layouts --
		"Code/Layouts.lua",
	},
	'saved', 1604768099,
	'TagTools', true,
	'TagOther', true,
})