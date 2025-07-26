--[[
   Open Source 
   by Vyxon(vyxonq) and Henne(riseinsilence)
   Silence: https://discord.gg/dYHFUPUK
   AS | Astrar Services: https://discord.gg/H9Y9mtdm
]]


local a = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local b = game:GetService("Players").LocalPlayer
local c

local function d(e)
    local f = {k = 10 ^ 3, m = 10 ^ 6, b = 10 ^ 9, t = 10 ^ 12, qa = 10 ^ 15, qi = 10 ^ 18}
    local g, h = string.match(e:lower(), "(%d+%.?%d*)([kmbtqai]?)")
    return tonumber(g) * (f[h] or 1)
end

local i = {}
i.__index = i

function i.new()
    local self = setmetatable({}, i)
    self.window = a:CreateWindow({
        Title = "Stat Spoofer",
        SubTitle = "by Henne",
        TabWidth = 140,
        Size = UDim2.fromOffset(450, 280),
        Acrylic = false,
        Transparency = 1,
        Theme = "Aqua"
    })

    self.tab = self.window:AddTab({Title = "Spoof", Icon = "rbxassetid://10747383470"})
    self.statSelection = "Strength"
    self.originalValues = {}
    self.frozenValues = {}

    self:init()
    return self
end

function i:init()
    self.tab:AddDropdown("StatDropdown", {
        Title = "Select Stat",
        Values = {
            "Strength", 
            "Durability", 
            "Agility", 
            "Gems",
            "Brawls",
            "Rebirths",
            "Kills",
            "Evil Karma",
            "Good Karma"
        },
        Default = "",
        Callback = function(k)
            self.statSelection = k
        end
    })

    self.tab:AddInput("StatInput", {
        Title = "Set Value",
        Placeholder = "Enter new value",
        Callback = function(e)
            self:setStatValue(e)
        end
    })

    game:GetService("RunService").RenderStepped:Connect(function()
        self:maintainFrozenValues()
    end)
end

function i:setStatValue(e)
    local l = nil
    local stat = self.statSelection

    if stat == "Strength" then
        l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Strength")
    elseif stat == "Kills" then
        l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Kills")
    elseif stat == "Rebirths" then
        l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Rebirths")
    elseif stat == "Brawls" then
        l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Brawls")
    elseif stat == "Durability" then
        l = b:FindFirstChild("Durability")
    elseif stat == "Agility" then
        l = b:FindFirstChild("Agility")
    elseif stat == "Gems" then
        l = b:FindFirstChild("Gems")
    elseif stat == "Good Karma" then
        l = b:FindFirstChild("goodKarma")
    elseif stat == "Evil Karma" then
        l = b:FindFirstChild("evilKarma")
    end

    if l then
        if e == "" then
            if self.originalValues[stat] then
                l.Value = self.originalValues[stat]
                self.frozenValues[stat] = nil
            end
        else
            if l:IsA("IntValue") or l:IsA("NumberValue") then
                if not self.originalValues[stat] then
                    self.originalValues[stat] = l.Value
                end
                local m = d(e)
                self.frozenValues[stat] = m
                l.Value = m
            end
        end
    end
end

function i:maintainFrozenValues()
    for n, o in pairs(self.frozenValues) do
        local l = nil

        if n == "Strength" then
            l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Strength")
        elseif n == "Kills" then
            l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Kills")
        elseif n == "Brawls" then
            l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Brawls")
        elseif n == "Rebirths" then
            l = b:FindFirstChild("leaderstats") and b.leaderstats:FindFirstChild("Rebirths")
        elseif n == "Durability" then
            l = b:FindFirstChild("Durability")
        elseif n == "Agility" then
            l = b:FindFirstChild("Agility")
        elseif n == "Gems" then
            l = b:FindFirstChild("Gems")
        elseif n == "Good Karma" then
            l = b:FindFirstChild("goodKarma")
        elseif n == "Evil Karma" then
            l = b:FindFirstChild("evilKarma")
        end

        if l and (l:IsA("IntValue") or l:IsA("NumberValue")) then
            if l.Value ~= o then
                l.Value = o
            end
        end
    end
end

return i.new()
