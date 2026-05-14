-- ============================================
-- jx-blips - server.lua
-- Created by JamX Scripts
-- Licensed under GPL v3
-- ============================================

local BlipsData = {}
local NextId    = 1
local BlipsFile = Config.BlipsFile

local function DebugPrint(msg)
    if Config.Debug then print('[jx-blips] ' .. msg) end
end

-- Discord webhook log
local function SendDiscordLog(action, adminName, blipName, coords)
    if not Config.DiscordWebhook or Config.DiscordWebhook == '' then return end

    local colors = {
        ['created'] = 3066993,  -- green
        ['updated'] = 16776960, -- yellow
        ['deleted'] = 15158332  -- red
    }

    local description = string.format(
        '**Admin :** %s\n**Blip :** %s\n**Action :** %s\n**Coords :** %.1f, %.1f, %.1f',
        adminName,
        blipName,
        action,
        coords and coords.x or 0,
        coords and coords.y or 0,
        coords and coords.z or 0
    )

    local payload = json.encode({
        flags  = 4096,
        embeds = { {
            title       = '🗺️ jx-blips — Log',
            description = description,
            color       = colors[action] or 3447003,
            footer      = { text = os.date('%Y-%m-%d %H:%M:%S') }
        } }
    })

    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', payload, {
        ['Content-Type'] = 'application/json'
    })
end

-- Load blips from JSON file
local function LoadBlips()
    local file = LoadResourceFile(GetCurrentResourceName(), BlipsFile)
    if file and file ~= '' then
        local ok, data = pcall(json.decode, file)
        if ok and data and data.blips then
            BlipsData = {}
            for idStr, blip in pairs(data.blips) do
                local id = tonumber(idStr)
                if id then
                    if type(blip.coords) == 'table' then
                        blip.coords = {
                            x = tonumber(blip.coords.x) or 0.0,
                            y = tonumber(blip.coords.y) or 0.0,
                            z = tonumber(blip.coords.z) or 0.0
                        }
                    end
                    blip.scale         = tonumber(blip.scale) or Config.DefaultScale
                    blip.sprite        = tonumber(blip.sprite) or Config.DefaultSprite
                    blip.color         = tonumber(blip.color) or Config.DefaultColor
                    blip.alwaysVisible = (blip.alwaysVisible == nil) and Config.DefaultAlwaysVisible or
                    blip.alwaysVisible
                    BlipsData[id]      = blip
                end
            end
            NextId      = data.nextId or 1
            local count = 0
            for _ in pairs(BlipsData) do count = count + 1 end
            print(('[jx-blips] Loaded: %d blips'):format(count))
            return
        end
    end
    BlipsData = {}
    NextId    = 1
    print('[jx-blips] No save file found – starting fresh')
end

-- Save blips to JSON file
local function SaveBlips()
    local exportData = {}
    for id, blip in pairs(BlipsData) do
        exportData[tostring(id)] = {
            id            = blip.id,
            name          = blip.name,
            sprite        = blip.sprite,
            color         = blip.color,
            scale         = blip.scale,
            category      = blip.category or 0,
            alwaysVisible = blip.alwaysVisible,
            createdAt     = blip.createdAt,
            coords        = {
                x = blip.coords.x,
                y = blip.coords.y,
                z = blip.coords.z
            }
        }
    end
    local jsonString = json.encode({ blips = exportData, nextId = NextId }, { indent = true })
    SaveResourceFile(GetCurrentResourceName(), BlipsFile, jsonString, -1)
end

-- Add a new blip
function AddBlip(coords, sprite, color, scale, name, category, alwaysVisible)
    local id        = NextId
    NextId          = NextId + 1
    local safeScale = math.floor(((tonumber(scale) or Config.DefaultScale) * 100) + 0.5) / 100

    BlipsData[id]   = {
        id            = id,
        name          = tostring(name),
        sprite        = tonumber(sprite) or Config.DefaultSprite,
        color         = tonumber(color) or Config.DefaultColor,
        scale         = safeScale,
        category      = tonumber(category) or 0,
        alwaysVisible = (alwaysVisible == nil) and Config.DefaultAlwaysVisible or alwaysVisible,
        coords        = { x = coords.x, y = coords.y, z = coords.z },
        createdAt     = os.time()
    }

    SaveBlips()
    DebugPrint('Blip added id=' ..
    id ..
    ' name=' ..
    tostring(name) ..
    ' scale=' ..
    tostring(safeScale) .. ' category=' .. tostring(category) .. ' alwaysVisible=' .. tostring(alwaysVisible))
    TriggerClientEvent('jx-blips:refreshAll', -1, BlipsData)
    return id
end

