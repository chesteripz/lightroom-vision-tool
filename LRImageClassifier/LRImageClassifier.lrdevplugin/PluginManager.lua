local LrPrefs = import 'LrPrefs'
local LrView = import "LrView"
local LrHttp = import "LrHttp"
local bind = import "LrBinding"
local app = import 'LrApplication'

local function getOrDefault(value, default)
    if value == nil then
        return default
    end
    return value
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

PluginManager = {}

function PluginManager.sectionsForTopOfDialog(viewFactory, properties)
    -- local f = viewFactory;

    local f = LrView.osFactory();
    local prefs = LrPrefs.prefsForPlugin();

    if (prefs.tempfile == nil or prefs.tempfile == "") then
        prefs.tempfile = "/tmp/lrimageclassifier.json"
    end

    if (prefs.threshold == nil or prefs.threshold == "") then
        prefs.threshold = "0.9"
    end

    if (prefs.visionToolPath == nil or prefs.visionToolPath == "") then
        prefs.visionToolPath = "/usr/local/bin/vision-tool"
    end
    

    local r = f:row{
        spacing = f:control_spacing(),
        f:static_text{
            title = 'Vision Tool Path:',
            alignment = 'left'
            -- fill_horizontal = 1,
        },
        f:edit_field{
            immediate = true,
            value_to_string = true,
            alignment = 'left',
            fill_horizontal = 1,
            value = LrView.bind('visionToolPath')
        
        }
    }

    local t = f:row{
        spacing = f:control_spacing(),
        f:static_text{
            title = 'Threshold:',
            alignment = 'left'
            -- fill_horizontal = 1,
        },
        f:edit_field{
            immediate = true,
            -- value_to_string = true,
            alignment = 'left',
            fill_horizontal = 1,
            value = LrView.bind('threshold')
        }
    }

    local u = f:row{
        spacing = f:control_spacing(),
        f:static_text{
            title = 'Tempfile:',
            alignment = 'left'
            -- fill_horizontal = 1,
        },
        f:edit_field{
            immediate = true,
            value_to_string = true,
            alignment = 'left',
            fill_horizontal = 1,
            value = LrView.bind('tempfile')
        }
    }

    local s = {
        title = "LR Image Classifier",
        bind_to_object = prefs,
        r,
        u,
        t,
    }

    return {s}
end

local function endDialog(properties)
    local prefs = LrPrefs.prefsForPlugin()
    prefs.visionToolPath = trim(properties.visionToolPath)
end

return {
    sectionsForTopOfDialog = sectionsForTopOfDialog,
    endDialog = endDialog
}
