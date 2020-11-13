local GUIDE = [[

Capture
Save
Bla bla bla
]]
local extension = ".lua"
GlobalVar("layoutSettings", {
	name = "Name",
})

-- local layoutSettings = {
	-- _GUIDE_ = GUIDE,
	-- mod_path = CurrentModPath,
	-- name = "SetNameForLayoutFile",
	-- description = "Describe layout",
	-- display_name = "Display Name",
	-- build_category = "",
	-- build_pos = 0,
-- }

-- function OnMsg.ClassesPostprocess()
	-- GlobalVar("layoutSettings", LayoutSettings:new())
-- end

-- use this message to perform post-built actions on the final classes
-- function OnMsg.ClassesBuilt()
	-- add build cat for my items
	-- local bc = BuildCategories
	-- if not table.find(bc, "id", "Fixer") then
		-- bc[#bc+1] = {
			-- id = "Fixer",
			-- name = "Layout",
			-- image = "UI/Icons/Buildings/dinner.tga",
		-- }
	-- end
-- end

-- after this message ChoGGi's object is ready to use (if you don't use dependencies)
function OnMsg.ModsReloaded()
	local Actions = ChoGGi.Temp.Actions
	
	Actions[#Actions + 1] = {ActionName = "Layout Capture",
		ActionId = "Fixer.Layout.Capture",
		OnAction = CaptureLayout,
		ActionShortcut = "Insert",
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Save",
		ActionId = "Fixer.Layout.Save",
		OnAction = SaveLayout,
		ActionShortcut = "Shift-Insert",
		ActionBindable = true,
	}
	
	Actions[#Actions + 1] = {ActionName = "Layout Clear Log",
		ActionId = "Fixer.Layout.Clear.Log",
		OnAction = cls,
		ActionShortcut = "Ctrl-Insert",
		ActionBindable = true,
	}
end

-- DefineClass.LayoutSettings = {
	-- _GUIDE_ = GUIDE,
	-- mod_path = CurrentModPath,
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