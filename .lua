-- Custom UI Library for Roblox Executor
local UILibrary = {}

-- Create a new window
function UILibrary:CreateWindow(options)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Grok3TestGui"
    screenGui.Parent = game.CoreGui -- Use CoreGui for executor GUIs

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, options.Size.X, 0, options.Size.Y)
    mainFrame.Position = UDim2.new(0.5, -options.Size.X / 2, 0.5, -options.Size.Y / 2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleLabel.Text = options.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame

    local window = {Frame = mainFrame, Pages = {}, Sidebar = nil}
    
    -- Function to show the window
    function window:Show()
        screenGui.Enabled = true
    end

    -- Function to create a sidebar
    function window:CreateSidebar(options)
        local sidebarFrame = Instance.new("Frame")
        sidebarFrame.Size = UDim2.new(0, options.Width, 1, -30)
        sidebarFrame.Position = UDim2.new(0, 0, 0, 30)
        sidebarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sidebarFrame.Parent = mainFrame

        local sidebarList = Instance.new("UIListLayout")
        sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
        sidebarList.Parent = sidebarFrame

        local sidebar = {Frame = sidebarFrame, Tabs = {}}

        -- Function to add a tab to the sidebar
        function sidebar:AddTab(name, isActive)
            local tabButton = Instance.new("TextButton")
            tabButton.Size = UDim2.new(1, 0, 0, 40)
            tabButton.BackgroundColor3 = isActive and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
            tabButton.Text = name
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabButton.TextSize = 14
            tabButton.Font = Enum.Font.SourceSans
            tabButton.Parent = sidebarFrame

            tabButton.MouseButton1Click:Connect(function()
                for _, t in pairs(sidebar.Tabs) do
                    t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    if window.Pages[t.Name] then
                        window.Pages[t.Name].Frame.Visible = false
                    end
                end
                tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                if window.Pages[name] then
                    window.Pages[name].Frame.Visible = true
                end
            end)

            table.insert(sidebar.Tabs, {Name = name, Button = tabButton})
        end

        window.Sidebar = sidebar
        return sidebar
    end

    -- Function to create a page
    function window:CreatePage(name)
        local pageFrame = Instance.new("Frame")
        pageFrame.Size = UDim2.new(1, -150, 1, -30)
        pageFrame.Position = UDim2.new(0, 150, 0, 30)
        pageFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        pageFrame.Visible = false
        pageFrame.Parent = mainFrame

        local pageList = Instance.new("UIListLayout")
        pageList.SortOrder = Enum.SortOrder.LayoutOrder
        pageList.Padding = UDim.new(0, 5)
        pageList.Parent = pageFrame

        local page = {Frame = pageFrame}

        -- Function to add a label
        function page:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 16
            label.Font = Enum.Font.SourceSansBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = pageFrame
        end

        -- Function to add a checkbox
        function page:AddCheckbox(options)
            local checkboxFrame = Instance.new("Frame")
            checkboxFrame.Size = UDim2.new(1, 0, 0, 30)
            checkboxFrame.BackgroundTransparency = 1
            checkboxFrame.Parent = pageFrame

            local checkbox = Instance.new("TextButton")
            checkbox.Size = UDim2.new(0, 20, 0, 20)
            checkbox.Position = UDim2.new(0, 5, 0, 5)
            checkbox.BackgroundColor3 = options.Default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            checkbox.Text = ""
            checkbox.Parent = checkboxFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -30, 1, 0)
            label.Position = UDim2.new(0, 30, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = options.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = checkboxFrame

            local state = options.Default
            checkbox.MouseButton1Click:Connect(function()
                state = not state
                checkbox.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                if options.Callback then
                    options.Callback(state)
                end
            end)

            return {GetState = function() return state end}
        end

        -- Function to add a dropdown
        function page:AddDropdown(options)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = pageFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = options.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownFrame

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.5, 0, 1, 0)
            dropdownButton.Position = UDim2.new(0.5, 0, 0, 0)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownButton.Text = options.Default
            dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownButton.TextSize = 14
            dropdownButton.Font = Enum.Font.SourceSans
            dropdownButton.Parent = dropdownFrame

            local selected = options.Default
            dropdownButton.MouseButton1Click:Connect(function()
                -- Simulate a dropdown (for simplicity, cycle through options)
                local currentIndex = 0
                for i, option in ipairs(options.Options) do
                    if option == selected then
                        currentIndex = i
                        break
                    end
                end
                local nextIndex = (currentIndex % #options.Options) + 1
                selected = options.Options[nextIndex]
                dropdownButton.Text = selected
                if options.Callback then
                    options.Callback(selected)
                end
            end)

            return {GetSelected = function() return selected end}
        end

        -- Function to add a slider
        function page:AddSlider(options)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 30)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = pageFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = options.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(0.5, 0, 0, 10)
            sliderBar.Position = UDim2.new(0.3, 0, 0.5, -5)
            sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderBar.Parent = sliderFrame

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((options.Default - options.Min) / (options.Max - options.Min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            fill.Parent = sliderBar

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
            valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(options.Default)
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.Parent = sliderFrame

            local value = options.Default
            local dragging = false

            local inputService = game:GetService("UserInputService")
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            inputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = input.Position.X
                    local barPos = sliderBar.AbsolutePosition.X
                    local barSize = sliderBar.AbsoluteSize.X
                    local relativePos = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    value = math.floor(options.Min + (relativePos * (options.Max - options.Min)))
                    fill.Size = UDim2.new(relativePos, 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    if options.Callback then
                        options.Callback(value)
                    end
                end
            end)

            return {GetValue = function() return value end}
        end

        window.Pages[name] = page
        return page
    end

    return window
end

-- ESP Implementation
local ESP = {
    Enabled = false,
    Box = false,
    CornerBox = "Type",
    Name = false,
    Tracers = false,
    HealthInfo = false,
    DrawFOV = false,
    FOV = 180,
    Teamcheck = false,
    Drawings = {}
}

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Function to create a 2D box around a player
local function createBox(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    if ESP.Teamcheck and player.Team == localPlayer.Team then return end

    local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then return end

    local size = (camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y) * 1.5
    local boxSize = Vector2.new(size, size * 1.5)

    -- Create box drawing
    local box = Drawing.new("Square")
    box.Visible = ESP.Box
    box.Position = Vector2.new(screenPos.X - boxSize.X / 2, screenPos.Y - boxSize.Y / 2)
    box.Size = boxSize
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Filled = false

    if ESP.CornerBox == "Type" then
        -- Corner box style (only draw corners)
        box.Size = boxSize * 0.3
        box.Position = box.Position + Vector2.new(boxSize.X * 0.35, boxSize.Y * 0.35)
    end

    -- Name drawing
    local name = Drawing.new("Text")
    name.Visible = ESP.Name
    name.Text = player.Name
    name.Size = 16
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Position = Vector2.new(screenPos.X, screenPos.Y - boxSize.Y / 2 - 20)
    name.Center = true

    -- Health info
    local healthBar = Drawing.new("Line")
    healthBar.Visible = ESP.HealthInfo
    healthBar.From = Vector2.new(screenPos.X + boxSize.X / 2 + 5, screenPos.Y - boxSize.Y / 2)
    healthBar.To = Vector2.new(screenPos.X + boxSize.X / 2 + 5, screenPos.Y + boxSize.Y / 2)
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 3

    local health = humanoid.Health / humanoid.MaxHealth
    healthBar.To = Vector2.new(healthBar.From.X, healthBar.From.Y + (healthBar.To.Y - healthBar.From.Y) * health)

    -- Tracer
    local tracer = Drawing.new("Line")
    tracer.Visible = ESP.Tracers
    tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Thickness = 2

    ESP.Drawings[player] = {Box = box, Name = name, HealthBar = healthBar, Tracer = tracer}
end

-- Function to update ESP
local function updateESP()
    for _, drawing in pairs(ESP.Drawings) do
        drawing.Box:Remove()
        drawing.Name:Remove()
        drawing.HealthBar:Remove()
        drawing.Tracer:Remove()
    end
    ESP.Drawings = {}

    if not ESP.Enabled then return end

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            createBox(player)
        end
    end
end

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = 180
fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 2
fovCircle.Filled = false

-- Update loop
game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()

    fovCircle.Visible = ESP.DrawFOV and ESP.Enabled
    fovCircle.Radius = ESP.FOV
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)

-- Player added/removed handling
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESP.Enabled then
            createBox(player)
        end
    end)
end)

