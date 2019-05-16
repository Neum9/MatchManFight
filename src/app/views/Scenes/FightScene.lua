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

    self.m_tileMap = cc.TMXTiledMap:create("Tmx/Test1.tmx"):addTo(self)
end

return FightScene
