-- Custom ImGui-Style UI Library for Roblox Executor
local UILibrary = {}

-- Create a new window
function UILibrary:CreateWindow(options)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Grok3TestGui"
    screenGui.Parent = game.CoreGui
    screenGui.Enabled = false -- Start hidden

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, options.Size.X, 0, options.Size.Y)
    mainFrame.Position = UDim2.new(0.5, -options.Size.X / 2, 0.5, -options.Size.Y / 2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- ImGui dark background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    titleLabel.Text = options.Title
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame

    -- Make the GUI draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleLabel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local window = {Frame = mainFrame, Pages = {}, Sidebar = nil, ScreenGui = screenGui}

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
            tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabButton.TextSize = 14
            tabButton.Font = Enum.Font.SourceSans
            tabButton.Parent = sidebarFrame

            -- ImGui-style hover effect
            tabButton.MouseEnter:Connect(function()
                if not (window.Pages[name] and window.Pages[name].Frame.Visible) then
                    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end
            end)
            tabButton.MouseLeave:Connect(function()
                if not (window.Pages[name] and window.Pages[name].Frame.Visible) then
                    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end)

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
        pageFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
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
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
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
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownFrame

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.5, 0, 1, 0)
            dropdownButton.Position = UDim2.new(0.5, 0, 0, 0)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownButton.Text = options.Default
            dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownButton.TextSize = 14
            dropdownButton.Font = Enum.Font.SourceSans
            dropdownButton.Parent = dropdownFrame

            -- ImGui-style hover effect
            dropdownButton.MouseEnter:Connect(function()
                dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)
            dropdownButton.MouseLeave:Connect(function()
                dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)

            local selected = options.Default
            dropdownButton.MouseButton1Click:Connect(function()
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
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
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
            valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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

        -- Function to add a color picker
        function page:AddColorPicker(options)
            local pickerFrame = Instance.new("Frame")
            pickerFrame.Size = UDim2.new(1, 0, 0, 30)
            pickerFrame.BackgroundTransparency = 1
            pickerFrame.Parent = pageFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = options.Name
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = pickerFrame

            local colorDisplay = Instance.new("Frame")
            colorDisplay.Size = UDim2.new(0, 20, 0, 20)
            colorDisplay.Position = UDim2.new(0.5, 0, 0, 5)
            colorDisplay.BackgroundColor3 = options.Default
            colorDisplay.Parent = pickerFrame

            local rSlider = Instance.new("Frame")
            rSlider.Size = UDim2.new(0.5, 0, 0, 5)
            rSlider.Position = UDim2.new(0.55, 0, 0, 5)
            rSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            rSlider.Parent = pickerFrame

            local rFill = Instance.new("Frame")
            rFill.Size = UDim2.new(options.Default.R, 0, 1, 0)
            rFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            rFill.Parent = rSlider

            local gSlider = Instance.new("Frame")
            gSlider.Size = UDim2.new(0.5, 0, 0, 5)
            gSlider.Position = UDim2.new(0.55, 0, 0, 15)
            gSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            gSlider.Parent = pickerFrame

            local gFill = Instance.new("Frame")
            gFill.Size = UDim2.new(options.Default.G, 0, 1, 0)
            gFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            gFill.Parent = gSlider

            local bSlider = Instance.new("Frame")
            bSlider.Size = UDim2.new(0.5, 0, 0, 5)
            bSlider.Position = UDim2.new(0.55, 0, 0, 25)
            bSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            bSlider.Parent = pickerFrame

            local bFill = Instance.new("Frame")
            bFill.Size = UDim2.new(options.Default.B, 0, 1, 0)
            bFill.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
            bFill.Parent = bSlider

            local color = options.Default
            local draggingR, draggingG, draggingB = false, false, false

            local function setupSlider(slider, fill, component)
                local dragging = false
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = input.Position.X
                        local barPos = slider.AbsolutePosition.X
                        local barSize = slider.AbsoluteSize.X
                        local relativePos = math.clamp((mousePos - barPos) / barSize, 0, 1)
                        if component == "R" then
                            color = Color3.new(relativePos, color.G, color.B)
                            fill.Size = UDim2.new(relativePos, 0, 1, 0)
                        elseif component == "G" then
                            color = Color3.new(color.R, relativePos, color.B)
                            fill.Size = UDim2.new(relativePos, 0, 1, 0)
                        elseif component == "B" then
                            color = Color3.new(color.R, color.G, relativePos)
                            fill.Size = UDim2.new(relativePos, 0, 1, 0)
                        end
                        colorDisplay.BackgroundColor3 = color
                        if options.Callback then
                            options.Callback(color)
                        end
                    end
                end)
            end

            setupSlider(rSlider, rFill, "R")
            setupSlider(gSlider, gFill, "G")
            setupSlider(bSlider, bFill, "B")

            return {GetColor = function() return color end}
        end

        -- Function to add a text box (for Lua tab)
        function page:AddTextBox(options)
            local textBoxFrame = Instance.new("Frame")
            textBoxFrame.Size = UDim2.new(1, 0, 0, 100)
            textBoxFrame.BackgroundTransparency = 1
            textBoxFrame.Parent = pageFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = options.Name
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = textBoxFrame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, 0, 0, 60)
            textBox.Position = UDim2.new(0, 0, 0, 20)
            textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            textBox.TextColor3 = Color3.fromRGB(200, 200, 200)
            textBox.TextSize = 14
            textBox.Font = Enum.Font.SourceSans
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.TextYAlignment = Enum.TextYAlignment.Top
            textBox.TextWrapped = true
            textBox.MultiLine = true
            textBox.Parent = textBoxFrame

            local executeButton = Instance.new("TextButton")
            executeButton.Size = UDim2.new(1, 0, 0, 20)
            executeButton.Position = UDim2.new(0, 0, 0, 80)
            executeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            executeButton.Text = "Execute"
            executeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            executeButton.TextSize = 14
            executeButton.Font = Enum.Font.SourceSans
            executeButton.Parent = textBoxFrame

            executeButton.MouseEnter:Connect(function()
                executeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)
            executeButton.MouseLeave:Connect(function()
                executeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)

            executeButton.MouseButton1Click:Connect(function()
                if options.Callback then
                    options.Callback(textBox.Text)
                end
            end)

            return {GetText = function() return textBox.Text end}
        end

        -- Function to add a button (for Other tab)
        function page:AddButton(options)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Size = UDim2.new(1, 0, 0, 30)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = pageFrame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.Text = options.Name
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
            button.TextSize = 14
            button.Font = Enum.Font.SourceSans
            button.Parent = buttonFrame

            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)

            button.MouseButton1Click:Connect(function()
                if options.Callback then
                    options.Callback()
                end
            end)
        end

        window.Pages[name] = page
        return page
    end

    return window
