--
--  2019 5 15
--  cjc
--  开始场景
--

local StartScene =
    class(
    "StartScene",
    function()
        return display.newScene("StartScene")
    end
)

function StartScene:ctor()
    self.mainView = cc.CSLoader:createNode("CCBRes/StartScene/csd/Start.csb")
    self:addChild(self.mainView)

    self:getComponent()
    self:onEvent()
end

function StartScene:getComponent()
    self.m_startGameButton = self.mainView:getChildByName("StartGameButton")
end

function StartScene:onEvent()
    self.m_startGameButton:addTouchEventListener(
        function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
            elseif eventType == ccui.TouchEventType.moved then
                -- body
            elseif eventType == ccui.TouchEventType.ended then
                local fightScene = require("app.views.Scenes.FightScene").new()
                display.runScene(fightScene)
            elseif eventType == ccui.TouchEventType.canceled then
            end
        end
    )
    -- display.setImageClick(
    --     self.m_startGameButton,
    --     handler(
    --         self,
    --         function()
    --             -- body

    --         end
    --     )
    -- )
end

return StartScene
