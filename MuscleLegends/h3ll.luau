
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lkjhg969/ffdsf/refs/heads/main/hgfhj", true))()

local window = library:AddWindow("H3LL | PAID VERSION", {
    main_color = Color3.fromRGB(57, 0, 255),
    min_size = Vector2.new(550, 600),
    can_resize = false,
})


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local blockedFrames = {
    "strengthFrame",
    "durabilityFrame",
    "agilityFrame",
}

for _, name in ipairs(blockedFrames) do
    local frame = ReplicatedStorage:FindFirstChild(name)
    if frame and frame:IsA("GuiObject") then
        frame.Visible = false
    end
end

ReplicatedStorage.ChildAdded:Connect(function(child)
    if table.find(blockedFrames, child.Name) and child:IsA("GuiObject") then
        child.Visible = false
    end
end)

local FarmingTab = window:AddTab("Main")

FarmingTab:AddLabel("Misc").TextSize = 22

local autoLiftSwitch = FarmingTab:AddSwitch("Auto Lift (Gamepass)", function(bool)
    if bool then
        local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
        local player = game:GetService("Players").LocalPlayer
        for _, gamepass in pairs(gamepassFolder:GetChildren()) do
            local value = Instance.new("IntValue")
            value.Name = gamepass.Name
            value.Value = gamepass.Value
            value.Parent = player.ownedGamepasses
        end
    else
        local player = game:GetService("Players").LocalPlayer
        if player and player.ownedGamepasses then
            local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
            for _, gamepass in pairs(gamepassFolder:GetChildren()) do
                local ownedPass = player.ownedGamepasses:FindFirstChild(gamepass.Name)
                if ownedPass and ownedPass.Value == gamepass.Value then
                    ownedPass:Destroy()
                end
            end
        end
    end
end)

local rebirthLabel = FarmingTab:AddLabel("Rebirths:")
rebirthLabel.TextSize = 22

local function formatNumber(num)
    local numStr = tostring(num)
    local formatted = ""
    local counter = 0

    for i = #numStr, 1, -1 do
        counter = counter + 1
        formatted = numStr:sub(i, i) .. formatted
        if counter % 3 == 0 and i > 1 then
            formatted = "," .. formatted
        end
    end
    
    return formatted
end

task.spawn(function()
    local rebirths = player.leaderstats:WaitForChild("Rebirths")

    while true do
        rebirthLabel.Text = "Rebirths (" .. formatNumber(rebirths.Value) .. "):"
        task.wait(0.2)
    end
end)

local switch = FarmingTab:AddSwitch("Auto Rebirth", function(enabled)
    if enabled then
        while true do
            ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            task.wait(0.05)
        end
    end
end)

switch:Set(false)

local changeSpeedSizeRemote = ReplicatedStorage.rEvents.changeSpeedSizeRemote

local sizeActive = false

local switch = FarmingTab:AddSwitch("Auto Size 1", function(bool)
    sizeActive = bool
end)

switch:Set(false)

task.spawn(function()
    while true do
        if sizeActive then
            local character = Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                end
            end
        end
        task.wait(0.05)
    end
end)

local Players = game:GetService("Players")

local targetPosition = CFrame.new(-8665.4, 17.21, -5792.9)
local teleportActive = false

local switch = FarmingTab:AddSwitch("Auto King", function(enabled)
    teleportActive = enabled
end)

switch:Set(false)

task.spawn(function()
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    while true do
        if teleportActive then
            if (hrp.Position - targetPosition.Position).magnitude > 5 then
                hrp.CFrame = targetPosition
            end
        end
        task.wait(0.05)
    end
end)

FarmingTab:AddLabel("Tools:").TextSize = 22

local SelectedTool = nil
local AutoFarm = false

local toolDropdown = FarmingTab:AddDropdown("Select Tool", function(selection)
    SelectedTool = selection
end)
toolDropdown:Add("Weight")
toolDropdown:Add("Pushups")
toolDropdown:Add("Situps")
toolDropdown:Add("Handstands")
toolDropdown:Add("Fast Punch")
toolDropdown:Add("Stomp")
toolDropdown:Add("Ground Slam")