end

-- ESP and Aimbot Implementation
local ESP = {
    Enabled = false,
    Box = false,
    CornerBox = "Type",
    Name = false,
    Tracers = false,
    HealthInfo = false,
    Teamcheck = false,
    Color = Color3.fromRGB(255, 0, 0),
    Drawings = {}
}

local Aimbot = {
    Enabled = false,
    Aimlock = false,
    Triggerbot = false,
    FOV = 180,
    UseFOV = false,
    Teamcheck = false
}

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = localPlayer:GetMouse()

-- Function to create ESP drawings for a player
local function createESP(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then return end

    local rootPart = character.HumanoidRootPart
    local head = character.Head
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    if ESP.Teamcheck and player.Team == localPlayer.Team then return end

    local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then return end

    -- Calculate box size from bottom to top of player
    local topPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
    local bottomPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
    local boxHeight = math.abs(topPos.Y - bottomPos.Y)
    local boxWidth = boxHeight * 0.6 -- Consistent width for both types

    -- Create box drawing
    local box = Drawing.new("Square")
    box.Visible = ESP.Box
    box.Position = Vector2.new(screenPos.X - boxWidth / 2, topPos.Y)
    box.Size = Vector2.new(boxWidth, boxHeight)
    box.Color = ESP.Color
    box.Thickness = 2
    box.Filled = false

    -- Highlight for Full type
    local highlight = Drawing.new("Square")
    highlight.Visible = ESP.Box and ESP.CornerBox == "Full"
    highlight.Position = box.Position
    highlight.Size = box.Size
    highlight.Color = ESP.Color
    highlight.Transparency = 0.8 -- Semi-transparent
    highlight.Filled = true

    -- Name drawing (on head)
    local name = Drawing.new("Text")
    name.Visible = ESP.Name
    name.Text = player.Name
    name.Size = 16
    name.Color = ESP.Color
    name.Position = Vector2.new(topPos.X, topPos.Y - 30)
    name.Center = true

    -- Health info (horizontal, above name)
    local healthBar = Drawing.new("Line")
    healthBar.Visible = ESP.HealthInfo
    healthBar.From = Vector2.new(topPos.X - 20, topPos.Y - 10)
    healthBar.To = Vector2.new(topPos.X + 20, topPos.Y - 10)
    healthBar.Color = ESP.Color
    healthBar.Thickness = 3

    local health = humanoid.Health / humanoid.MaxHealth
    healthBar.To = Vector2.new(healthBar.From.X + 40 * health, healthBar.From.Y)

    local healthText = Drawing.new("Text")
    healthText.Visible = ESP.HealthInfo
    healthText.Text = tostring(math.floor(health * 100)) .. "%"
    healthText.Size = 14
    healthText.Color = ESP.Color
    healthText.Position = Vector2.new(topPos.X, topPos.Y - 10)
    healthText.Center = true

    -- Tracer
    local tracer = Drawing.new("Line")
    tracer.Visible = ESP.Tracers
    tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
    tracer.Color = ESP.Color
    tracer.Thickness = 2

    if ESP.CornerBox == "Type" then
        -- Corner box style
        box.Size = Vector2.new(boxWidth * 0.3, boxHeight * 0.3)
        box.Position = Vector2.new(screenPos.X - boxWidth * 0.15, screenPos.Y - boxHeight * 0.15)
    end

    ESP.Drawings[player] = {Box = box, Highlight = highlight, Name = name, HealthBar = healthBar, HealthText = healthText, Tracer = tracer}
end

-- Function to update ESP
local function updateESP()
    for _, drawing in pairs(ESP.Drawings) do
        drawing.Box:Remove()
        drawing.Highlight:Remove()
        drawing.Name:Remove()
        drawing.HealthBar:Remove()
        drawing.HealthText:Remove()
        drawing.Tracer:Remove()
    end
    ESP.Drawings = {}

    if not ESP.Enabled then return end

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            createESP(player)
        end
    end
end

-- Aimbot Implementation
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local closestDistance = Aimbot.UseFOV and Aimbot.FOV or math.huge

    for _, player in pairs(players:GetPlayers()) do
        if player == localPlayer then continue end
        if Aimbot.Teamcheck and player.Team == localPlayer.Team then continue end

        local character = player.Character
        if not character or not character:FindFirstChild("Head") then continue end

        local head = character.Head
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
        end
    end

    return closestPlayer
end

-- Aimlock
game:GetService("RunService").RenderStepped:Connect(function()
    if Aimbot.Enabled and Aimbot.Aimlock then
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
        end
    end
end)

-- Triggerbot
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if Aimbot.Enabled and Aimbot.Triggerbot and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            -- Simulate a "kill" (for demonstration; actual exploits might use different methods)
            target.Character.Humanoid.Health = 0
        end
    end
end)

