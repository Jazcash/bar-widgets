function widget:GetInfo()
    return {
        name	= "Append Factory Units",
        desc	= "By holding space, you can append a factory order to the end of the queue that will be removed once finished. Only useful if repeat is on.",
        author  = "Jazcash",
        date 	= "August 2024",
        license	= "idklmao",
        layer 	= 0,
        enabled	= true
    }
end

VFS.Include('luarules/configs/customcmds.h.lua')

local appends = {}

function widget:CommandNotify(id, params, options)
    local factoryId = getSingleFactory()
    local unitDefId = math.abs(id)

    if not factoryId then
        return
    end

    if id == CMD_STOP_PRODUCTION then
        if factoryId then
            appends[factoryId] = nil
        end
        return
    end

    if id >= 0 then
        return
    end

    if not appends[factoryId] then
        appends[factoryId] = {}
    end

    if not appends[factoryId][unitDefId] then
        appends[factoryId][unitDefId] = 0
    end

    local amount = 1

    if options.shift and not options.ctrl then
        amount = 5
    elseif not options.shift and options.ctrl then
        amount = 20
    elseif options.shift and options.ctrl then
        amount = 100
    end

    if options.right then
        amount = amount * -1
    elseif not options.right and not options.meta then
        amount = 0
    end

    appends[factoryId][unitDefId] = appends[factoryId][unitDefId] + amount

    Spring.GiveOrderToUnit(factoryId, -unitDefId, {}, options)

    return true
end

function widget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
    if not appends[factID] then
        return
    end

    if not appends[factID][unitDefID] or appends[factID][unitDefID] <= 0 then
        appends[factID][unitDefID] = nil
        return
    end

    appends[factID][unitDefID] = appends[factID][unitDefID] - 1

    Spring.GiveOrderToUnit(factID, -unitDefID, {}, { "right" })
end

function getSingleFactory()
	local selUnits = Spring.GetSelectedUnits()
    
	if #selUnits ~= 1 then
		return nil, nil
	end

	local unitDefID = Spring.GetUnitDefID(selUnits[1])
    local unitDef = UnitDefs[unitDefID]

	if not unitDef.isFactory then
		return nil, nil
	else
		return selUnits[1]
	end
end