local autoFarmSwitch = FarmingTab:AddSwitch("Start", function(enabled)
    AutoFarm = enabled

    if enabled then
        task.spawn(function()
            while AutoFarm do
                local player = game:GetService("Players").LocalPlayer

                if SelectedTool == "Weight" then
                    if not player.Character:FindFirstChild("Weight") then
                        local weightTool = player.Backpack:FindFirstChild("Weight")
                        if weightTool then
                            player.Character.Humanoid:EquipTool(weightTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Pushups" then
                    if not player.Character:FindFirstChild("Pushups") then
                        local pushupsTool = player.Backpack:FindFirstChild("Pushups")
                        if pushupsTool then
                            player.Character.Humanoid:EquipTool(pushupsTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Situps" then
                    if not player.Character:FindFirstChild("Situps") then
                        local situpsTool = player.Backpack:FindFirstChild("Situps")
                        if situpsTool then
                            player.Character.Humanoid:EquipTool(situpsTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Handstands" then
                    if not player.Character:FindFirstChild("Handstands") then
                        local handstandsTool = player.Backpack:FindFirstChild("Handstands")
                        if handstandsTool then
                            player.Character.Humanoid:EquipTool(handstandsTool)
                        end
                    end
                    player.muscleEvent:FireServer("rep")

                elseif SelectedTool == "Fast Punch" then
                    local punch = player.Backpack:FindFirstChild("Punch")
                    if punch then
                        punch.Parent = player.Character
                        if punch:FindFirstChild("attackTime") then
                            punch.attackTime.Value = 0
                        end
                    end
                    player.muscleEvent:FireServer("punch", "rightHand")
                    player.muscleEvent:FireServer("punch", "leftHand")

                    if player.Character:FindFirstChild("Punch") then
                        player.Character.Punch:Activate()
                    end

                elseif SelectedTool == "Stomp" then
                    local stomp = player.Backpack:FindFirstChild("Stomp")
                    if stomp then
                        stomp.Parent = player.Character
                        if stomp:FindFirstChild("attackTime") then
                            stomp.attackTime.Value = 0
                        end
                    end
                    player.muscleEvent:FireServer("stomp")

                    if player.Character:FindFirstChild("Stomp") then
                        player.Character.Stomp:Activate()
                    end

                    if tick() % 6 < 0.1 then
                        local virtualUser = game:GetService("VirtualUser")
                        virtualUser:CaptureController()
                        virtualUser:ClickButton1(Vector2.new(500, 500))
                    end

                elseif SelectedTool == "Ground Slam" then
                    local groundSlam = player.Backpack:FindFirstChild("Ground Slam")
                    if groundSlam then
                        groundSlam.Parent = player.Character
                        if groundSlam:FindFirstChild("attackTime") then
                            groundSlam.attackTime.Value = 0
                        end
                    end
                    player.muscleEvent:FireServer("slam")

                    if player.Character:FindFirstChild("Ground Slam") then
                        player.Character["Ground Slam"]:Activate()
                    end

                    if tick() % 6 < 0.1 then
                        local virtualUser = game:GetService("VirtualUser")
                        virtualUser:CaptureController()
                        virtualUser:ClickButton1(Vector2.new(500, 500))
                    end
                end

                task.wait()
            end
        end)
    else
        local player = game:GetService("Players").LocalPlayer
        if SelectedTool and player.Character:FindFirstChild(SelectedTool) then
            player.Character:FindFirstChild(SelectedTool).Parent = player.Backpack
        end
    end
end)

FarmingTab:AddLabel("Rocks:").TextSize = 22

local function gettool()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    local player = game:GetService("Players").LocalPlayer
    player.muscleEvent:FireServer("punch", "leftHand")
    player.muscleEvent:FireServer("punch", "rightHand")
end

local rockData = {
    ["Tiny Rock"] = 0,
    ["Starter Island"] = 100,
    ["Punching Rock"] = 1000,
    ["Golden Rock"] = 5000,
    ["Frost Rock"] = 150000,
    ["Mythical Rock"] = 400000,
    ["Eternal Rock"] = 750000,
    ["Legend Rock"] = 1000000,
    ["Muscle King Rock"] = 5000000,
    ["Jungle Rock"] = 10000000
}

local selectedRock = nil

local rockDropdown = FarmingTab:AddDropdown("Select Rock", function(selection)
    selectedRock = selection
end)

for rockName in pairs(rockData) do
    rockDropdown:Add(rockName)
end

local autoRockSwitch = FarmingTab:AddSwitch("Auto Rock", function(enabled)
    getgenv().RockFarmRunning = enabled

    if enabled and selectedRock then
        task.spawn(function()
            local requiredDurability = rockData[selectedRock]
            local player = game:GetService("Players").LocalPlayer

            while getgenv().RockFarmRunning do
                task.wait()
                if player.Durability.Value >= requiredDurability then
                    for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                        if v.Name == "neededDurability" and v.Value == requiredDurability and
                            player.Character:FindFirstChild("LeftHand") and
                            player.Character:FindFirstChild("RightHand") then

                            local rock = v.Parent:FindFirstChild("Rock")
                            if rock then
                                firetouchinterest(rock, player.Character.RightHand, 0)
                                firetouchinterest(rock, player.Character.RightHand, 1)
                                firetouchinterest(rock, player.Character.LeftHand, 0)
                                firetouchinterest(rock, player.Character.LeftHand, 1)
                                gettool()
                            end
                        end
                    end
                end
            end
        end)
    end
end)

FarmingTab:AddLabel("Machines:").TextSize = 22

local selectedLocation = nil
local selectedWorkout = nil
local working = false
local workoutTypeDropdown
local machineDropdown
local repTask = nil  

local function pressE()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    vim:SendKeyEvent(false, "E", false, game)
end

local function autoLift()
    while working and task.wait() do
        game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
    end
end

local function stopAutoLift()
    if repTask then
        repTask:Cancel()  
        repTask = nil
    end
end

local function teleportAndStart(machineName, position)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = position
        task.wait(0.5)
        pressE()
        if working then
            repTask = task.spawn(autoLift)
        end
    end
end

local workoutPositions = {
    ["Bench Press"] = {
        ["Jungle Gym"] = CFrame.new(-8173, 64, 1898),
        ["Muscle King Gym"] = CFrame.new(-8590.06152, 46.0167427, -6043.34717),
        ["Legend Gym"] = CFrame.new(4111.91748, 1020.46674, -3799.97217)
    },
    ["Squat"] = {
        ["Jungle Gym"] = CFrame.new(-8352, 34, 2878),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334)
    },
    ["Pull Up"] = {
        ["Jungle Gym"] = CFrame.new(-8666, 34, 2070),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334)
    },
    ["Boulder"] = {
        ["Jungle Gym"] = CFrame.new(-8621, 34, 2684),
        ["Muscle King Gym"] = CFrame.new(-8940.12402, 13.1642084, -5699.13477),
        ["Legend Gym"] = CFrame.new(4304.99023, 987.829956, -4124.2334)
    }
}

local workoutLocations = {
    "Jungle Gym", "Muscle King Gym", "Legend Gym"
}

FarmingTab:AddSwitch("Start", function(enabled)
    working = enabled

    if enabled then
        if selectedLocation and selectedWorkout and workoutPositions[selectedWorkout][selectedLocation] then
            teleportAndStart(selectedWorkout, workoutPositions[selectedWorkout][selectedLocation])
        end
    else
        stopAutoLift()
    end
end)

local locationDropdown = FarmingTab:AddDropdown("Gym", function(location)
    selectedLocation = location

    if machineDropdown then
        machineDropdown:Clear()
    end

    if location == "Jungle Gym" then
        machineDropdown = FarmingTab:AddDropdown("Machine", function(machine)
            selectedWorkout = machine
        end)
        machineDropdown:Add("Bench Press")
        machineDropdown:Add("Squat")
        machineDropdown:Add("Pull Up")
        machineDropdown:Add("Boulder")
    elseif location == "Muscle King Gym" then
        machineDropdown = FarmingTab:AddDropdown("Machine", function(machine)
            selectedWorkout = machine
        end)
        machineDropdown:Add("Bench Press")
        machineDropdown:Add("Squat")
        machineDropdown:Add("Pull Up")
        machineDropdown:Add("Boulder")
    elseif location == "Legend Gym" then
        machineDropdown = FarmingTab:AddDropdown("Machine", function(machine)
            selectedWorkout = machine
        end)
        machineDropdown:Add("Bench Press")
        machineDropdown:Add("Squat")
        machineDropdown:Add("Pull Up")
        machineDropdown:Add("Boulder")
    end
end)

for _, location in ipairs(workoutLocations) do
    locationDropdown:Add(location)
end

local KillingTab = window:AddTab("Killing")

local function checkCharacter()
    if not game.Players.LocalPlayer.Character then
        repeat task.wait() until game.Players.LocalPlayer.Character
    end
    return game.Players.LocalPlayer.Character
end

local function gettool()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    game.Players.LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game.Players.LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

local function isPlayerAlive(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function killPlayer(target)
    if not isPlayerAlive(target) then return end
    local character = checkCharacter()
    if character and character:FindFirstChild("LeftHand") then
        pcall(function()
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 0)
            firetouchinterest(target.Character.HumanoidRootPart, character.LeftHand, 1)
            gettool()
        end)
    end
end

KillingTab:AddLabel("Misc:").TextSize = 22


local dropdown = KillingTab:AddDropdown("Select Pet", function(text)
    local petsFolder = game.Players.LocalPlayer.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)

    local petName = text
    local petsToEquip = {}

    for _, pet in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do
        if pet.Name == petName then
            table.insert(petsToEquip, pet)
        end
    end

    for i = 1, math.min(8, #petsToEquip) do
        game:GetService("ReplicatedStorage").rEvents.equipPetEvent:FireServer("equipPet", petsToEquip[i])
        task.wait(0.1)
    end
end)
dropdown:Add("Wild Wizard")
dropdown:Add("Mighty Monster")

local switch = KillingTab:AddSwitch("Remove Attack Animations", function(bool)
    if bool then
        local blockedAnimations = {
            ["rbxassetid://3638729053"] = true,
            ["rbxassetid://3638767427"] = true,
        }

        local function setupAnimationBlocking()
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("Humanoid") then return end

            local humanoid = char:FindFirstChild("Humanoid")

            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()

                    if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                        track:Stop()
                    end
                end
            end

            _G.AnimBlockConnection = humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()

                    if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                        track:Stop()
                    end
                end
            end)
        end

        local function processTool(tool)
            if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
                if not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)

                    _G.ToolConnections = _G.ToolConnections or {}
                    _G.ToolConnections[tool] = tool.Activated:Connect(function()
                        task.wait(0.05)
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation then
                                    local animId = track.Animation.AnimationId
                                    local animName = track.Name:lower()

                                    if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                                        track:Stop()
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end

        local function overrideToolActivation()
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                processTool(tool)
            end

            local char = game.Players.LocalPlayer.Character
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        processTool(tool)
                    end
                end
            end

            _G.BackpackAddedConnection = game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)

            if char then
                _G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
                    if child:IsA("Tool") then
                        task.wait(0.1)
                        processTool(child)
                    end
                end)
            end
        end

        _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % 0.5 < 0.01 then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation then
                            local animId = track.Animation.AnimationId
                            local animName = track.Name:lower()

                            if blockedAnimations[animId] or animName:match("punch") or animName:match("attack") or animName:match("right") then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)

        _G.CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            setupAnimationBlocking()
            overrideToolActivation()

            if _G.CharacterToolAddedConnection then
                _G.CharacterToolAddedConnection:Disconnect()
            end

            _G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end)

        setupAnimationBlocking()
        overrideToolActivation()
    else
        if _G.AnimBlockConnection then
            _G.AnimBlockConnection:Disconnect()
            _G.AnimBlockConnection = nil
        end

        if _G.AnimMonitorConnection then
            _G.AnimMonitorConnection:Disconnect()
            _G.AnimMonitorConnection = nil
        end

        if _G.CharacterAddedConnection then
            _G.CharacterAddedConnection:Disconnect()
            _G.CharacterAddedConnection = nil
        end

        if _G.BackpackAddedConnection then
            _G.BackpackAddedConnection:Disconnect()
            _G.BackpackAddedConnection = nil
        end

        if _G.CharacterToolAddedConnection then
            _G.CharacterToolAddedConnection:Disconnect()
            _G.CharacterToolAddedConnection = nil
        end

        if _G.ToolConnections then
            for tool, connection in pairs(_G.ToolConnections) do
                if connection then
                    connection:Disconnect()
                end
                if tool and tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", nil)
                end
            end
            _G.ToolConnections = nil
        end
    end
