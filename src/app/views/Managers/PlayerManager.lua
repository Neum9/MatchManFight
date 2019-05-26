--[[
    author:{Cjc}
    time:2019-05-22 17:32:02
    info:   it`s a singleton
]]
PlayerManager = {}

function PlayerManager:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self:InitValue()

    return o
end

function PlayerManager:getInstance()
    if self.m_instance == nil then
        self.m_instance = self:new()
    end

    return self.m_instance
end

function PlayerManager:InitValue()
    self.m_playerList = {}

    --  check hurt
    self.m_checkHurtScheduleID = nil
end

function PlayerManager:AddPlayer(player)
    table.insert(self.m_playerList, player)
end

--  check hurt between players, only 2 player
function PlayerManager:StartCheckHurt()
    if self.m_checkHurtScheduleID ~= nil then
        return
    end

    local t = not self.m_playerList[1].m_isDamage and not self.m_playerList[2].m_isDamage

    if not self.m_playerList[1].m_isDamage and not self.m_playerList[2].m_isDamage then
        return
    end

    self.m_checkHurtScheduleID =
        cc.Director:getInstance():getScheduler():scheduleScriptFunc(
        function()
            local bound1 = self.m_playerList[1].m_sprite:getBoundingBox()
            local x1, y1 = self.m_playerList[1]:getPosition()
            bound1.x = bound1.x + x1
            bound1.y = bound1.y + y1

            local bound2 = self.m_playerList[2].m_sprite:getBoundingBox()
            local x2, y2 = self.m_playerList[2]:getPosition()
            bound2.x = bound2.x + x2
            bound2.y = bound2.y + y2

            local isContact = cc.rectIntersectsRect(bound1, bound2)
            if isContact then
                --  check who is the attacker
                if self.m_playerList[1]:IsDamage() then
                    self.m_playerList[1]:EndDamage()
                    self.m_playerList[2]:Hurt()
                elseif self.m_playerList[1]:IsDamage() then
                    self.m_playerList[2]:EndDamage()
                    self.m_playerList[1]:Hurt()
                end
            end
        end,
        0.02,
        false
    )
end

function PlayerManager:StopCheckHurt()
    if self.m_checkHurtScheduleID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_checkHurtScheduleID)
        self.m_checkHurtScheduleID = nil
    end
end
