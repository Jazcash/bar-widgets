function widget:GetInfo()
    return {
        name	= "Select Previous",
        desc	= "Adds a bindable action to select whatever was selected before the current selection",
        author  = "Jazcash",
        date 	= "August 2024",
        license	= "idklmao",
        layer 	= 0,
        enabled	= true,
        handler = true,
    }
end

local currentSelection = {}
local lastSelection = {}

function widget:Initialize()
    widgetHandler.actionHandler:AddAction(self, "selectprevious", selectPrevious, { true }, "p")
end

function widget:SelectionChanged(selectedUnits)
    if #selectedUnits == 0 then
        return
    end

    lastSelection = currentSelection
    currentSelection = selectedUnits
end

function selectPrevious()
    Spring.SelectUnitArray(lastSelection)
    Spring.SendCommands("viewselection")
end