end)

switch:Set(false)


local player = game:GetService("Players").LocalPlayer
local changeSpeedSizeRemote = ReplicatedStorage.rEvents.changeSpeedSizeRemote

local antiKnockbackSwitch = KillingTab:AddSwitch("Anti Fling", function(bool)
    if bool then
        local playerName = game.Players.LocalPlayer.Name
        local character = game.Workspace:FindFirstChild(playerName)
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.P = 1250
                bodyVelocity.Parent = rootPart
            end
        end
    else
        local playerName = game.Players.LocalPlayer.Name
        local character = game.Workspace:FindFirstChild(playerName)
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
                if existingVelocity and existingVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
                    existingVelocity:Destroy()
                end
            end
        end
    end
end)
antiKnockbackSwitch:Set(false)

KillingTab:AddLabel("Auto Kill:").TextSize = 22

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local function isWhitelisted(player)
    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == player.Name:lower() then
            return true
        end
    end
    return false
end

local function isBlacklisted(player)
    for _, name in ipairs(_G.blacklistedPlayers) do
        if name:lower() == player.Name:lower() then
            return true
        end
    end
    return false
end

local function getPlayerDisplayText(player)
    return player.DisplayName .. " | " .. player.Name
end

local whitelistDropdown = KillingTab:AddDropdown("Add to Whitelist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1") 
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.whitelistedPlayers, playerName)
    end
