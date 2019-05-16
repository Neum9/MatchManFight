
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
end

function MyApp:run( )
    -- body
    local startScene = require("app.views.Scenes.StartScene").new()
    --display.newScene(StartScene)
    display.runScene(startScene)
end

return MyApp
