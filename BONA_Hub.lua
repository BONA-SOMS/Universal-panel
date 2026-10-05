local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- === SETTINGS ===
local WolfImage = "rbxassetid://16441315801"
local VIP_PASSWORD = "BONA"
local MENU_TITLE = "BONA HUB V43.1 ANTI-FLING"
local CREDITS_TEXT = "made by BONA"

-- Remove old UI if exists
if game.CoreGui:FindFirstChild("BONA_Final_UI") then game.CoreGui.BONA_Final_UI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BONA_Final_UI"
ScreenGui.ResetOnSpawn = false

-- === SAFE SCRIPT LOADER ===
local function SafeLoad(url)
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success then
        local func, err = loadstring(content)
        if func then pcall(func) else warn("BONA Hub Error: " .. tostring(err)) end
    else
        warn("BONA Hub: Failed to fetch script from " .. url)
    end
end

-- === WINDOW ANIMATION ===
local function AnimateWindow(frame)
    frame.BackgroundTransparency = 1
    frame.Visible = true
    local targetSize = (frame.Name == "Main" and UDim2.new(0, 470, 0, 350) or UDim2.new(0, 420, 0, 300))
    frame.Size = UDim2.new(0, targetSize.X.Offset - 20, 0, targetSize.Y.Offset - 20)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize, BackgroundTransparency = 0}):Play()
end

-- === SMOOTH DRAGGING ===
local function MakeDraggable(gui, target)
    local dragging, dragInput, dragStart, startPos
    local targetObj = target or gui
    gui.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = targetObj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local endPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(targetObj, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = endPos}):Play()
        end
    end)
end

-- === CREDITS FUNCTION ===
local function AddCredits(parent)
    local credits = Instance.new("TextLabel", parent)
    credits.Size = UDim2.new(1, -10, 0, 15)
    credits.Position = UDim2.new(0, 0, 1, -18)
    credits.BackgroundTransparency = 1
    credits.Text = CREDITS_TEXT
    credits.TextColor3 = Color3.new(1, 1, 1)
    credits.TextTransparency = 0.6
    credits.Font = Enum.Font.SourceSans
    credits.TextSize = 12
    credits.TextXAlignment = "Right"
end

-- === TOP PANEL / WALLHOP ===
local TopLabel = Instance.new("TextButton", ScreenGui)
TopLabel.Size = UDim2.new(0, 150, 0, 30); TopLabel.Position = UDim2.new(0.5, -75, 0, 10)
TopLabel.BackgroundTransparency = 0.5; TopLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
TopLabel.Text = "BONA.panel"; TopLabel.TextColor3 = Color3.new(1, 1, 1)
TopLabel.Font = Enum.Font.Code; TopLabel.TextSize = 14; TopLabel.ZIndex = 10
Instance.new("UICorner", TopLabel)
MakeDraggable(TopLabel)

local wallhopActive = false
TopLabel.MouseButton1Click:Connect(function()
    wallhopActive = not wallhopActive
    TopLabel.TextColor3 = wallhopActive and Color3.new(0, 1, 1) or Color3.new(1, 1, 1)
end)

UserInputService.JumpRequest:Connect(function()
    if wallhopActive and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === TOGGLE BUTTONS ===
local function CreateToggle(pos, text)
    local btn = Instance.new("ImageButton", ScreenGui)
    btn.Size = UDim2.new(0, 50, 0, 50); btn.Position = pos; btn.Image = WolfImage; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local l = Instance.new("TextLabel", btn); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextSize = 14
    MakeDraggable(btn); return btn
end

local MainToggle = CreateToggle(UDim2.new(0, 15, 0.5, -55), "L/H")
local ExecToggle = CreateToggle(UDim2.new(0, 15, 0.5, 5), "EXE")

-- === MAIN MENU ===
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Visible = false; Main.Size = UDim2.new(0, 470, 0, 350); Main.Position = UDim2.new(0.5, -235, 0.5, -175); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true
Instance.new("UICorner", Main)
AddCredits(Main)

local TitleBar = Instance.new("Frame", Main); TitleBar.Size = UDim2.new(1,0,0,40); TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", TitleBar)
MakeDraggable(TitleBar, Main)

local TitleText = Instance.new("TextLabel", TitleBar); TitleText.Size = UDim2.new(1,0,1,0); TitleText.BackgroundTransparency = 1; TitleText.Text = MENU_TITLE; TitleText.Font = Enum.Font.GothamBold; TitleText.TextSize = 16
task.spawn(function()
    local h = 0
    while task.wait(0.01) do
        TitleText.TextColor3 = Color3.fromHSV(h, 0.8, 1)
        h = h + 0.005 if h > 1 then h = 0 end
    end
end)

-- Settings Menu
local SettingsBtn = Instance.new("TextButton", TitleBar)
SettingsBtn.Size = UDim2.new(0, 30, 0, 30); SettingsBtn.Position = UDim2.new(1, -35, 0, 5)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); SettingsBtn.Text = "⚙️"; SettingsBtn.TextColor3 = Color3.new(1, 1, 1); SettingsBtn.TextSize = 18
Instance.new("UICorner", SettingsBtn)

