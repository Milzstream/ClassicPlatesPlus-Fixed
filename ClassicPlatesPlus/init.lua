----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- HANDLING EVENTS
----------------------------------------
function core:init(event, ...)
    local arg = ...;

    if event == "VARIABLES_LOADED" then
        func:CVars(event);
    end

    if event == "ADDON_LOADED" then
        if arg == myAddon then
            func:Load_Settings();
        end
    end

    if event == "CVAR_UPDATE" then
        local cvarName, value = ...;

        func:Update_CVars(cvarName, value);
    end

    if event == "UI_SCALE_CHANGED"
    or event == "DISPLAY_SIZE_CHANGED" then
        func:ResizeNameplates();
    end

    if event == "MODIFIER_STATE_CHANGED" then
        local nameplate = data.nameplate;
        local key, down = ...;

        if down == 0 then
            nameplate.isMoving = false;
        end

        nameplate:EnableMouse((key == "LCTRL" or key == "RCTRL") and down == 1);
    end

    if event == "PLAYER_ENTERING_WORLD" then
        func:ClassBarHeight();
        func:Update_Roster();
        func:PersonalNameplateCreate();
        if not data.isRetail then
            func:PersonalNameplateAdd();
        end
    end

    if event == "PLAYER_LOGOUT" then
        func:CVars(event);
    end

    if event == "PLAYER_TARGET_CHANGED" then
        local CFG = CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];

        func:myTarget();
        func:Update_Colors();
        func:Update_Auras("target");
    end

    if event == "PLAYER_FLAGS_CHANGED" then
        func:Update_healthbar(arg);
    end

    if event == "PLAYER_GUILD_UPDATE" then
        if arg and string.match(arg, "nameplate") then
            func:Update_Guild(arg);
            func:Update_FellowshipBadge(arg);
        end
    end

    if event == "PLAYER_DEAD"
    or event == "PLAYER_UNGHOST"
    or event == "PLAYER_ALIVE" then
        if not data.isRetail then
            func:ToggleNameplatePersonal(event);
        end
    end

    if event == "PLAYER_REGEN_ENABLED"
    or event == "PLAYER_REGEN_DISABLED" then
        if not data.isRetail then
            func:ToggleNameplatePersonal(event);
        end
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" then
        if arg == "player" then
            func:PersonalNameplateAdd();
        end
    end

    if event == "PLAYER_TOTEM_UPDATE" then
        func:Update_ClassPower();
    end

    if event == "UPDATE_SHAPESHIFT_FORM" then
        func:ClassBarHeight();
        func:PersonalNameplateAdd();
        if UnitExists("target") then
            local nameplate = C_NamePlate.GetNamePlateForUnit("target");

            if nameplate then
                func:PositionAuras(nameplate.unitFrame);
            end
        end
    end

    if event == "TALENT_GROUP_ROLE_CHANGED" then
        local groupIndex, newRole = ...;
        func:Update_Role(groupIndex, newRole);
    end

    if event == "NAME_PLATE_CREATED" then
        func:Nameplate_Created(arg);
    end

    if event == "NAME_PLATE_UNIT_ADDED" then
        func:Nameplate_Added(arg);
    end

    if event == "NAME_PLATE_UNIT_REMOVED" then
        func:Nameplate_Removed(arg);
    end

    if event == "UNIT_CLASSIFICATION_CHANGED" then
        func:Update_Classification(arg);
    end

    if event == "UNIT_HEALTH" then
        func:Update_Health(arg);
    end

    if event == "UNIT_MAXHEALTH" then
        func:Update_Health(arg);
        func:Update_healthbar(arg);
    end

    if event == 'UNIT_HEAL_PREDICTION' then
        func:PredictHeal(arg);
    end

    if event == "UNIT_POWER_FREQUENT" then
        func:Update_Power(arg);
        func:Update_ClassPower(arg);
    end

    if event == "UNIT_MAXPOWER" then
        func:Update_Power(arg);
    end

    if event == "UNIT_AURA" then
        func:Update_Auras(arg);
        if arg == "player" then
            func:Update_ExtraBar();
        end
    end

    if event == "UNIT_THREAT_LIST_UPDATE" then
        func:Update_Threat(arg)
    end

    if event == "UNIT_THREAT_SITUATION_UPDATE" then
        func:Update_Threat(arg);
    end

    if event == "UNIT_FACTION" then
        func:Update_healthbar(arg);
        func:Update_Portrait(arg);
        func:Update_Name(arg);
        func:Update_Colors(arg);
        func:Nameplate_Added(arg);
        func:Update_PVP_Flag(arg);
    end

    if event == "UNIT_PORTRAIT_UPDATE" then
        func:Update_Portrait(arg);
        func:Update_Power(arg);
    end

    if event == "UNIT_NAME_UPDATE" then
        func:Update_Name(arg);
    end

    if event == "UNIT_LEVEL" then
        func:Update_Level(arg);
    end

    if event == "UNIT_COMBAT" then
        func:Update_Name(arg);
        func:Update_healthbar(arg);
        func:Update_Name(arg);
        func:Update_Colors(arg);
    end

    if event == "UNIT_SPELLCAST_START"
    or event == "UNIT_SPELLCAST_CHANNEL_START"
    or event == "UNIT_SPELLCAST_DELAYED"
    or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
        func:Castbar_Start(event, arg);
    end

    if event == "UNIT_SPELLCAST_STOP"
    or event == "UNIT_SPELLCAST_CHANNEL_STOP"
    or event == "UNIT_SPELLCAST_FAILED"
    or event == "UNIT_SPELLCAST_FAILED_QUIET"
    or event == "UNIT_SPELLCAST_INTERRUPTED"
    or event == "UNIT_SPELLCAST_SUCCEEDED" then
        func:Castbar_End(event, arg);
    end

    if event == "GROUP_ROSTER_UPDATE" then
        func:Update_Roster();
        func:Update_FellowshipBadge();
    end

    if event == "RAID_TARGET_UPDATE" then
        func:RaidTargetIndex();
    end

    if event == "QUEST_LOG_UPDATE" then
        func:Update_quests();
    end

    if event == "FRIENDLIST_UPDATE" then
        func:Update_FellowshipBadge();
    end
