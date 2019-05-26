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
    require("app.views.Managers.AudioManager")

    --  music preload
    AudioEngine.preloadMusic("Music/click.mp3")

    -- body
    local startScene = require("app.views.Scenes.StartScene").new()
    --display.newScene(StartScene)
    display.runScene(startScene)
end

return MyApp