end)

local switch = KillingTab:AddSwitch("Kill Everyone", function(bool)
    _G.killAll = bool
    if bool then
        if not _G.killAllConnection then
            _G.killAllConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.killAll then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and not isWhitelisted(player) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.killAllConnection then
            _G.killAllConnection:Disconnect()
            _G.killAllConnection = nil
        end
    end
end)
switch:Set(false)

local switch = KillingTab:AddSwitch("Whitelist Friends", function(bool)
    _G.whitelistFriends = bool

    if bool then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name
                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end
                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end

        game.Players.PlayerAdded:Connect(function(player)
            if _G.whitelistFriends and player:IsFriendsWith(game.Players.LocalPlayer.UserId) then
                local playerName = player.Name
                local alreadyWhitelisted = false
                for _, name in ipairs(_G.whitelistedPlayers) do
                    if name:lower() == playerName:lower() then
                        alreadyWhitelisted = true
                        break
                    end
                end
                if not alreadyWhitelisted then
                    table.insert(_G.whitelistedPlayers, playerName)
                end
            end
        end)
    end
end)

switch:Set(false)

KillingTab:AddLabel("")

local blacklistDropdown = KillingTab:AddDropdown("Add to Killlist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1") 
        for _, name in ipairs(_G.blacklistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.blacklistedPlayers, playerName)
    end
end)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        local displayText = getPlayerDisplayText(player)
        whitelistDropdown:Add(displayText)
        blacklistDropdown:Add(displayText)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        local displayText = getPlayerDisplayText(player)
        whitelistDropdown:Add(displayText)
        blacklistDropdown:Add(displayText)
    end
end)