end

----------------------------------------
-- Registering events
----------------------------------------
local events = CreateFrame("Frame");

-- Player
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("VARIABLES_LOADED");
events:RegisterEvent("NAME_PLATE_CREATED");
events:RegisterEvent("NAME_PLATE_UNIT_ADDED");
events:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
events:RegisterEvent("PLAYER_ENTERING_WORLD");
events:RegisterEvent("PLAYER_LOGOUT");
events:RegisterEvent("PLAYER_FLAGS_CHANGED");
events:RegisterEvent("PLAYER_TARGET_CHANGED");
events:RegisterEvent("PLAYER_REGEN_ENABLED");
events:RegisterEvent("PLAYER_REGEN_DISABLED");
events:RegisterEvent("PLAYER_GUILD_UPDATE");
events:RegisterEvent("PLAYER_DEAD");
events:RegisterEvent("PLAYER_ALIVE");
events:RegisterEvent("PLAYER_UNGHOST");
if data.isRetail then
    events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
end
events:RegisterEvent("QUEST_LOG_UPDATE");
events:RegisterEvent("PLAYER_TOTEM_UPDATE");

-- Unit
events:RegisterEvent("UNIT_NAME_UPDATE");
events:RegisterEvent("UNIT_PORTRAIT_UPDATE");
events:RegisterEvent("UNIT_HEALTH");
events:RegisterEvent("UNIT_MAXHEALTH");
events:RegisterEvent("UNIT_HEAL_PREDICTION");
events:RegisterEvent("UNIT_POWER_FREQUENT");
events:RegisterEvent("UNIT_MAXPOWER");
events:RegisterEvent("UNIT_AURA");
events:RegisterEvent("UNIT_LEVEL");
events:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
events:RegisterEvent("UNIT_FACTION");
events:RegisterEvent("UNIT_COMBAT");
events:RegisterEvent("UNIT_THREAT_LIST_UPDATE");
events:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");

-- Cast events
events:RegisterEvent("UNIT_SPELLCAST_START");
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
events:RegisterEvent("UNIT_SPELLCAST_DELAYED");
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
events:RegisterEvent("UNIT_SPELLCAST_STOP");
events:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
events:RegisterEvent("UNIT_SPELLCAST_FAILED");
events:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET");
events:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
events:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

-- Nameplate's base
events:RegisterEvent("UI_SCALE_CHANGED");
events:RegisterEvent("DISPLAY_SIZE_CHANGED");

-- Rest
events:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
events:RegisterEvent("GROUP_ROSTER_UPDATE");
events:RegisterEvent("RAID_TARGET_UPDATE");
events:RegisterEvent("MODIFIER_STATE_CHANGED");
events:RegisterEvent("CVAR_UPDATE");
events:RegisterEvent("FRIENDLIST_UPDATE");

