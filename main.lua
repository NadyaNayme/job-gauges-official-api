log("Loading Job Gauges...")

local uiMain = require("resources/ui/ui")
if not uiMain then
    error("Failed to load UI module")
end
local ui = uiMain.CreateUI()

function PluginShutdown()
  ui = nil
end
