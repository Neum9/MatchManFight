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

    self:AddPlayer()
    self:AddMap()
end

function FightScene:AddPlayer()
    -- 添加2个人物
    local matchMan1 = require("app.views.Nodes.MatchMan").new():addTo(self)
    local matchMan2 = require("app.views.Nodes.MatchMan").new():addTo(self)

    --  debug
    --  MatchMan 1
    matchMan1:SetID(1)
    matchMan1:SetDir(MatchManDir.RIGHT)
    matchMan1:setPositionX(display.cx - 200)
    matchMan1:SetControlKey(cc.KeyCode.KEY_A, cc.KeyCode.KEY_D, cc.KeyCode.KEY_W, cc.KeyCode.KEY_S, cc.KeyCode.KEY_J)

    --MatchMan 2
    matchMan1:SetID(2)
    matchMan2:SetDir(MatchManDir.LEFT)
    matchMan2:setPositionX(display.cx + 200)
    matchMan2:SetControlKey(
        cc.KeyCode.KEY_LEFT_ARROW,
        cc.KeyCode.KEY_RIGHT_ARROW,
        cc.KeyCode.KEY_UP_ARROW,
        cc.KeyCode.KEY_DOWN_ARROW,
        cc.KeyCode.KEY_1
    )

    PlayerManager:getInstance():AddPlayer(matchMan1)
    PlayerManager:getInstance():AddPlayer(matchMan2)

    -- cc.Director:getInstance():getScheduler():scheduleScriptFunc(
    --     function()
    --         local bound1 = matchMan1.m_sprite:getBoundingBox()
    --         local x1, y1 = matchMan1:getPosition()
    --         bound1.x = bound1.x + x1
    --         bound1.y = bound1.y + y1

    --         local bound2 = matchMan2.m_sprite:getBoundingBox()
    --         local x2, y2 = matchMan2:getPosition()
    --         bound2.x = bound2.x + x2
    --         bound2.y = bound2.y + y2

    --         local isContact = cc.rectIntersectsRect(bound1, bound2)
    --         if isContact then
    --             print("isContact")
    --         end
    --     end,
    --     0.02,
    --     false
    -- )
end

function FightScene:AddMap()
    -- 添加地图
    self.m_tileMap = cc.TMXTiledMap:create("Tmx/Test1.tmx"):addTo(self)
end

return FightScene