local SettingsFrame = Instance.new("Frame", Main)
SettingsFrame.Size = UDim2.new(0, 160, 0, 200); SettingsFrame.Position = UDim2.new(1, 10, 0, 0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SettingsFrame.Visible = false; Instance.new("UICorner", SettingsFrame)
local SetList = Instance.new("UIListLayout", SettingsFrame); SetList.Padding = UDim.new(0, 8); SetList.HorizontalAlignment = "Center"
local SetTitle = Instance.new("TextLabel", SettingsFrame); SetTitle.Size = UDim2.new(1,0,0,40); SetTitle.Text = "SETTINGS"; SetTitle.TextColor3 = Color3.new(1,1,1); SetTitle.BackgroundTransparency = 1; SetTitle.Font = "GothamBold"

SettingsBtn.MouseButton1Click:Connect(function() SettingsFrame.Visible = not SettingsFrame.Visible end)

local function AddSet(name, func_on, func_off)
    local b = Instance.new("TextButton", SettingsFrame); b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.BackgroundColor3 = act and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45,45,45)
        if act then func_on() else func_off() end
    end)
end

AddSet("FPS Boost", function() for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end end, function() end)
AddSet("Full Bright", function() game:GetService("Lighting").Brightness = 2; game:GetService("Lighting").ClockTime = 14; game:GetService("Lighting").GlobalShadows = false end, function() game:GetService("Lighting").GlobalShadows = true end)
AddSet("Semi-Transparent", function() Main.BackgroundTransparency = 0.5 end, function() Main.BackgroundTransparency = 0 end)

-- === EXECUTOR ===
local ExecFrame = Instance.new("Frame", ScreenGui)
ExecFrame.Name = "Exec"
ExecFrame.Visible = false; ExecFrame.Size = UDim2.new(0, 420, 0, 300); ExecFrame.Position = UDim2.new(0.5, -210, 0.5, 50); ExecFrame.BackgroundColor3 = Color3.fromRGB(10,10,10); ExecFrame.Active = true
Instance.new("UICorner", ExecFrame); MakeDraggable(ExecFrame)
AddCredits(ExecFrame)

local CodeBox = Instance.new("TextBox", ExecFrame)
CodeBox.Size = UDim2.new(1,-20,1,-135); CodeBox.Position = UDim2.new(0,10,0,45); CodeBox.BackgroundColor3 = Color3.fromRGB(15,15,15); CodeBox.TextColor3 = Color3.new(0,1,0.4); CodeBox.MultiLine = true
CodeBox.Text = ""; CodeBox.PlaceholderText = "Print Your Script Here..."; CodeBox.ClearTextOnFocus = false; CodeBox.Font = Enum.Font.Code; CodeBox.TextXAlignment = "Left"; CodeBox.TextYAlignment = "Top"; Instance.new("UICorner", CodeBox)

local RunBtn = Instance.new("TextButton", ExecFrame); RunBtn.Size = UDim2.new(0, 100, 0, 35); RunBtn.Position = UDim2.new(0,10,1,-55); RunBtn.Text = "RUN"; RunBtn.BackgroundColor3 = Color3.fromRGB(0,100,50); RunBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", RunBtn)
local ClearBtn = Instance.new("TextButton", ExecFrame); ClearBtn.Size = UDim2.new(0, 100, 0, 35); ClearBtn.Position = UDim2.new(0,120,1,-55); ClearBtn.Text = "CLEAR"; ClearBtn.BackgroundColor3 = Color3.fromRGB(100,20,20); ClearBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", ClearBtn)