-- Player added/removed handling
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESP.Enabled then
            createESP(player)
        end
    end)
end)

players.PlayerRemoving:Connect(function(player)
    if ESP.Drawings[player] then
        ESP.Drawings[player].Box:Remove()
        ESP.Drawings[player].Highlight:Remove()
        ESP.Drawings[player].Name:Remove()
        ESP.Drawings[player].HealthBar:Remove()
        ESP.Drawings[player].HealthText:Remove()
        ESP.Drawings[player].Tracer:Remove()
        ESP.Drawings[player] = nil
    end
end)

-- Create the GUI using the UI Library
local MainWindow = UILibrary:CreateWindow({
    Title = "Grok 3 Test",
    Size = Vector2.new(600, 400)
})

-- Bind GUI to Q key
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        MainWindow.ScreenGui.Enabled = not MainWindow.ScreenGui.Enabled
    end
end)

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

-- Visuals Page
local VisualsPage = MainWindow:CreatePage("Visuals")
VisualsPage:AddLabel("VISUALS")

-- Enabled Checkbox
local enabledCheckbox = VisualsPage:AddCheckbox({
    Name = "Enabled",
    Default = false,
    Callback = function(state)
        ESP.Enabled = state
        updateESP()
    end
})

-- Box Checkbox
local boxCheckbox = VisualsPage:AddCheckbox({
    Name = "Box",
    Default = false,
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
    Default = false,
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

-- Teamcheck Checkbox
local teamcheckCheckbox = VisualsPage:AddCheckbox({
    Name = "Teamcheck",
    Default = false,
    Callback = function(state)
        ESP.Teamcheck = state
        updateESP()
    end
})

-- Color Picker
local colorPicker = VisualsPage:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        ESP.Color = color
        updateESP()
    end
})