-- Update an existing blip
function UpdateBlip(id, data)
    if not BlipsData[id] then return false end
    if data.name then BlipsData[id].name = tostring(data.name) end
    if data.sprite then BlipsData[id].sprite = tonumber(data.sprite) end
    if data.color then BlipsData[id].color = tonumber(data.color) end
    if data.scale then BlipsData[id].scale = math.floor(((tonumber(data.scale) or Config.DefaultScale) * 100) + 0.5) /
        100 end
    if data.category ~= nil then BlipsData[id].category = tonumber(data.category) or 0 end
    if data.alwaysVisible ~= nil then BlipsData[id].alwaysVisible = data.alwaysVisible end
    SaveBlips()
    TriggerClientEvent('jx-blips:refreshAll', -1, BlipsData)
    return true
end

-- Delete a blip
function DeleteBlip(id)
    if not BlipsData[id] then return false end
    BlipsData[id] = nil
    SaveBlips()
    TriggerClientEvent('jx-blips:refreshAll', -1, BlipsData)
    return true
end

-- Check if a player has admin access
local function IsAdmin(src)
    if not Config.AdminOnly then return true end
    return IsPlayerAceAllowed(src, 'jx-blips.admin')
end

local function GetAdminName(src)
    return GetPlayerName(src) or ('Player #' .. src)
end

-- Network events
RegisterNetEvent('jx-blips:requestList', function()
    TriggerClientEvent('jx-blips:receiveList', source, BlipsData)
end)

RegisterNetEvent('jx-blips:create', function(data)
    local src = source
    if not IsAdmin(src) then return end
    local sprite        = tonumber(data.sprite) or Config.DefaultSprite
    local color         = tonumber(data.color) or Config.DefaultColor
    local scale         = tonumber(tostring(data.scale)) or Config.DefaultScale
    local name          = tostring(data.name or 'Blip')
    local category      = tonumber(data.category) or 0
    local alwaysVisible = (data.alwaysVisible == nil) and Config.DefaultAlwaysVisible or data.alwaysVisible
    local coords        = GetEntityCoords(GetPlayerPed(src))
    local id            = AddBlip(coords, sprite, color, scale, name, category, alwaysVisible)
    TriggerClientEvent('jx-blips:operationResult', src, true, 'Blip created')
    SendDiscordLog('created', GetAdminName(src), name, coords)
end)

RegisterNetEvent('jx-blips:update', function(id, data)
    local src = source
    if not IsAdmin(src) then return end
    local cleaned = {}
    if data.name then cleaned.name = tostring(data.name) end
    if data.sprite then cleaned.sprite = tonumber(data.sprite) end
    if data.color then cleaned.color = tonumber(data.color) end
    if data.scale then cleaned.scale = tonumber(tostring(data.scale)) end
    if data.category ~= nil then cleaned.category = tonumber(data.category) or 0 end
    if data.alwaysVisible ~= nil then cleaned.alwaysVisible = data.alwaysVisible end
    local ok       = UpdateBlip(id, cleaned)
    local blipName = BlipsData[id] and BlipsData[id].name or tostring(id)
    local coords   = BlipsData[id] and BlipsData[id].coords or nil
    TriggerClientEvent('jx-blips:operationResult', src, ok, ok and 'Blip updated' or 'Blip not found')
    if ok then SendDiscordLog('updated', GetAdminName(src), blipName, coords) end
end)

RegisterNetEvent('jx-blips:delete', function(id)
    local src = source
    if not IsAdmin(src) then return end
    local blipName = BlipsData[id] and BlipsData[id].name or tostring(id)
    local coords   = BlipsData[id] and BlipsData[id].coords or nil
    local ok       = DeleteBlip(id)
    TriggerClientEvent('jx-blips:operationResult', src, ok, ok and 'Blip deleted' or 'Blip not found')
    if ok then SendDiscordLog('deleted', GetAdminName(src), blipName, coords) end
end)

RegisterNetEvent('jx-blips:teleport', function(id)
    local src = source
    if not IsAdmin(src) then return end
    local blip = BlipsData[id]
    if blip and blip.coords then
        SetEntityCoords(GetPlayerPed(src), blip.coords.x, blip.coords.y, blip.coords.z)
        TriggerClientEvent('jx-blips:operationResult', src, true, 'Teleported')
    else
        TriggerClientEvent('jx-blips:operationResult', src, false, 'Blip not found')
    end
end)

-- Init
LoadBlips()

AddEventHandler('onResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    -- Send blip list to all connected players on resource start
    for _, player in ipairs(GetPlayers()) do
        TriggerClientEvent('jx-blips:refreshAll', player, BlipsData)
    end
end)
