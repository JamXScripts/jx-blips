-- ============================================
-- jx-blips - client.lua
-- Created by JamX Scripts
-- Licensed under GPL v3
-- ============================================

while lib == nil do Wait(50) end

local myBlips          = {}
local currentBlipsData = {}
local Lang             = Locales[Config.Locale] or Locales['en']

local function DebugPrint(msg)
    if Config.Debug then print('[jx-blips] ' .. msg) end
end

-- Category helpers
local function GetCategoryOptions()
    local options = { { value = 0, label = Lang['category_none'] } }
    for _, cat in ipairs(Config.BlipCategories) do
        table.insert(options, { value = cat.category, label = Lang[cat.label] or cat.label })
    end
    return options
end

local function GetCategoryLabel(categoryId)
    if not categoryId or categoryId == 0 then return Lang['category_none'] end
    for _, cat in ipairs(Config.BlipCategories) do
        if cat.category == categoryId then
            return Lang[cat.label] or cat.label -- fallback to key if translation is missing
        end
    end
    return Lang['category_none']
end

local function CreateBlip(data)
    local sprite     = tonumber(data.sprite) or 1
    local color      = tonumber(data.color) or 2
    local scale      = tonumber(data.scale) or 0.8
    local categoryId = tonumber(data.category) or 0
    local coords     = data.coords
    if not coords then return nil end
    local x = tonumber(coords.x) or 0.0
    local y = tonumber(coords.y) or 0.0
    local z = tonumber(coords.z) or 0.0

    local blip = AddBlipForCoord(x, y, z)
    if not blip then return nil end

    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipDisplay(blip, 2)
    SetBlipAsShortRange(blip, not data.alwaysVisible)

    if categoryId and categoryId > 0 then
        local label = GetCategoryLabel(categoryId)
        AddTextEntry('BLIP_CAT_' .. categoryId, label)
        SetBlipCategory(blip, categoryId)
    end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(data.name or "Blip")
    EndTextCommandSetBlipName(blip)
    return blip
end

