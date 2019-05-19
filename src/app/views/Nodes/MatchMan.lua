--[[
    author:{Cjc}
    time:2019-05-19 23:11:59
]]
local MatchMan =
    class(
    "MatchMan",
    function()
        return display.newNode()
    end
)

function MatchMan:ctor()
    self.m_anim =
        cc.CSLoader:createNode("CCBRes/MatchMan/csd/MatchMan.csb"):addTo(self):setPosition(display.cx, display.cy)

    local timeLine = cc.CSLoader:createTimeline("CCBRes/MatchMan/csd/MatchMan.csb")

    self:runAction(timeLine)

    --timeLine:gotoFrameAndPlay(0, 60, false)
    timeLine:play("idle", true)
end

return MatchMan
