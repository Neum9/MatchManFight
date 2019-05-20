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

require("app.views.Infos.MatchManStatus")
require("app.views.Infos.MatchManAnimes")

function MatchMan:ctor()
    self:initValue()
    self:initControl()
    self:initProperty()

    --  debug
    self:setPosition(display.cx, display.cy)
end

function MatchMan:initValue()
    self.m_status = MatchManStatus.IDLE
    self.m_isJump = false
    self.m_isHurt = false
    self.m_isSquat = false
    --self.m_scheduler = cc.Director:getInstance():getScheduler()
    --self.m_scheduleID = nil
    self.m_moveAction = nil

    self.m_moveLeftKeyCode = cc.KeyCode.KEY_A
    self.m_moveRightKeyCode = cc.KeyCode.KEY_D
    self.m_jumpKeyCode = cc.KeyCode.KEY_W
    self.m_squatKeyCode = cc.KeyCode.KEY_S
end

function MatchMan:initProperty()
    self.m_speed = 8
end

function MatchMan:initControl()
    self.m_anim = cc.CSLoader:createNode("CCBRes/MatchMan/csd/MatchMan.csb"):addTo(self):setPosition(0, 0)
    self.m_timeLine = cc.CSLoader:createTimeline("CCBRes/MatchMan/csd/MatchMan.csb")

    self:runAction(self.m_timeLine)

    self.m_timeLine:play(MatchManAnimes.idle, true)

    --  键盘事件
    local listener = cc.EventListenerKeyboard:create()
    --  按下
    listener:registerScriptHandler(
        function(keyCode, event)
            --  移动
            self:FuncEventMoveRegister(keyCode, event)
            --  跳跃
            self:FuncEventJumpRegister(keyCode, event)
            --  蹲下
            self:FuncEventSquatRegister(keyCode, event)
        end,
        cc.Handler.EVENT_KEYBOARD_PRESSED
    )
    --  松开
    listener:registerScriptHandler(
        function(keyCode, event)
            --  停止移动
            self:FuncEventStopMoveRegister(keyCode, event)
        end,
        cc.Handler.EVENT_KEYBOARD_RELEASED
    )

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

--  移动事件监听
function MatchMan:FuncEventMoveRegister(keyCode, event)
    --  按下左右键 左右移动

    --  偏移量
    local offset = {0, 0}
    local isMove = true

    if keyCode == self.m_moveLeftKeyCode then
        offset[1] = offset[1] - 1
    elseif keyCode == self.m_moveRightKeyCode then
        offset[1] = offset[1] + 1
    else
        isMove = false
    end

    --  移动
    if isMove then
        self.m_moveAction = cc.RepeatForever:create((cc.MoveBy:create(0.1, cc.p(self.m_speed * offset[1], 0))))
        self:runAction(self.m_moveAction)
    end
end

--  松开左右键停止
function MatchMan:FuncEventStopMoveRegister(keyCode, event)
    if keyCode == self.m_moveLeftKeyCode or keyCode == self.m_moveRightKeyCode then
        self:stopAction(self.m_moveAction)
    end
end

--  跳跃事件监听
function MatchMan:FuncEventJumpRegister(keyCode, event)
    if keyCode == self.m_jumpKeyCode then
        print("Jump!")
    end
end

--  下蹲事件监听
function MatchMan:FuncEventSquatRegister(keyCode, event)
    if keyCode == self.m_squatKeyCode then
        print("Squat!")
    end
end

--  转换状态
function MatchMan:TurnToStatus(status)
    self.m_status = status
end

return MatchMan