local function RefreshAll(blips)
    -- Remove all existing blips from the map
    for _, blip in pairs(myBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    myBlips = {}
    if not blips then
        currentBlipsData = {}
        return
    end
    currentBlipsData = blips
    for id, data in pairs(blips) do
        local b = CreateBlip(data)
        if b then
            myBlips[id] = b
            DebugPrint('Blip created id=' .. tostring(id) .. ' name=' .. tostring(data.name))
        else
            print('[jx-blips] ERROR - Cannot create blip id=' .. tostring(id))
        end
    end
end

RegisterNetEvent('jx-blips:refreshAll', RefreshAll)
RegisterNetEvent('jx-blips:receiveList', RefreshAll)

RegisterNetEvent('jx-blips:operationResult', function(success, message)
    lib.notify({
        title       = success and Lang['success'] or Lang['error'],
        description = message,
        type        = success and "success" or "error"
    })
end)

-- Request blip list from server once the player ped is ready
CreateThread(function()
    while GetPlayerPed(PlayerId()) == 0 do Wait(100) end
    TriggerServerEvent('jx-blips:requestList')
    print('[jx-blips] Client ready')
end)

RegisterCommand('createblips', function()
    TriggerServerEvent('jx-blips:checkAdmin')
end)

RegisterNetEvent('jx-blips:adminAllowed', function()
    local opened = false
    local function OnReceive(blips)
        if opened then return end
        opened = true
        RefreshAll(blips)
        OpenMenu(currentBlipsData)
    end
    local originalHandler
    originalHandler = AddEventHandler('jx-blips:receiveList', function(blips)
        RemoveEventHandler(originalHandler)
        OnReceive(blips)
    end)
    TriggerServerEvent('jx-blips:requestList')
end)

function OpenMenu(blips)
    local options = {
        {
            title    = Lang['create_blip'],
            icon     = 'plus',
            onSelect = function()
                local categoryOptions = GetCategoryOptions()
                local input = lib.inputDialog(Lang['create_title'], {
                    { type = 'input',  label = Lang['name_label'],           default = Lang['default_blip_name'] },
                    { type = 'number', label = Lang['sprite_label'],         default = Config.DefaultSprite,                                                             min = 0,                              max = 1000 },
                    { type = 'number', label = Lang['color_label'],          default = Config.DefaultColor,                                                              min = 0,                              max = 100 },
                    { type = 'input',  label = Lang['scale_label'],          default = tostring(Config.DefaultScale) },
                    { type = 'select', label = Lang['category_label'],       options = categoryOptions },
                    { type = 'select', label = Lang['always_visible_label'], options = { { value = true, label = Lang['yes'] }, { value = false, label = Lang['no'] } }, default = Config.DefaultAlwaysVisible }
                })
                if not input then return end
                local categoryId    = tonumber(input[5]) or 0
                local alwaysVisible = (input[6] == true)
                DebugPrint('Creation : sprite=' ..
                    tostring(input[2]) .. ' scale=' .. tostring(input[4]) .. ' category=' .. tostring(categoryId))
                TriggerServerEvent('jx-blips:create', {
                    name          = input[1],
                    sprite        = tonumber(input[2]),
                    color         = tonumber(input[3]),
                    scale         = tonumber(input[4]),
                    category      = categoryId,
                    alwaysVisible = alwaysVisible
                })
            end
        },
        {
            title    = Lang['manage_blips'],
            icon     = 'list',
            onSelect = function()
                if not blips or next(blips) == nil then
                    lib.notify({ title = Lang['info'], description = Lang['no_blips'], type = 'info' })
                    return
                end
                local manageOptions = {}
                for id, data in pairs(blips) do
                    table.insert(manageOptions, {
                        title       = data.name,
                        description = string.format(Lang['blip_desc'], data.sprite, data.color, data.scale,
                            GetCategoryLabel(data.category)),
                        onSelect    = function()
                            lib.registerContext({
                                id      = 'blip_actions_' .. id,
                                title   = data.name,
                                options = {
                                    {
                                        title    = Lang['edit'],
                                        onSelect = function()
                                            local categoryOptions = GetCategoryOptions()
                                            local defaultCatIndex = 1
                                            for i, opt in ipairs(categoryOptions) do
                                                if opt.value == (data.category or 0) then
                                                    defaultCatIndex = i
                                                    break
                                                end
                                            end
                                            local edit = lib.inputDialog(Lang['edit_title'] .. data.name, {
                                                { type = 'input',  label = Lang['name_label'],           default = data.name },
                                                { type = 'number', label = Lang['sprite_label'],         default = data.sprite,                                                                      min = 0,                      max = 1000 },
                                                { type = 'number', label = Lang['color_label'],          default = data.color,                                                                       min = 0,                      max = 100 },
                                                { type = 'input',  label = Lang['scale_label'],          default = tostring(data.scale) },
                                                { type = 'select', label = Lang['category_label'],       options = categoryOptions,                                                                  default = defaultCatIndex - 1 },
                                                { type = 'select', label = Lang['always_visible_label'], options = { { value = true, label = Lang['yes'] }, { value = false, label = Lang['no'] } }, default = data.alwaysVisible }
                                            })
                                            if not edit then return end
                                            local categoryId    = tonumber(edit[5]) or 0
                                            local alwaysVisible = (edit[6] == true)
                                            TriggerServerEvent('jx-blips:update', id, {
                                                name          = edit[1],
                                                sprite        = tonumber(edit[2]),
                                                color         = tonumber(edit[3]),
                                                scale         = tonumber(edit[4]),
                                                category      = categoryId,
                                                alwaysVisible = alwaysVisible
                                            })
                                        end
                                    },
                                    {
                                        title    = Lang['teleport'],
                                        onSelect = function()
                                            TriggerServerEvent('jx-blips:teleport', id)
                                        end
                                    },
                                    {
                                        title    = Lang['delete'],
                                        onSelect = function()
                                            local isDeleting = false
                                            local confirm = lib.alertDialog({
                                                header  = Lang['confirm_delete'],
                                                content = string.format(Lang['delete_warning'], data.name),
                                                cancel  = true
                                            })
                                            if confirm == 'confirm' and not isDeleting then
                                                isDeleting = true
                                                TriggerServerEvent('jx-blips:delete', id)
                                            end
                                        end
                                    }
                                }
                            })
                            lib.showContext('blip_actions_' .. id)
                        end
                    })
                end
                lib.registerContext({ id = 'manage_blips_menu', title = Lang['manage_blips'], options = manageOptions })
                lib.showContext('manage_blips_menu')
            end
        }
    }
    lib.registerContext({ id = 'main_blips_menu', title = Lang['menu_title'], options = options })
    lib.showContext('main_blips_menu')
end
