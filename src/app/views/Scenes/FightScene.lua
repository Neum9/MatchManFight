--
--  2019 5 15
--  cjc
--  战斗场景
--

local FightScene =
    class(
    "FightScene",
    function()
        return display.newScene("FightScene")
    end
)

function FightScene:ctor()
    self.m_mainView = cc.CSLoader:createNode("CCBRes/FightScene/csd/FightScene.csb"):addTo(self)

    -- 添加地图
    self.m_tileMap = cc.TMXTiledMap:create("Tmx/Test1.tmx"):addTo(self)

    -- 添加人物
    local matchMan = require("app.views.Nodes.MatchMan").new():addTo(self)
end

return FightScene