local blacklistKillSwitch = KillingTab:AddSwitch("Kill List", function(bool)
    _G.killBlacklistedOnly = bool
    if bool then
        if not _G.blacklistKillConnection then
            _G.blacklistKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.killBlacklistedOnly then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and isBlacklisted(player) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.blacklistKillConnection then
            _G.blacklistKillConnection:Disconnect()
            _G.blacklistKillConnection = nil
        end
    end
end)

local selectedPlayerToSpectate = nil
local spectating = false
local currentTargetConnection = nil
local camera = workspace.CurrentCamera

local function updateSpectateTarget(player)
    if currentTargetConnection then
        currentTargetConnection:Disconnect()
    end
    
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            camera.CameraSubject = humanoid
            currentTargetConnection = player.CharacterAdded:Connect(function(newChar)
                task.wait(0.2)
                local newHumanoid = newChar:FindFirstChildOfClass("Humanoid")
                if newHumanoid then
                    camera.CameraSubject = newHumanoid
                end
            end)
        end
    end
end

local function updatePlayerList()
    return game.Players:GetPlayers()
end

local specdropdown = KillingTab:AddDropdown("Choose Player", function(text)
    for _, player in ipairs(updatePlayerList()) do
        local optionText = player.DisplayName .. " | " .. player.Name
        if text == optionText then
            selectedPlayerToSpectate = player
            if spectating then
                updateSpectateTarget(player)
            end
            break
        end
    end
end)

local spectateSwitch = KillingTab:AddSwitch("Spectate", function(bool)
    spectating = bool
    if spectating and selectedPlayerToSpectate then
        updateSpectateTarget(selectedPlayerToSpectate)
    else
        if currentTargetConnection then
            currentTargetConnection:Disconnect()
            currentTargetConnection = nil
        end
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character then
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                camera.CameraSubject = humanoid
            end
        end
    end
end)

for _, player in ipairs(updatePlayerList()) do
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end

game.Players.PlayerAdded:Connect(function(player)
    specdropdown:Add(player.DisplayName .. " | " .. player.Name)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if selectedPlayerToSpectate and selectedPlayerToSpectate == player then
        selectedPlayerToSpectate = nil
        if spectating then
            spectateSwitch:Set(false)
        end
    end
end)

KillingTab:AddLabel("Kill Aura:").TextSize = 22

local ringPart = nil
local ringColor = Color3.fromRGB(50, 163, 255)
local ringTransparency = 0.6
_G.showDeathRing = false
_G.deathRingRange = 20

local function updateRingSize()
    if not ringPart then return end
    local diameter = (_G.deathRingRange or 20) * 2
    ringPart.Size = Vector3.new(0.2, diameter, diameter)
end

KillingTab:AddTextBox("Range 1-140", function(text)
    local range = tonumber(text)
    if range then
        _G.deathRingRange = math.clamp(range, 1, 140)
        updateRingSize()
    end
end)

local function toggleRingVisual()
    if _G.showDeathRing then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = ringColor
        ringPart.Transparency = ringTransparency
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        updateRingSize()
        ringPart.Parent = workspace
    elseif ringPart then
        ringPart:Destroy()
        ringPart = nil
    end
end

local function updateRingPosition()
    if not ringPart then return end
    local character = checkCharacter()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        ringPart.CFrame = rootPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
    end
end

local deathRingSwitch = KillingTab:AddSwitch("Death Ring", function(bool)
    _G.deathRingEnabled = bool
    
    if bool then
        if not _G.deathRingConnection then
            _G.deathRingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                updateRingPosition()
                
                local character = checkCharacter()
                local myPosition = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position
                if not myPosition then return end

                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and not isWhitelisted(player) and isPlayerAlive(player) then
                        local distance = (myPosition - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= (_G.deathRingRange or 20) then
                            killPlayer(player)
                        end
                    end
                end
            end)
        end
    else
        if _G.deathRingConnection then
            _G.deathRingConnection:Disconnect()
            _G.deathRingConnection = nil
        end
    end
end)

local visualRingSwitch = KillingTab:AddSwitch("Show Ring", function(bool)
    _G.showDeathRing = bool
    toggleRingVisual()
end)
deathRingSwitch:Set(false)
visualRingSwitch:Set(false)

local whitelistLabel = KillingTab:AddLabel("Whitelist: None")
whitelistLabel.TextColor3 = Color3.fromRGB(26, 122, 212)
whitelistLabel.TextSize = 17

KillingTab:AddButton("Clear Whitelist", function()
    _G.whitelistedPlayers = {}
end)

local blacklistLabel = KillingTab:AddLabel("Killlist: None")
blacklistLabel.TextColor3 = Color3.fromRGB(191, 58, 25)
blacklistLabel.TextSize = 17

KillingTab:AddButton("Clear Blacklist", function()
    _G.blacklistedPlayers = {}
end)

local function updateWhitelistLabel()
    if #_G.whitelistedPlayers == 0 then
        whitelistLabel.Text = "Whitelist: None"
    else
        whitelistLabel.Text = "Whitelist: " .. table.concat(_G.whitelistedPlayers, ", ")
    end
end