players.PlayerRemoving:Connect(function(player)
    if ESP.Drawings[player] then
        ESP.Drawings[player].Box:Remove()
        ESP.Drawings[player].Name:Remove()
        ESP.Drawings[player].HealthBar:Remove()
        ESP.Drawings[player].Tracer:Remove()
        ESP.Drawings[player] = nil
    end
end)

-- Create the GUI using the UI Library
local MainWindow = UILibrary:CreateWindow({
    Title = "Grok 3 Test",
    Size = Vector2.new(600, 400)
})

-- Create the sidebar
local Sidebar = MainWindow:CreateSidebar({
    Width = 150
})

-- Add sidebar tabs
Sidebar:AddTab("Aimbot")
Sidebar:AddTab("Visuals", true)
Sidebar:AddTab("Settings")
Sidebar:AddTab("Lua")
Sidebar:AddTab("Other")

-- Create the Visuals page
local VisualsPage = MainWindow:CreatePage("Visuals")

-- Add elements to the Visuals page
VisualsPage:AddLabel("VISUALS")

-- Enabled Checkbox
local enabledCheckbox = VisualsPage:AddCheckbox({
    Name = "Enabled",
    Default = true,
    Callback = function(state)
        ESP.Enabled = state
        updateESP()
    end
})

-- Box Checkbox
local boxCheckbox = VisualsPage:AddCheckbox({
    Name = "Box",
    Default = true,
    Callback = function(state)
        ESP.Box = state
        updateESP()
    end
})

