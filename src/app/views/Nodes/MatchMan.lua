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
    self:initValue()
    self:initControl()
    self:initProperty()

    self:AnimeMonitor()

    --  debug
    self:setPosition(display.cx, display.cy)
    self:SetDir(MatchManDir.RIGHT)
    self:TurnToStatus(MatchManStatus.IDLE)
end

function MatchMan:initValue()
    self.m_id = 0
    self.m_status = MatchManStatus.IDLE
    self.m_dir = MatchManDir.LEFT
    self.m_isJump = false
    self.m_isHurt = false
    self.m_isSquat = false
    self.m_moveAction = nil
    self.m_isPressedLeft = false
    self.m_isPressedRight = false
    self.m_isPunch = false
    --  when punch,it cause damage
    self.m_isDamage = false

    self.m_moveLeftKeyCode = cc.KeyCode.KEY_A
    self.m_moveRightKeyCode = cc.KeyCode.KEY_D
    self.m_jumpKeyCode = cc.KeyCode.KEY_W
    self.m_squatKeyCode = cc.KeyCode.KEY_S
    self.m_punchKeyCode = cc.KeyCode.KEY_J
end

function MatchMan:initProperty()
    self.m_speed = 8
    self.m_health = 100
    -- attack power
    self.m_aggressivity = 20
    self.m_defensivePower = 10

    self.m_maxHealth = 100

    --health
    self.m_uiHealth = nil
end

function MatchMan:initControl()
    self.m_sprite = cc.CSLoader:createNode("CCBRes/MatchMan/csd/MatchMan.csb"):addTo(self):setPosition(0, 0)
    self.m_timeLine = cc.CSLoader:createTimeline("CCBRes/MatchMan/csd/MatchMan.csb")
    self:runAction(self.m_timeLine)
    self.m_boneBody = self.m_sprite:getChildByName("BoneBody")

    --self.m_timeLine:play(MatchManAnimes.idle, true)
    self.m_timeLine:play(MatchManAnimes.run, true)

    --  键盘事件
    local listener = cc.EventListenerKeyboard:create()
    --  按下
    listener:registerScriptHandler(
        function(keyCode, event)
            --  更新按键是否按下状态
            self:CheckPressKeyStatus(keyCode, true)
            --  移动
            self:FuncEventMoveRegister(keyCode, event)
            --  跳跃
            self:FuncEventJumpRegister(keyCode, event)
            --  蹲下
            self:FuncEventSquatRegister(keyCode, event)
            --  拳击
            self:FuncEventPunchRegister(keyCode, event)
        end,
        cc.Handler.EVENT_KEYBOARD_PRESSED
    )
    --  松开
    listener:registerScriptHandler(
        function(keyCode, event)
            --  更新按键是否按下状态
            self:CheckPressKeyStatus(keyCode, false)
            --  停止移动
            self:FuncEventStopMoveRegister(keyCode, event)
        end,
        cc.Handler.EVENT_KEYBOARD_RELEASED
    )

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function MatchMan:SetUIHealth(healthSlider)
    self.m_uiHealth = healthSlider
end

function MatchMan:UpdateUIHealth()
    self.m_uiHealth:setPercent(self.m_health / self.m_maxHealth * 100)
end

--  移动事件监听
function MatchMan:FuncEventMoveRegister(keyCode, event)
    --  按下左右键 左右移动

    --  偏移量
    local dir = nil

    if keyCode == self.m_moveLeftKeyCode then
        dir = MatchManDir.LEFT
    elseif keyCode == self.m_moveRightKeyCode then
        dir = MatchManDir.RIGHT
    end

    --  移动
    if dir then
        --  左右键未释放，先停止Action
        if self.m_moveAction ~= nil then
            self:stopAction(self.m_moveAction)
            self.m_moveAction = nil
        end

        self:SetDir(dir)
        self.m_moveAction = self:CreateMoveAction()
        self:StartOrStopMoveAction(true)
    end
end

--  松开左右键停止
function MatchMan:FuncEventStopMoveRegister(keyCode, event)
    if keyCode == self.m_moveLeftKeyCode or keyCode == self.m_moveRightKeyCode then
        --  有可能已经被停止了，加判断
        if self.m_moveAction ~= nil then
            self:StartOrStopMoveAction(false)
            --  移动Action置nil
            self.m_moveAction = nil

            --  检测是否还有左右按键未释放
            if self.m_isPressedLeft then
                self:SetDir(MatchManDir.LEFT)
                self.m_moveAction = self:CreateMoveAction()
                self:StartOrStopMoveAction(true)
            elseif self.m_isPressedRight then
                self:SetDir(MatchManDir.RIGHT)
                self.m_moveAction = self:CreateMoveAction()
                self:StartOrStopMoveAction(true)
            end
        end
    end
end

--  跳跃事件监听
function MatchMan:FuncEventJumpRegister(keyCode, event)
    if self.m_isJump or self.m_isPunch then
        return
    end

    if keyCode == self.m_jumpKeyCode then
        self.m_timeLine:play(MatchManAnimes.jump, false)
        self.m_isJump = true
    end
end

--  下蹲事件监听
function MatchMan:FuncEventSquatRegister(keyCode, event)
    if keyCode == self.m_squatKeyCode then
        print("Squat!")
    end
end

