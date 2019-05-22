local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
end

function MyApp:run()
    --引用文件
    require("app.views.Utils.helpFunc")
    require("app.views.Infos.MatchManStatus")
    require("app.views.Infos.MatchManAnimes")
    require("app.views.Infos.MatchManDir")
    require("app.views.Managers.PlayerManager")

    -- body
    local startScene = require("app.views.Scenes.StartScene").new()
    --display.newScene(StartScene)
    display.runScene(startScene)
end

return MyApp