local function updateBlacklistLabel()
    if #_G.blacklistedPlayers == 0 then
        blacklistLabel.Text = "Killlist: None"
    else
        blacklistLabel.Text = "Killlist: " .. table.concat(_G.blacklistedPlayers, ", ")
    end
end

task.spawn(function()
    while true do
        updateWhitelistLabel()
        updateBlacklistLabel()
        task.wait(0.2)
    end
end)

local features = window:AddTab("Rebirthing")

features:AddLabel("Farming").TextSize = 20

local player = game.Players.LocalPlayer
local muscleEvent = player:WaitForChild("muscleEvent")
local replicatedStorage = game:GetService("ReplicatedStorage")

local function unequipPets()
    for _, folder in pairs(player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                replicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.1)
end

local function equipPetsByName(name)
    unequipPets()
    task.wait(0.01)
    for _, pet in pairs(player.petsFolder.Unique:GetChildren()) do
        if pet.Name == name then
            replicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
        end
    end
end

local isRunning = false

local function fastReb()
    while isRunning do
        equipPetsByName("Swift Samurai")
        task.wait(0.4) 

        local rebirths = player.leaderstats.Rebirths.Value
        local strengthTarget = 5000 + (rebirths * 2550)

        while isRunning and player.leaderstats.Strength.Value < strengthTarget do
            local repsToDo = player.MembershipType == Enum.MembershipType.Premium and 8 or 14
            for _ = 1, repsToDo do
                muscleEvent:FireServer("rep")
            end
            task.wait(0.02)
        end

        if player.leaderstats.Strength.Value >= strengthTarget then
            equipPetsByName("Tribal Overlord")
            task.wait(0.25)

            local before = player.leaderstats.Rebirths.Value
            repeat
                replicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.05)
            until player.leaderstats.Rebirths.Value > before

            task.wait(0.5)
        end
    end
end

local switch = features:AddSwitch("Fast Rebirth", function(bool)
    if bool then
        isRunning = true
        fastReb()
    else
        isRunning = false
    end
end)

local running = false
local thread = nil

local switch = features:AddSwitch("Set Size 1", function(bool)
    running = bool
    if running then
        thread = coroutine.create(function()
            while running do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                wait(0.01)
            end
        end)
        coroutine.resume(thread)
    end
end)
switch:Set(false)

local lockRunning = false
local lockThread = nil

local lockSwitch = features:AddSwitch("Lock Position", function(state)
    lockRunning = state
    if lockRunning then
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local lockPosition = hrp.Position

        lockThread = coroutine.create(function()
            while lockRunning do
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(lockPosition)
                wait(0.05) 
            end
        end)

        coroutine.resume(lockThread)
    end
end)
lockSwitch:Set(false)

features:AddLabel("Pets").TextSize = 20

local switch = features:AddSwitch("Show Pets", function(bool)
    local player = game:GetService("Players").LocalPlayer
    if player:FindFirstChild("hidePets") then
        player.hidePets.Value = bool
    end
end)
switch:Set(false)

features:AddButton("Equip Swift Samurai", function()
    unequipPets()
    equipPetsByName("Swift Samurai")
end)

features:AddButton("Equip Tribal Overlord", function()
    unequipPets()
    equipPetsByName("Tribal Overlord")
end)

local features = window:AddTab("Fast Farming") 
features:Show()

features:AddLabel("Farming").TextSize = 20

local player = game.Players.LocalPlayer
local muscleEvent = player:WaitForChild("muscleEvent")
local runFastRep = false
local repsPerTick = 1

local function getPing()
    local stats = game:GetService("Stats")
    local pingStat = stats:FindFirstChild("PerformanceStats") and stats.PerformanceStats:FindFirstChild("Ping")
    return pingStat and pingStat:GetValue() or 0
end

features:AddTextBox("Rep Speed", function(value)
    local num = tonumber(value)
    if num and num > 0 then
        repsPerTick = math.floor(num)
    end
end, {
    placeholder = "1",
})

local function fastRepLoop()
    while runFastRep do
        local startTime = tick()
        while tick() - startTime < 0.75 and runFastRep do
            for i = 1, repsPerTick do
                muscleEvent:FireServer("rep")
            end
            task.wait(0.02)
        end

        while runFastRep and getPing() >= 1500 do
            task.wait(1)
        end
    end
end

features:AddSwitch("Fast Rep", function(state)
    runFastRep = state
    if runFastRep then
        task.spawn(fastRepLoop)
    else
        print("")
    end
end)

features:AddLabel("Misc").TextSize = 20

local function activateProteinEgg()
    local tool = player.Character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    if tool then
        muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1800)
        else
            task.wait(1)
        end
    end
end)

local switch = features:AddSwitch("Auto Egg", function(state)
    running = state
    if state then
        activateProteinEgg()
    end
end)
switch:Set(false)

local function activateShake()
    local tool = player.Character:FindFirstChild("Tropical Shake") or player.Backpack:FindFirstChild("Tropical Shake")
    if tool then
        muscleEvent:FireServer("tropicalShake", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateShake()
            task.wait(900)
        else
            task.wait(1)
        end
    end
end)

