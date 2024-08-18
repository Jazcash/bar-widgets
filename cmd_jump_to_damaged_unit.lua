function widget:GetInfo()
    return {
        name	= "Jump To Last Damaged Unit",
        desc	= "Adds a bindable action to jump to your last damaged unit and selects it",
        author  = "Jazcash",
        date 	= "August 2024",
        license	= "idklmao",
        layer 	= 0,
        enabled	= true,
        handler = true,
    }
end

local lastDamagedUnitId = nil

function widget:Initialize()
    widgetHandler.actionHandler:AddAction(self, "jumptolastdamaged", jumpToLastDamagedUnit, { true }, "p")
end

function widget:UnitDamaged(unitID, unitDefID)
	local unitAllyTeam = Spring.GetUnitAllyTeam(unitID)
    local myAllyTeam = Spring.GetMyAllyTeamID()

    if unitAllyTeam ~= myAllyTeam then
        return
    end

    lastDamagedUnitId = unitID
end

function jumpToLastDamagedUnit()
    if not lastDamagedUnitId then
        return
    end

    Spring.SelectUnitArray({lastDamagedUnitId})
    Spring.SetCameraTarget(Spring.GetUnitPosition(lastDamagedUnitId))
end