MainToggle.MouseButton1Click:Connect(function() if not Main.Visible then AnimateWindow(Main) else Main.Visible = false end end)
ExecToggle.MouseButton1Click:Connect(function() if not ExecFrame.Visible then AnimateWindow(ExecFrame) else ExecFrame.Visible = false end end)

-- === COLUMNS SETUP ===
local function CreateCol(name, x)
    local t = Instance.new("TextLabel", Main); t.Size = UDim2.new(0.33,-10,0,25); t.Position = UDim2.new(x,5,0,45); t.Text = name; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1; t.Font = Enum.Font.GothamBold
    local s = Instance.new("ScrollingFrame", Main); s.Size = UDim2.new(0.33,-10,1,-100); s.Position = UDim2.new(x,5,0,70); s.BackgroundTransparency = 1; s.CanvasSize = UDim2.new(0,0,0,0); s.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", s); l.Padding = UDim.new(0,4)
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() s.CanvasSize = UDim2.new(0,0,0,l.AbsoluteContentSize.Y + 10) end)
    return s
end

local Col1 = CreateCol("SCRIPTS", 0)
local Col2 = CreateCol("FE TROLL", 0.33)
local Col3 = CreateCol("VIP SECTION", 0.66)

local function Add(n, p, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1,-5,0,30); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() pcall(c) end)
end

local function AddToggle(n, p, on, off)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1,-5,0,30); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 10; Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act; b.BackgroundColor3 = act and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(30, 30, 30)
        if act then on() else off() end
    end)
end