local switch = features:AddSwitch("Auto Shake", function(state)
    running = state
    if state then
        activateShake()
    end
end)
switch:Set(false)

features:AddButton("Anti Lag", function()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local lighting = game:GetService("Lighting")

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end

    local function darkenSky()
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("Sky") then
                v:Destroy()
            end
        end

        local darkSky = Instance.new("Sky")
        darkSky.Name = "DarkSky"
        darkSky.SkyboxBk = "rbxassetid://0"
        darkSky.SkyboxDn = "rbxassetid://0"
        darkSky.SkyboxFt = "rbxassetid://0"
        darkSky.SkyboxLf = "rbxassetid://0"
        darkSky.SkyboxRt = "rbxassetid://0"
        darkSky.SkyboxUp = "rbxassetid://0"
        darkSky.Parent = lighting

        lighting.Brightness = 0
        lighting.ClockTime = 0
        lighting.TimeOfDay = "00:00:00"
        lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        lighting.Ambient = Color3.new(0, 0, 0)
        lighting.FogColor = Color3.new(0, 0, 0)
        lighting.FogEnd = 100

        task.spawn(function()
            while true do
                wait(5)
                if not lighting:FindFirstChild("DarkSky") then
                    darkSky:Clone().Parent = lighting
                end
                lighting.Brightness = 0
                lighting.ClockTime = 0
                lighting.OutdoorAmbient = Color3.new(0, 0, 0)
                lighting.Ambient = Color3.new(0, 0, 0)
                lighting.FogColor = Color3.new(0, 0, 0)
                lighting.FogEnd = 100
            end
        end)
    end

    local function removeParticleEffects()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj:Destroy()
            end
        end
    end

    local function removeLightSources()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end
    end

    removeParticleEffects()
    removeLightSources()
    darkenSky()
end)

features:AddLabel("Pets").TextSize = 20

features:AddButton("Equip Swift Samurai", function()
    unequipPets()
    equipPetsByName("Swift Samurai")
end)

features:AddButton("Equip Tribal Overlord", function()
    unequipPets()
    equipPetsByName("Tribal Overlord")
end)

local features = window:AddTab("Inv Cleaner")

features:AddLabel("Misc").TextSize = 20

local function activateProteinEgg()
    local tool = player.Character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    if tool then
        muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end)

local switch = features:AddSwitch("Egg Devour", function(state)
    running = state
    if state then
        activateProteinEgg()
    end
end)
switch:Set(false)

local itemList = {
    "Tropical Shake",
    "Energy Shake",
    "Protein Bar",
    "TOUGH Bar",
    "Protein Shake",
    "ULTRA Shake",
    "Energy Bar"
}

local function formatEventName(itemName)
    local parts = {}
    for word in itemName:gmatch("%S+") do
        table.insert(parts, word:lower())
    end
    for i = 2, #parts do
        parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2)
    end
    return table.concat(parts)
end

local function activateItems()
    for _, itemName in ipairs(itemList) do
        local tool = player.Character:FindFirstChild(itemName) or player.Backpack:FindFirstChild(itemName)
        if tool then
            local eventName = formatEventName(itemName) 
            muscleEvent:FireServer(eventName, tool)
        end
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateItems()
            task.wait(1)
        else
            task.wait(1)
        end
    end
end)

local switch = features:AddSwitch("Eat Everything", function(state)
    running = state
    if state then
        activateItems()
    end
end)
switch:Set(false)


local features = window:AddTab("Teleports") 
features:Show() 

features:AddLabel("Main").TextSize = 20

features:AddButton("Tiny Island",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-37.1, 9.2, 1919)
	end)

features:AddButton("Main Island",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(16.07, 9.08, 133.8)
	end)

features:AddButton("Beach",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8, 9, -169.2)
	end)

features:AddLabel("Gyms").TextSize = 22

features:AddButton("Muscle King Gym",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8665.4, 17.21, -5792.9)
	end)

features:AddButton("Jungle Gym",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8543, 6.8, 2400)
	end)

features:AddButton("Legends Gym",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(4516, 991.5, -3856)
	end)

features:AddButton("Infernal Gym",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-6759, 7.36, -1284)
	end)

features:AddButton("Mythical Gym",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(2250, 7.37, 1073.2)
	end)

features:AddButton("Frost Gym",function()
    local player = game.Players.LocalPlayer
    local char = player.Character or Player.CharacterAdded:wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-2623, 7.36, -409)
	end)

local statsTab = window:AddTab("Stats")

local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local strengthStat = leaderstats:WaitForChild("Strength")
local rebirthsStat = leaderstats:WaitForChild("Rebirths")
local durabilityStat = player:WaitForChild("Durability")

local function formatNumber(number)
    local isNegative = number < 0
    number = math.abs(number)

    if number >= 1e15 then
        return (isNegative and "-" or "") .. string.format("%.2fQa", number / 1e15)
    elseif number >= 1e12 then
        return (isNegative and "-" or "") .. string.format("%.2fT", number / 1e12)
    elseif number >= 1e9 then
        return (isNegative and "-" or "") .. string.format("%.2fB", number / 1e9)
    elseif number >= 1e6 then
        return (isNegative and "-" or "") .. string.format("%.2fM", number / 1e6)
    elseif number >= 1e3 then
        return (isNegative and "-" or "") .. string.format("%.2fK", number / 1e3)
    else
        return (isNegative and "-" or "") .. string.format("%.2f", number)
    end