-- 2D Corner Box Dropdown
local cornerBoxDropdown = VisualsPage:AddDropdown({
    Name = "2D Corner Box",
    Options = {"Type", "Full"},
    Default = "Type",
    Callback = function(selected)
        ESP.CornerBox = selected
        updateESP()
    end
})

-- Name Checkbox
local nameCheckbox = VisualsPage:AddCheckbox({
    Name = "Name",
    Default = true,
    Callback = function(state)
        ESP.Name = state
        updateESP()
    end
})

-- Tracers Checkbox
local tracersCheckbox = VisualsPage:AddCheckbox({
    Name = "Tracers",
    Default = false,
    Callback = function(state)
        ESP.Tracers = state
        updateESP()
    end
})

-- Health Info Checkbox
local healthInfoCheckbox = VisualsPage:AddCheckbox({
    Name = "Health Info",
    Default = false,
    Callback = function(state)
        ESP.HealthInfo = state
        updateESP()
    end
})

-- Draw FOV Checkbox
local drawFOVCheckbox = VisualsPage:AddCheckbox({
    Name = "Draw FOV",
    Default = true,
    Callback = function(state)
        ESP.DrawFOV = state
    end
})

-- FOV Slider
local fovSlider = VisualsPage:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 360,
    Default = 180,
    Callback = function(value)
        ESP.FOV = value
    end
})

-- Teamcheck Checkbox
local teamcheckCheckbox = VisualsPage:AddCheckbox({
    Name = "Teamcheck",
    Default = false,
    Callback = function(state)
        ESP.Teamcheck = state
        updateESP()
    end
})

-- Show the GUI
MainWindow:Show()