--  拳击事件监听
function MatchMan:FuncEventPunchRegister(keyCode, event)
    if self.m_isPunch or self.m_isJump then
        return
    end

    if keyCode == self.m_punchKeyCode then
        self.m_isPunch = true
        self.m_timeLine:play(MatchManAnimes.punch, false)
        self:Damage()
    end
end

--  转换状态 操作：更换动画
function MatchMan:TurnToStatus(status)
    self.m_status = status

    if self.m_status == MatchManStatus.IDLE then
        self.m_timeLine:play(MatchManAnimes.idle, true)
    elseif self.m_status == MatchManStatus.RUN then
        self.m_timeLine:play(MatchManAnimes.idleToRun, false)
    end
end

--  设置方向
function MatchMan:SetDir(dir)
    self.m_dir = dir
    if self.m_dir == MatchManDir.LEFT then
        self:setScaleX(-1)
    else
        self:setScaleX(1)
    end
end

--  获取奔跑动作
function MatchMan:CreateMoveAction()
    if self.m_dir == MatchManDir.LEFT then
        return cc.RepeatForever:create((cc.MoveBy:create(0.1, cc.p(self.m_speed * -1, 0))))
    else
        return cc.RepeatForever:create((cc.MoveBy:create(0.1, cc.p(self.m_speed * 1, 0))))
    end
end

--  按键按下状态，现在主要是左右按键
function MatchMan:CheckPressKeyStatus(keyCode, isPressed)
    if keyCode == self.m_moveLeftKeyCode then
        self.m_isPressedLeft = isPressed
    elseif keyCode == self.m_moveRightKeyCode then
        self.m_isPressedRight = isPressed
    end
end

--  开始或停止移动动作
function MatchMan:StartOrStopMoveAction(isStart)
    if isStart then
        self:runAction(self.m_moveAction)

        --  假如在跳跃过程中则不播放奔跑动画
        if not self.m_isJump and not self.m_isPunch then
            self:TurnToStatus(MatchManStatus.RUN)
        end
    else
        self:stopAction(self.m_moveAction)
        --  假如在跳跃过程中则不播放闲置动画
        if not self.m_isJump and not self.m_isPunch then
            self:TurnToStatus(MatchManStatus.IDLE)
        end
    end
end

--  动画帧事件监听
function MatchMan:AnimeMonitor()
    self.m_timeLine:setFrameEventCallFunc(
        (function(frame)
            local event = frame:getEvent()

            if event == MatchManAnimeEvents.idleEndToRun then
                --  闲置到奔跑的动画结束
                self.m_timeLine:play(MatchManAnimes.run, true)
            elseif event == MatchManAnimeEvents.jumpEnd then
                --  跳跃动画结束
                self.m_isJump = false
                --  落地后检测是否移动按键已经释放
                if self.m_isPressedLeft then
                    self:TurnToStatus(MatchManStatus.RUN)
                elseif self.m_isPressedRight then
                    self:TurnToStatus(MatchManStatus.RUN)
                else
                    self:TurnToStatus(MatchManStatus.IDLE)
                end
            elseif event == MatchManAnimeEvents.punchEnd then
                self.m_isPunch = false

                self:EndDamage()

                --  拳击后检测是否移动按键已经释放
                if self.m_isPressedLeft then
                    self:TurnToStatus(MatchManStatus.RUN)
                elseif self.m_isPressedRight then
                    self:TurnToStatus(MatchManStatus.RUN)
                else
                    self:TurnToStatus(MatchManStatus.IDLE)
                end
            elseif event == MatchManAnimeEvents.hurtEnd then
                --  拳击后检测是否移动按键已经释放
                if self.m_isPressedLeft then
                    self:TurnToStatus(MatchManStatus.RUN)
                elseif self.m_isPressedRight then
                    self:TurnToStatus(MatchManStatus.RUN)
                else
                    self:TurnToStatus(MatchManStatus.IDLE)
                end
            end
        end)
    )
end

--  set keyboard control
function MatchMan:SetControlKey(...)
    local arg = {...}
    self.m_moveLeftKeyCode = arg[1]
    self.m_moveRightKeyCode = arg[2]
    self.m_jumpKeyCode = arg[3]
    self.m_squatKeyCode = arg[4]
    self.m_punchKeyCode = arg[5]
end

function MatchMan:Hurt(otherMatchMan)
    print("player " .. self.m_id .. " hurt!")
    self.m_timeLine:play(MatchManAnimes.hurt, false)

    --decrease health
    local damage = otherMatchMan.m_aggressivity - self.m_defensivePower
    if damage > 0 then
        self.m_health = self.m_health - damage
        if self.m_health < 0 then
            self.m_health = 0
        end
        self:UpdateUIHealth()
        if self:JudgeDead() then
            print("Player"..self.m_id.."is dead")
        end
    end
end

function MatchMan:SetID(id)
    self.m_id = id
end

function MatchMan:IsDamage()
    return self.m_isDamage
end

function MatchMan:Damage()
    self.m_isDamage = true

    --  check hurt
    PlayerManager:getInstance():StartCheckHurt()
end

function MatchMan:EndDamage()
    self.m_isDamage = false
    PlayerManager:getInstance():StopCheckHurt()
end

function MatchMan:GetAggressivity()
    return self.m_aggressivity
end

function MatchMan:GetDefensivePower()
    return self.m_defensivePower
end

function MatchMan:JudgeDead()
    return self.m_health <= 0
end

return MatchMan
