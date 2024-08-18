function widget:GetInfo()
    return {
        name	= "Copy Building",
        desc	= "With a builder selected, activate this command to copy the building being hovered",
        author  = "Jazcash",
        date 	= "August 2024",
        license	= "idklmao",
        layer 	= 0,
        enabled	= true,
        handler = true,
    }
end

function widget:Initialize()
    widgetHandler.actionHandler:AddAction(self, "copybuilding", copyBuilding, { true }, "p")
end

function copyBuilding(key, mods, isRepeat)
    if not isBuilderSelected() then
        return
    end

    local mouseX, mouseY = Spring.GetMouseState()
    local _, unitId = Spring.TraceScreenRay(mouseX, mouseY, false, true)

    if not unitId then
        return
    end

    if type(unitId) ~= "number" then
        return
    end

    local unitDefId = Spring.GetUnitDefID(unitId)
    local unitDef = UnitDefs[unitDefId]

    if unitDef and unitDef.isBuilding then
        Spring.SetActiveCommand('buildunit_'..unitDef.name)
    end
end

function isBuilderSelected()
    local selectedUnits = Spring.GetSelectedUnits()
    if #selectedUnits ~= 1 then
        return false
    end

    for i = 1, #selectedUnits do
        local unitId = selectedUnits[i]
        local unitDefId = Spring.GetUnitDefID(unitId)
        local unitDef = UnitDefs[unitDefId]
        if unitDef.isBuilder then
            return true
        end
    end

    return false
end