-- Aimbot Page
local AimbotPage = MainWindow:CreatePage("Aimbot")
AimbotPage:AddLabel("AIMBOT")

-- Enabled Checkbox
local aimbotEnabledCheckbox = AimbotPage:AddCheckbox({
    Name = "Enabled",
    Default = false,
    Callback = function(state)
        Aimbot.Enabled = state
    end
})

-- Aimlock Checkbox
local aimlockCheckbox = AimbotPage:AddCheckbox({
    Name = "Aimlock",
    Default = false,
    Callback = function(state)
        Aimbot.Aimlock = state
    end
})

-- Triggerbot Checkbox
local triggerbotCheckbox = AimbotPage:AddCheckbox({
    Name = "Triggerbot",
    Default = false,
    Callback = function(state)
        Aimbot.Triggerbot = state
    end
})

-- Use FOV Checkbox
local useFOVCheckbox = AimbotPage:AddCheckbox({
    Name = "Use FOV",
    Default = false,
    Callback = function(state)
        Aimbot.UseFOV = state
    end
})

-- FOV Slider
local fovSlider = AimbotPage:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 360,
    Default = 180,
    Callback = function(value)
        Aimbot.FOV = value
    end
})

-- Teamcheck Checkbox
local aimbotTeamcheckCheckbox = AimbotPage:AddCheckbox({
    Name = "Teamcheck",
    Default = false,
    Callback = function(state)
        Aimbot.Teamcheck = state
    end
})

-- Settings Page
local SettingsPage = MainWindow:CreatePage("Settings")
SettingsPage:AddLabel("SETTINGS")

-- Toggle Keybind (for demonstration; actual keybind change requires more UI)
SettingsPage:AddLabel("Toggle Key: Q")

-- Lua Page
local LuaPage = MainWindow:CreatePage("Lua")
LuaPage:AddLabel("LUA EXECUTOR")

-- Lua Executor Textbox
local luaTextBox = LuaPage:AddTextBox({
    Name = "Enter Lua Code",
    Callback = function(code)
        local func, err = loadstring(code)
        if func then
            func()
        else
            warn("Lua Error: " .. err)
        end
    end
})

-- Other Page
local OtherPage = MainWindow:CreatePage("Other")
OtherPage:AddLabel("OTHER")

-- Kill All Button
OtherPage:AddButton({
    Name = "Kill All",
    Callback = function()
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
    end
})

-- Speed Hack Button
OtherPage:AddButton({
    Name = "Speed Hack (x2)",
    Callback = function()
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = 32 -- Default is 16
        end
    end
})

-- Reset Speed Button
OtherPage:AddButton({
    Name = "Reset Speed",
    Callback = function()
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

-- Show the GUI (initially hidden, toggle with Q)
-- MainWindow:Show()
