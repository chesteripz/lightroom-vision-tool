local LrDialogs = import 'LrDialogs'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrLogger = import 'LrLogger'
local LrFileutils = import 'LrFileUtils'
local LrProgressScope = import 'LrProgressScope'

local JSON = require 'JSON'

local logger = LrLogger('HelloWorldPlugin')
logger:enable("print")
local log = logger:quickf('info')

local function getImageList(images)
    local list = ""
    for i, image in ipairs(images) do
        list = list .. ' "' .. image.path .. '"'
    end
    return list
end

local function startProcessing(photos)
    local prefs = LrPrefs.prefsForPlugin()
    local progress = LrProgressScope {
        title = "Image Classifier"
    }
    progress:setCaption("Classification in progress...")

    local cmd
    local tempfile = prefs.tempfile
    local threshold = prefs.threshold + 0.0
    local catalog = LrApplication.activeCatalog()
    cmd = '"' .. prefs.visionToolPath .. '" "' .. tempfile .. '" ' .. getImageList(photos)
    -- cmd = 'open -a ' .. '"' .. prefs.PureRawPath .. '"' .. ' ' .. getImageList(images)
    local status = LrTasks.execute(cmd)

    local result_str = LrFileutils.readFile(tempfile)
    local result = JSON:decode(result_str)
    local new_kw = {}
    local function createKeywords()
        for i, image in ipairs(photos) do
            if result[image.path] then
                for key, value in pairs(result[image.path]) do
                    if value > threshold then
                        new_kw[key] = catalog:createKeyword(key, {}, false, nil, true)
                    end
                end
            end
        end
    end

    progress:setCaption("Creating Keywords...")
    catalog:withWriteAccessDo('createKeywords', createKeywords)

    local function addKeywords()
        for i, image in ipairs(photos) do
            if result[image.path] then
                for key, value in pairs(result[image.path]) do
                    if value > threshold then
                        image:addKeyword(new_kw[key])
                    end
                end
            end
        end
    end

    progress:setCaption("Adding keywords to photos...")
    catalog:withWriteAccessDo('addKeywords', addKeywords)

    progress:done()
end

LrTasks.startAsyncTask(function()
    photos = LrApplication.activeCatalog():getTargetPhotos()
    if (#photos > 0) then
        startProcessing(photos)
    end

end)
