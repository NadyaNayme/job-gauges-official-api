local localization = require("resources/data/localization")

local M = {}

local currentLanguage = "de"

local clientLanguage = game.options.Language.setting
if clientLanguage == 1 then
    currentLanguage = "de"
elseif clientLanguage == 2 then
    currentLanguage = "fr"
elseif clientLanguage == 3 then
    currentLanguage = "pt"
end

function M.SetLanguage(language)
    if localization[language] then
        currentLanguage = language
    else
        currentLanguage = "en"
    end
end

function M.Get(key)
    local value = localization[currentLanguage]

    for part in string.gmatch(key, "[^.]+") do
        if type(value) ~= "table" then
            return key
        end

        value = value[part]

        if value == nil then
            return key
        end
    end

    if type(value) ~= "string" then
        return key
    end

    return value
end

return M