-- Scripts
events:SetScript("OnEvent", core.init);

SLASH_CPPDBG1 = "/cppdbg";
SlashCmdList.CPPDBG = function()
    local lines = {};

    local function p(...)
        local parts = {};
        for i = 1, select("#", ...) do
            parts[#parts + 1] = tostring(select(i, ...));
        end
        lines[#lines + 1] = table.concat(parts, " ");
    end

    local function dumpFrame(label, f)
        if not f then
            p(label .. ": NIL");
            return;
        end
        local name = f:GetName() or "(anon)";
        local ok1, shown = pcall(f.IsShown, f);
        local ok2, visible = pcall(f.IsVisible, f);
        local ok3 = pcall(function()
            local x1, y1, x2, y2 = f:GetRect();
            p(label .. ": " .. name,
              "isShown=" .. (ok1 and tostring(shown) or "(err)"),
              "isVisible=" .. (ok2 and tostring(visible) or "(err)"),
              "rect=" .. math.floor(x1) .. "," .. math.floor(y2) .. " " .. math.floor(x2 - x1) .. "x" .. math.floor(y1 - y2));
        end);
        if not ok3 then
            p(label .. ": " .. name,
              "isShown=" .. (ok1 and tostring(shown) or "(err)"),
              "isVisible=" .. (ok2 and tostring(visible) or "(err)"),
              "rect=n/a");
        end
    end

    local function collect()
        local nameplate = C_NamePlate.GetNamePlateForUnit("target");
        if not (nameplate and nameplate.unitFrame) then
            local plates = C_NamePlate.GetNamePlates(false);
            if plates then
                for _, pl in ipairs(plates) do
                    if pl and pl.unitFrame then
                        nameplate = pl;
                        break
                    end
                end
            end
        end
        if not nameplate then
            p("No nameplate found.");
            return;
        end

        p("== token: " .. tostring(nameplate.namePlateUnitToken) .. " | frame: " .. tostring(nameplate:GetName()) .. " | custom: " .. tostring(nameplate.unitFrame ~= nil));
        p("data.isClassic=" .. tostring(data.isClassic) .. " isRetail=" .. tostring(data.isRetail) .. " classBarHeight=" .. tostring(data.classBarHeight));

        local CFG = CFG_Account_ClassicPlatesPlus and CFG_Account_ClassicPlatesPlus.Profiles[CFG_ClassicPlatesPlus.Profile];
        if CFG then
            p("CFG: NameplatesScale=" .. tostring(CFG.NameplatesScale),
              "Portrait=" .. tostring(CFG.Portrait),
              "ShowLevel=" .. tostring(CFG.ShowLevel),
              "Powerbar=" .. tostring(CFG.Powerbar),
              "ThreatPercent=" .. tostring(CFG.ThreatPercentage),
              "ShowGuild=" .. tostring(CFG.ShowGuildName));
        else
            p("CFG: NIL");
        end

        dumpFrame("nameplate", nameplate);

        local blz = nameplate.UnitFrame;
        p("blzUnitFrame: " .. (blz and ("isShown=" .. tostring(blz:IsShown())) or "NIL"));
        p("blzName: " .. (blz and blz.name and tostring(blz.name:GetText()) or "NIL"));
        p("blzAltPB: " .. tostring(NamePlateDriverFrame and NamePlateDriverFrame.classNamePlateAlternatePowerBar ~= nil or false));

        local uf = nameplate.unitFrame;
        if not uf then
            p("custom unitFrame: NIL");
            return;
        end
        dumpFrame("custom uf", uf);
        p("uf.parent: " .. (uf.parent and "exists" or "NIL"));

        local hb = uf.healthbar;
        dumpFrame("healthbar", hb);
        if hb then
            p("minmax=" .. tostring(hb:GetMinMaxValues()), "value=" .. tostring(hb:GetValue()));
            local st = hb:GetStatusBarTexture();
            p("statusTex: " .. (st and tostring(st:GetTexture()) or "NIL"));
            local oks2, hbw, hbh = pcall(hb.GetSize, hb);
            p("hbSize: " .. (oks2 and (tostring(hbw) .. "x" .. tostring(hbh)) or "(err)"));
            for i = 1, hb:GetNumPoints() do
                local pt, rel, rp, x, y = hb:GetPoint(i);
                p("hb point " .. i .. ": " .. tostring(pt),
                  "rel=" .. (rel and rel:GetName() or "(anon)"),
                  "rp=" .. tostring(rp),
                  "x=" .. tostring(x),
                  "y=" .. tostring(y));
            end
        end

        if uf.name then
            p("name: shown=" .. tostring(uf.name:IsShown()) .. " text=" .. tostring(uf.name:GetText()));
        end
        if uf.guild then
            p("guild: shown=" .. tostring(uf.guild:IsShown()));
        end

        if uf.auras then
            for _, f in ipairs({ "harmful", "helpful" }) do
                for i = 1, 5 do
                    local ic = uf.auras[f] and uf.auras[f][i];
                    if ic then
                        p("aura " .. f .. "[" .. i .. "]: shown=" .. tostring(ic:IsShown()));
                        if ic.icon then
                            local ok, tex = pcall(ic.icon.GetTexture, ic.icon);
                            p("   iconTex: " .. (ok and tostring(tex) or "(err)"));
                            local okn, n = pcall(ic.icon.GetNumMaskTextures, ic.icon);
                            p("   masks: " .. (okn and tostring(n) or "(err)"));
                            local oks, w, h = pcall(ic.icon.GetSize, ic.icon);
                            p("   iconSize: " .. (oks and (tostring(w) .. "x" .. tostring(h)) or "(err)"));
                            local okc, cw, ch = pcall(ic.GetSize, ic);
                            p("   auraSize: " .. (okc and (tostring(cw) .. "x" .. tostring(ch)) or "(err)"));
                        end
                        if ic.cooldown then
                            p("   cd shown=" .. tostring(ic.cooldown:IsShown()) .. " " .. tostring(ic.cooldown:GetCooldownTimes()));
                        end
                    end
                end
            end
        else
            p("uf.auras: NIL");
        end
    end

    local ok, err = xpcall(collect, function(e)
        return tostring(e);
    end);
    if not ok then
        p("ERROR: " .. tostring(err));
    end

    p("");
    p("== Tip: Ctrl+A then Ctrl+C to copy everything. Esc closes.");

    local frame = CPP_DebugPopup;
    if frame then
        local eb = frame.eb;
        local lockedText = table.concat(lines, "\n");
        eb:SetScript("OnTextChanged", nil);
        eb:SetText(lockedText);
        eb:SetScript("OnTextChanged", function(self)
            if self:GetText() ~= lockedText then
                self:SetText(lockedText);
            end
        end);
        frame:Show();
        eb:SetFocus();
        eb:HighlightText();
        return;
    end

    frame = CreateFrame("Frame", "CPP_DebugPopup", UIParent, "BackdropTemplate");
    frame:SetSize(840, 600);
    frame:SetPoint("CENTER");
    frame:SetFrameStrata("DIALOG");
    frame:SetMovable(true);
    frame:EnableMouse(true);
    frame:RegisterForDrag("LeftButton");
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving();
    end);
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing();
    end);
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    });
    frame:SetBackdropColor(0, 0, 0, 0.95);

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    frame.title:SetPoint("TOPLEFT", 12, -8);
    frame.title:SetJustifyH("LEFT");
    frame.title:SetText("ClassicPlatesPlus debug - drag to move");

    frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton");
    frame.close:SetPoint("TOPRIGHT", -6, -6);

    frame.prompt = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    frame.prompt:SetPoint("TOPLEFT", 12, -28);
    frame.prompt:SetJustifyH("LEFT");
    frame.prompt:SetText("Ctrl+A select all, Ctrl+C copy, Esc closes.");

    frame.eb = CreateFrame("EditBox", nil, frame);
    frame.eb:SetPoint("TOPLEFT", 12, -46);
    frame.eb:SetPoint("BOTTOMRIGHT", -12, 30);
    frame.eb:SetMultiLine(true);
    frame.eb:SetAutoFocus(false);
    frame.eb:SetMaxLetters(0);
    frame.eb:EnableMouse(true);
    frame.eb:SetFontObject(ChatFontNormal);
    frame.eb:SetJustifyH("LEFT");
    frame.eb:SetTextInsets(6, 6, 6, 6);
    frame.eb:SetScript("OnEscapePressed", function()
        frame:Hide();
        frame.eb:ClearFocus();
    end);

    local lockedText = table.concat(lines, "\n");
    frame.eb:SetScript("OnTextChanged", function(self)
        if self:GetText() ~= lockedText then
            self:SetText(lockedText);
        end
    end);
    frame.eb:SetText(lockedText);
    frame:Show();
    frame.eb:SetFocus();
    frame.eb:HighlightText();
end