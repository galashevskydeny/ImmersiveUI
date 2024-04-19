local AceAddon = LibStub("AceAddon-3.0")
local addon = AceAddon:NewAddon("ImmersiveUI", "AceConsole-3.0", "AceEvent-3.0")

function addon:OnInitialize()
    -- Регистрация команды ShowChat
    self:RegisterChatCommand("ShowChat", "ShowChatCommand")
    self:RegisterChatCommand("HideChat", "HideChatCommand")
    self:RegisterChatCommand("ToggleChat", "ToggleChatCommand")
end

function addon:OnEnable()

    local key = "PADRSTICK" -- замените на интересующую вас клавишу
    local action = GetBindingAction(key)
    print("Действие, назначенное на клавишу " .. key .. ": " .. action)


    ChatFrame1:SetHeight(1)
    ChatFrame1:Hide()
    
    ChatFrame1ButtonFrame:Hide()
    QuickJoinToastButton:Hide()
    ChatFrame1:SetAlpha(0)

    ChatFrame1BottomTexture:SetHeight(1)
    ChatFrame1TopTexture:SetHeight(1)
    ChatFrame1Background:SetHeight(1)

    ChatFrame1EditBox:ClearAllPoints()
    ChatFrame1EditBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -40, 40)
    ChatFrame1EditBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 40, 0)

    SetCVar("chatBubbles", 0)
    SetCVar("ShowQuestUnitCircles", "0")
    SetCVar("ObjectSelectionCircle", "0")

    for i = 1, 50 do
        if _G["ChatFrame" .. i] then
            _G["ChatFrame" .. i]:SetClampedToScreen(false)
            _G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 0, 0)
        end
    end
    
    self:ToggleFrameAlpha(StatusTrackingBarManager)
    local function onMouseEnter()
        self:ToggleFrameAlpha(StatusTrackingBarManager)
    end

    local function onMouseLeave()
        self:ToggleFrameAlpha(StatusTrackingBarManager)
    end

    MainStatusTrackingBarContainer:SetScript("OnEnter", onMouseEnter)
    MainStatusTrackingBarContainer:SetScript("OnLeave", onMouseLeave)

end

function addon:ShowChatCommand()
    ChatFrame1:SetHeight(100)

    ChatFrame1:ClearAllPoints() -- Очищаем все текущие точки привязки
    ChatFrame1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 32) -- Устанавливаем новую точку привязки
    ChatFrame1:SetParent(UIParent)

    ChatFrame1:Show()

    self:ToggleFrameAlpha(ChatFrame1)
    self:ToggleFrameAlpha(VehicleSeatIndicator)

    ChatFrame1ButtonFrame:Show()

    UIParent_ManageFramePositions()

    for i = 1, 50 do
        if _G["ChatFrame" .. i] then
            _G["ChatFrame" .. i]:SetClampedToScreen(true)
            _G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 0, 0)
        end
    end
    
end

function addon:HideChatCommand()
    ChatFrame1:SetHeight(1)

    ChatFrame1:ClearAllPoints() -- Очищаем все текущие точки привязки
    ChatFrame1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, -4) -- Устанавливаем новую точку привязки
    ChatFrame1:SetParent(UIParent)

    ChatFrame1:Hide()
    ChatFrame1ButtonFrame:Hide()

    self:ToggleFrameAlpha(ChatFrame1)
    self:ToggleFrameAlpha(VehicleSeatIndicator)

    UIParent_ManageFramePositions()

    for i = 1, 50 do
        if _G["ChatFrame" .. i] then
            _G["ChatFrame" .. i]:SetClampedToScreen(false)
            _G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 0, 0)
        end
    end
end

function addon:ToggleChatCommand()

    -- Показать панель полетов на драконе
    self:ToggleFrameAlpha(EncounterBar)

    if ChatFrame1:GetHeight() <= 2 then
        -- Задержка перед показом чата
        C_Timer.After(0.2, function() self:ShowChatCommand() end)
    else
        -- Задержка перед скрытием чата
        C_Timer.After(0.1, function() self:HideChatCommand() end)
    end
end

-- Функция для изменения прозрачности фрейма на противоположное
function addon:ToggleFrameAlpha(frame)
    if not frame or type(frame) ~= "table" or not frame.IsObjectType or not frame:IsObjectType("Frame") then
        print("ToggleFrameAlpha: Неверный фрейм.")
        return
    end

    local duration = 0.2  -- Продолжительность анимации в секундах
    local currentAlpha = frame:GetAlpha()
    local endAlpha = currentAlpha > 0 and 0 or 1

    -- Если UIFrameFadeOut не работает как ожидается, попробуйте использовать этот код:
    -- frame:SetAlpha(endAlpha)

    UIFrameFadeOut(frame, duration, currentAlpha, endAlpha)
end

-- Глобальная ссылка на аддон
_G["ImmersiveUI"] = addon