-- === COLUMN 1 SCRIPTS ===
Add("Fake Chat", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Fake-Chat-ui-212279") end)
Add("Fling Hub", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Loop-fling-all-247255") end)
Add("Server Hop", Col1, function()
    local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LP) break end end
end)
Add("Rejoin", Col1, function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)

local espActive = false
AddToggle("ESP Players", Col1, function()
    espActive = true; task.spawn(function()
        while espActive do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not p.Character:FindFirstChild("VolkEsp") then
                    local box = Instance.new("BoxHandleAdornment", p.Character); box.Name = "VolkEsp"; box.Adornee = p.Character.HumanoidRootPart; box.AlwaysOnTop = true; box.ZIndex = 5; box.Size = Vector3.new(4, 5, 1); box.Transparency = 0.5; box.Color3 = Color3.new(1, 0, 0)
                end
            end; task.wait(1)
        end
    end)
end, function() espActive = false; for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("VolkEsp") then p.Character.VolkEsp:Destroy() end end end)

AddToggle("Anti-AFK", Col1, function() _G.AFK = LP.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end, function() if _G.AFK then _G.AFK:Disconnect() end end)

local noclipConn
AddToggle("Noclip", Col1, function()
    noclipConn = RunService.Stepped:Connect(function()
        if LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end, function() if noclipConn then noclipConn:Disconnect() end end)

local antiFlingConn
AddToggle("Anti-Fling", Col1, function()
    antiFlingConn = RunService.Stepped:Connect(function()
        if LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end, function() if antiFlingConn then antiFlingConn:Disconnect() end end)

local freeActive = false
AddToggle("Ghost Freecam", Col1, function()
    freeActive = true; camera.CameraType = Enum.CameraType.Scriptable
    task.spawn(function()
        while freeActive do
            local mv = LP.PlayerScripts.ControlScript.MasterControl:GetMoveVector()
            if mv.Magnitude > 0 then
                local dir = (camera.CFrame.LookVector * -mv.Z) + (camera.CFrame.RightVector * mv.X)
                camera.CFrame = camera.CFrame + (dir * 2)
            end
            RunService.RenderStepped:Wait()
        end
    end)
end, function()
    freeActive = false; camera.CameraType = Enum.CameraType.Custom; camera.CameraSubject = LP.Character:FindFirstChild("Humanoid")
end)

local SpeedBox = Instance.new("TextBox", Col1); SpeedBox.Size = UDim2.new(1, -5, 0, 30); SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpeedBox.PlaceholderText = "Speed: 16"; SpeedBox.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", SpeedBox)
SpeedBox.FocusLost:Connect(function() if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = tonumber(SpeedBox.Text) or 16 end end)

Add("bang", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-40K-EMOTES-KEYLESS-170200") end)
Add("coolkid scanner", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-COOLKID-SCANNER-BACKDOOR-SCANNER-COOLKIDS-SCRIPT-202772") end)
Add("System Broken", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-SYSTEM-BROKEN-140660") end)
Add("Emotion", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024") end)
Add("DemonKing V3", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-DEMONKING-HUB-V3-208873") end)
Add("3F Script", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Universal-Script-3F-213873") end)
Add("VR7", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-VR7-45290") end)
Add("FLY GUI", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-FLY-GUI-V11-205450") end)
Add("Infinite Yield", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-infinity-yeild-82786") end)
Add("Molyn Hub", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-MOLYN-DEVELOPMENT-201480") end)
Add("Speed Bust", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Ultrakillish-dash-214092") end)
Add("RC7 Reborn", Col1, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Rc7-reborn-serverside-By-JohnDoeTheDarkness-207683") end)

-- === FE TROLL SCRIPTS ===
Add("Grab Knife", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Grab-Tool-131984") end)
Add("projector exe", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Projecter-exe-136049") end)
Add("mrBean V2", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-MrBean-Rework-V2-48150") end)
Add("Genesis Hub", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Genesis-hub-no-offical-81335") end)
Add("TROLL GUI", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-TROLL-GUI-206043") end)
Add("Ghost Hub", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Keyless-Ghost-Hub-205099") end)
Add("Dropkick", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-THE-REAL-dropkick-177199") end)
Add("Scanner", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Starlight-Scanner-213808") end)
Add("666 Ultimate", Col2, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-V999one-c00lkidd-Ultimate-Hub-GUI-F3X-201675") end)
Add("Close Menu", Col2, function() ScreenGui:Destroy() end)

-- === VIP UNLOCK SYSTEM ===
local VipL = Instance.new("Frame", Col3); VipL.Size = UDim2.new(1,0,0,100); VipL.BackgroundTransparency = 1
local Inp = Instance.new("TextBox", VipL)
Inp.Size = UDim2.new(1,-5,0,30)
Inp.PlaceholderText = "Enter Password"
Inp.Text = ""
Inp.BackgroundColor3 = Color3.fromRGB(40,40,40)
Inp.TextColor3 = Color3.new(1,1,1)
Inp.ClearTextOnFocus = true
Instance.new("UICorner", Inp)

local Btn = Instance.new("TextButton", VipL); Btn.Size = UDim2.new(1,-5,0,30); Btn.Position = UDim2.new(0,0,0,35); Btn.Text = "UNLOCK"; Btn.BackgroundColor3 = Color3.fromRGB(0,150,80); Btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Btn)
local Cont = Instance.new("Frame", Col3); Cont.Size = UDim2.new(1,0,1,0); Cont.BackgroundTransparency = 1; Cont.Visible = false; Instance.new("UIListLayout", Cont).Padding = UDim.new(0,4)

Btn.MouseButton1Click:Connect(function()
    if Inp.Text == VIP_PASSWORD then
        VipL.Visible = false; Cont.Visible = true
    else
        Inp.Text = ""
        Inp.PlaceholderText = "WRONG PASS!"
        task.wait(1.5)
        Inp.PlaceholderText = "Enter Password"
    end
end)

Add("Stigma Hub", Cont, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-Stigma-Ultimate-Executor-FE-48412") end)
Add("Secure Dex", Cont, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-SECURE-DEX-AND-REMOTE-SPY-205256") end)
Add("KRNL PC UI", Cont, function() SafeLoad("https://rawscripts.net/raw/Universal-Script-KrnlPCUI-212874") end)

RunBtn.MouseButton1Click:Connect(function()
    local code = CodeBox.Text
    local l, e = loadstring(code)
    if l then pcall(l) else warn("Executor Error: "..tostring(e)) end
end)
ClearBtn.MouseButton1Click:Connect(function() CodeBox.Text = "" end)