end

local timeLabel = statsTab:AddLabel("Time:")
timeLabel.TextSize = 24


local stopwatchLabel = statsTab:AddLabel("0d 0h 0m 0s")
stopwatchLabel.TextSize = 20


local projectedRebirthsLabel = statsTab:AddLabel("Projected Rebirths: 0 /Hour | 0 /Day")
projectedRebirthsLabel.TextSize = 20


local projectedStrengthLabel = statsTab:AddLabel("Projected Strength: 0 /Hour | 0 /Day")
projectedStrengthLabel.TextSize = 20


local projectedDurabilityLabel = statsTab:AddLabel("Projected Durability: 0 /Hour | 0 /Day")
projectedDurabilityLabel.TextSize = 20


statsTab:AddLabel("").TextSize = 10

local statsLabel = statsTab:AddLabel("Stats:")
statsLabel.TextSize = 24

local rebirthsLabel = statsTab:AddLabel("Rebirths: 0 | Gained: 0")
rebirthsLabel.TextSize = 20

local strengthLabel = statsTab:AddLabel("Strength: 0 | Gained: 0")
strengthLabel.TextSize = 20

local durabilityLabel = statsTab:AddLabel("Durability: 0 | Gained: 0")
durabilityLabel.TextSize = 20



local startTime = tick()
local initialStrength = strengthStat.Value
local initialDurability = durabilityStat.Value
local initialRebirths = rebirthsStat.Value

task.spawn(function()
    local lastUpdate = 0

    while true do
        local currentTime = tick()
        local elapsedTime = currentTime - startTime
        local days = math.floor(elapsedTime / (24 * 3600))
        local hours = math.floor((elapsedTime % (24 * 3600)) / 3600)
        local minutes = math.floor((elapsedTime % 3600) / 60)
        local seconds = math.floor(elapsedTime % 60)

        stopwatchLabel.Text = string.format("%dd %dh %dm %ds", days, hours, minutes, seconds)

        local currentStrength = strengthStat.Value
        local currentRebirths = rebirthsStat.Value
        local currentDurability = durabilityStat.Value

        local sessionStrengthDelta = currentStrength - initialStrength
        local sessionDurabilityDelta = currentDurability - initialDurability
        local sessionRebirthsDelta = currentRebirths - initialRebirths

        rebirthsLabel.Text = "♻️Rebirths: " .. formatNumber(currentRebirths) .. " | Gained: " .. formatNumber(sessionRebirthsDelta)
        strengthLabel.Text = "💪Strength: " .. formatNumber(currentStrength) .. " | Gained: " .. formatNumber(sessionStrengthDelta)
        durabilityLabel.Text = "🛡️Durability: " .. formatNumber(currentDurability) .. " | Gained: " .. formatNumber(sessionDurabilityDelta)
        

        if currentTime - lastUpdate >= 6 then
            lastUpdate = currentTime

            local rebirthsPerSecond = sessionRebirthsDelta / elapsedTime
            local strengthPerSecond = sessionStrengthDelta / elapsedTime
            local durabilityPerSecond = sessionDurabilityDelta / elapsedTime

            local secondsPerHour = 3600
            local secondsPerDay = 86400

            local rebirthsPerHour = math.floor(rebirthsPerSecond * secondsPerHour)
            local strengthPerHour = math.floor(strengthPerSecond * secondsPerHour)
            local durabilityPerHour = math.floor(durabilityPerSecond * secondsPerHour)

            local projectedRebirths = math.floor(rebirthsPerSecond * secondsPerDay)
            local projectedStrength = math.floor(strengthPerSecond * secondsPerDay)
            local projectedDurability = math.floor(durabilityPerSecond * secondsPerDay)

            projectedRebirthsLabel.Text = "♻️Rebirth Pace: " .. formatNumber(rebirthsPerHour) .. "/Hour | " .. formatNumber(projectedRebirths) .. "/Day"
            projectedStrengthLabel.Text = "💪Strength Pace: " .. formatNumber(strengthPerHour) .. "/Hour | " .. formatNumber(projectedStrength) .. "/Day"
            projectedDurabilityLabel.Text = "🛡️Durability Pace: " .. formatNumber(durabilityPerHour) .. "/Hour | " .. formatNumber(projectedDurability) .. "/Day"
        end

        task.wait(0.05)
    end
end)

local infoTab = window:AddTab("Info")
infoTab:Show()
infoTab:AddLabel("Made by Henne").TextSize = 20
infoTab:AddLabel("Any Problems/Questions? -> imhenne187 on Discord").TextSize = 20
infoTab:AddLabel("")
local wLabel = infoTab:AddLabel("VERSION//1.0")
wLabel.TextSize = 40
wLabel.Font = Enum.Font.Arcade
