-- Custom ImGui-Style UI Library for Roblox Executor
local UILibrary = {}

-- Create a new window
function UILibrary:CreateWindow(options)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Grok3TestGui"
    screenGui.Parent = game.CoreGui
    screenGui.Enabled = true -- Start visible

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, options.Size.X, 0, options.Size.Y)
    mainFrame.Position = UDim2.new(0.5, -options.Size.X / 2, 0.5, -options.Size.Y / 2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- ImGui dark background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.BackgroundTransparency = 1 -- Start transparent for animation

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    titleLabel.Text = options.Title
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame
    titleLabel.BackgroundTransparency = 1

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

    local window = {Frame = mainFrame, Pages = {}, Sidebar = nil, ScreenGui = screenGui, Theme = "Dark"}

    -- Function to update theme
    function window:UpdateTheme(theme)
        window.Theme = theme
        if theme == "Dark" then
            mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            if window.Sidebar then
                window.Sidebar.Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                for _, tab in pairs(window.Sidebar.Tabs) do
                    tab.Button.BackgroundColor3 = window.Pages[tab.Name].Frame.Visible and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
                    tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            for _, page in pairs(window.Pages) do
                page.Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                for _, child in pairs(page.Frame:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child.TextColor3 = Color3.fromRGB(200, 200, 200)
                    elseif child:IsA("Frame") and child:FindFirstChild("TextButton") then
                        child.TextButton.BackgroundColor3 = child.TextButton.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    elseif child:IsA("Frame") and child:FindFirstChild("TextLabel") then
                        child.TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
            end
        else -- Light theme
            mainFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            titleLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            titleLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
            if window.Sidebar then
                window.Sidebar.Frame.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
                for _, tab in pairs(window.Sidebar.Tabs) do
                    tab.Button.BackgroundColor3 = window.Pages[tab.Name].Frame.Visible and Color3.fromRGB(180, 180, 180) or Color3.fromRGB(210, 210, 210)
                    tab.Button.TextColor3 = Color3.fromRGB(50, 50, 50)
                end
            end
            for _, page in pairs(window.Pages) do
                page.Frame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                for _, child in pairs(page.Frame:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child.TextColor3 = Color3.fromRGB(50, 50, 50)
                    elseif child:IsA("Frame") and child:FindFirstChild("TextButton") then
                        child.TextButton.BackgroundColor3 = child.TextButton.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    elseif child:IsA("Frame") and child:FindFirstChild("TextLabel") then
                        child.TextLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
                    end
                end
            end
        end
    end

    -- Animation for opening
    local tweenService = game:GetService("TweenService")
    local openTween = tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local titleTween = tweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    openTween:Play()
    titleTween:Play()

    -- Function to show the window with animation
    function window:Show()
        screenGui.Enabled = true
        openTween:Play()
        titleTween:Play()
    end

    -- Function to hide the window with animation
    function window:Hide()
        local closeTween = tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local titleCloseTween = tweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        closeTween:Play()
        titleCloseTween:Play()
        closeTween.Completed:Connect(function()
            screenGui.Enabled = false
        end)
    end

    -- Function to create a sidebar
    function window:CreateSidebar(options)
        local sidebarFrame = Instance.new("Frame")
        sidebarFrame.Size = UDim2.new(0, options.Width, 1, -30)
        sidebarFrame.Position = UDim2.new(0, 0, 0, 30)
        sidebarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sidebarFrame.Parent = mainFrame
        sidebarFrame.BackgroundTransparency = 1

        local sidebarList = Instance.new("UIListLayout")
        sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
        sidebarList.Parent = sidebarFrame

        local sidebar = {Frame = sidebarFrame, Tabs = {}}

        -- Animation for sidebar
        local sidebarTween = tweenService:Create(sidebarFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        sidebarTween:Play()

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
            tabButton.BackgroundTransparency = 1

            local tabTween = tweenService:Create(tabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
            tabTween:Play()

            -- ImGui-style hover effect
            tabButton.MouseEnter:Connect(function()
                if not (window.Pages[name] and window.Pages[name].Frame.Visible) then
                    tabButton.BackgroundColor3 = window.Theme == "Dark" and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(190, 190, 190)
                end
            end)
            tabButton.MouseLeave:Connect(function()
                if not (window.Pages[name] and window.Pages[name].Frame.Visible) then
                    tabButton.BackgroundColor3 = window.Theme == "Dark" and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(210, 210, 210)
                end
            end)

            tabButton.MouseButton1Click:Connect(function()
                for _, t in pairs(sidebar.Tabs) do
                    t.Button.BackgroundColor3 = window.Theme == "Dark" and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(210, 210, 210)
                    if window.Pages[t.Name] then
                        local page = window.Pages[t.Name].Frame
                        local fadeOut = tweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                        fadeOut:Play()
                        fadeOut.Completed:Connect(function()
                            page.Visible = false
                        end)
                    end
                end
                tabButton.BackgroundColor3 = window.Theme == "Dark" and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(180, 180, 180)
                if window.Pages[name] then
                    local page = window.Pages[name].Frame
                    page.Visible = true
                    local fadeIn = tweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                    fadeIn:Play()
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
        pageFrame.BackgroundTransparency = 1

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

        -- Function to add a checkbox with keybind support
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
            label.Text = options.Name .. (options.Keybind and " [" .. options.Keybind.Name .. "]" or "")
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = checkboxFrame

            local state = options.Default
            local keybind = options.Keybind
            local waitingForKey = false

            -- Toggle on click
            checkbox.MouseButton1Click:Connect(function()
                if waitingForKey then return end
                state = not state
                checkbox.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                if options.Callback then
                    options.Callback(state)
                end
            end)

            -- Right-click to set keybind
            checkbox.MouseButton2Click:Connect(function()
                waitingForKey = true
                label.Text = options.Name .. " [Waiting for key...]"
            end)

            -- Keybind input
            game:GetService("UserInputService").InputBegan:Connect(function(input)
                if waitingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
                    keybind = input.KeyCode
                    waitingForKey = false
                    label.Text = options.Name .. " [" .. keybind.Name .. "]"
                elseif input.KeyCode == keybind and not waitingForKey then
                    state = not state
                    checkbox.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    if options.Callback then
                        options.Callback(state)
                    end
                end
            end)

            return {GetState = function() return state end, GetKeybind = function() return keybind end}
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

        -- Function to add a button (for GUI Bind)
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

            local waitingForKey = false
            button.MouseButton1Click:Connect(function()
                if options.Keybind then
                    waitingForKey = true
                    button.Text = "Waiting for key..."
                elseif options.Callback then
                    options.Callback()
                end
            end)

            game:GetService("UserInputService").InputBegan:Connect(function(input)
                if waitingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
                    options.Keybind.Value = input.KeyCode
                    waitingForKey = false
                    button.Text = options.Name .. " [" .. options.Keybind.Value.Name .. "]"
                end
            end)

            return button
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

        window.Pages[name] = page
        return page
    end

    return window
end

-- ESP and Aimbot Implementation
local ESP = {
    Enabled = false,
    Box = false,
    HighlightBox = false,
    Name = false,
    Tracers = false,
    HealthInfo = false,
    Teamcheck = false,
    DeadCheck = false,
    Color = Color3.fromRGB(255, 0, 0),
    Drawings = {}
}

local Aimbot = {
    Enabled = false,
    Aimlock = false,
    Triggerbot = false,
    FOV = 180,
    UseFOV = false,
    Teamcheck = false,
    DeadCheck = false
}

local Exploits = {
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 32,
    NoClip = false,
    TimeStop = false
}

local Keybinds = {
    Aimlock = {Value = Enum.KeyCode.E},
    Fly = {Value = Enum.KeyCode.F},
    Speed = {Value = Enum.KeyCode.G},
    NoClip = {Value = Enum.KeyCode.H},
    TimeStop = {Value = Enum.KeyCode.J},
    GUI = {Value = Enum.KeyCode.Q}
}

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = localPlayer:GetMouse()

-- Function to create ESP drawings for a player
local function createESP(player)
    local drawing = ESP.Drawings[player]
    if drawing then
        drawing.Box:Remove()
        drawing.Highlight:Remove()
        drawing.Name:Remove()
        drawing.HealthBar:Remove()
        drawing.HealthText:Remove()
        drawing.Tracer:Remove()
        ESP.Drawings[player] = nil
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then return end

    local rootPart = character.HumanoidRootPart
    local head = character.Head
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    if ESP.DeadCheck and humanoid.Health <= 0 then return end
    if ESP.Teamcheck and player.Team == localPlayer.Team then return end

    local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then return end

    -- Calculate box size from bottom to top of player
    local topPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
    local bottomPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
    local boxHeight = math.abs(topPos.Y - bottomPos.Y)
    local boxWidth = boxHeight * 0.6

    -- Create box drawing (always full box)
    local box = Drawing.new("Square")
    box.Visible = ESP.Box
    box.Position = Vector2.new(screenPos.X - boxWidth / 2, topPos.Y)
    box.Size = Vector2.new(boxWidth, boxHeight)
    box.Color = ESP.Color
    box.Thickness = 2
    box.Filled = false

    -- Highlight box (semi-transparent fill)
    local highlight = Drawing.new("Square")
    highlight.Visible = ESP.HighlightBox
    highlight.Position = box.Position
    highlight.Size = box.Size
    highlight.Color = ESP.Color
    highlight.Transparency = 0.8
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

    ESP.Drawings[player] = {Box = box, Highlight = highlight, Name = name, HealthBar = healthBar, HealthText = healthText, Tracer = tracer}
end

-- Function to update ESP positions
local function updateESP()
    for player, drawing in pairs(ESP.Drawings) do
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then
            drawing.Box:Remove()
            drawing.Highlight:Remove()
            drawing.Name:Remove()
            drawing.HealthBar:Remove()
            drawing.HealthText:Remove()
            drawing.Tracer:Remove()
            ESP.Drawings[player] = nil
            continue
        end

        local rootPart = character.HumanoidRootPart
        local head = character.Head
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then
            drawing.Box:Remove()
            drawing.Highlight:Remove()
            drawing.Name:Remove()
            drawing.HealthBar:Remove()
            drawing.HealthText:Remove()
            drawing.Tracer:Remove()
            ESP.Drawings[player] = nil
            continue
        end

        if ESP.DeadCheck and humanoid.Health <= 0 then
            drawing.Box:Remove()
            drawing.Highlight:Remove()
            drawing.Name:Remove()
            drawing.HealthBar:Remove()
            drawing.HealthText:Remove()
            drawing.Tracer:Remove()
            ESP.Drawings[player] = nil
            continue
        end

        if ESP.Teamcheck and player.Team == localPlayer.Team then
            drawing.Box:Remove()
            drawing.Highlight:Remove()
            drawing.Name:Remove()
            drawing.HealthBar:Remove()
            drawing.HealthText:Remove()
            drawing.Tracer:Remove()
            ESP.Drawings[player] = nil
            continue
        end

        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then
            drawing.Box.Visible = false
            drawing.Highlight.Visible = false
            drawing.Name.Visible = false
            drawing.HealthBar.Visible = false
            drawing.HealthText.Visible = false
            drawing.Tracer.Visible = false
            continue
        end

        local topPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
        local bottomPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
        local boxHeight = math.abs(topPos.Y - bottomPos.Y)
        local boxWidth = boxHeight * 0.6

        -- Update box (always full box)
        drawing.Box.Visible = ESP.Box and ESP.Enabled
        drawing.Box.Position = Vector2.new(screenPos.X - boxWidth / 2, topPos.Y)
        drawing.Box.Size = Vector2.new(boxWidth, boxHeight)
        drawing.Box.Color = ESP.Color

        -- Update highlight
        drawing.Highlight.Visible = ESP.HighlightBox and ESP.Enabled
        drawing.Highlight.Position = drawing.Box.Position
        drawing.Highlight.Size = drawing.Box.Size
        drawing.Highlight.Color = ESP.Color

        -- Update name
        drawing.Name.Visible = ESP.Name and ESP.Enabled
        drawing.Name.Position = Vector2.new(topPos.X, topPos.Y - 30)
        drawing.Name.Color = ESP.Color

        -- Update health
        drawing.HealthBar.Visible = ESP.HealthInfo and ESP.Enabled
        drawing.HealthBar.From = Vector2.new(topPos.X - 20, topPos.Y - 10)
        drawing.HealthBar.To = Vector2.new(topPos.X + 20, topPos.Y - 10)
        drawing.HealthBar.Color = ESP.Color
        local health = humanoid.Health / humanoid.MaxHealth
        drawing.HealthBar.To = Vector2.new(drawing.HealthBar.From.X + 40 * health, drawing.HealthBar.From.Y)

        drawing.HealthText.Visible = ESP.HealthInfo and ESP.Enabled
        drawing.HealthText.Text = tostring(math.floor(health * 100)) .. "%"
        drawing.HealthText.Position = Vector2.new(topPos.X, topPos.Y - 10)
        drawing.HealthText.Color = ESP.Color

        -- Update tracer
        drawing.Tracer.Visible = ESP.Tracers and ESP.Enabled
        drawing.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        drawing.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
        drawing.Tracer.Color = ESP.Color
    end

    -- Recreate ESP for new players
    if ESP.Enabled then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and not ESP.Drawings[player] then
                createESP(player)
            end
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
        if not character or not character:FindFirstChild("HumanoidRootPart") then continue end

        local rootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then continue end
        if Aimbot.DeadCheck and humanoid.Health <= 0 then continue end

        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then continue end

        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
        end
    end

    return closestPlayer
end

-- Function to get the nearest player to the local player
local function getNearestPlayer()
    local closestPlayer = nil
    local closestDistance = Aimbot.UseFOV and Aimbot.FOV or math.huge

    for _, player in pairs(players:GetPlayers()) do
        if player == localPlayer then continue end
        if Aimbot.Teamcheck and player.Team == localPlayer.Team then continue end

        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then continue end

        local rootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then continue end
        if Aimbot.DeadCheck and humanoid.Health <= 0 then continue end

        local distance = (rootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then continue end

        if Aimbot.UseFOV then
            local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if screenDistance > Aimbot.FOV then continue end
        end

        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
        end
    end

    return closestPlayer
end

-- FOV Circle for Aimbot
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = 180
fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 2
fovCircle.Filled = false

-- Aimlock (lock onto nearest player)
game:GetService("RunService").RenderStepped:Connect(function()
    if Aimbot.Enabled and Aimbot.Aimlock then
        local target = getNearestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrpPos = target.Character.HumanoidRootPart.Position
            camera.CFrame = CFrame.new(camera.CFrame.Position, hrpPos)
        end
    end

    -- Update FOV circle
    fovCircle.Visible = Aimbot.Enabled and Aimbot.UseFOV
    fovCircle.Radius = Aimbot.FOV
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)

-- Triggerbot
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if Aimbot.Enabled and Aimbot.Triggerbot and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
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

-- Exploits Implementation
-- Admin-Like Fly
local flyConnection
local bodyGyro
local bodyVelocity
local function toggleFly(state)
    if state then
        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 10000
        bodyGyro.Parent = hrp

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp

        if localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.PlatformStand = true
        end

        flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not Exploits.Fly or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
                if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
                    localPlayer.Character.Humanoid.PlatformStand = false
                end
                if flyConnection then flyConnection:Disconnect() end
                return
            end

            local moveDirection = Vector3.new(
                game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) and 1 or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) and -1 or 0,
                game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) and 1 or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0,
                game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) and 1 or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and -1 or 0
            )

            if moveDirection.Magnitude > 0 then
                bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(moveDirection).Unit * Exploits.FlySpeed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            bodyGyro.CFrame = camera.CFrame
        end)
    else
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.PlatformStand = false
        end
        if flyConnection then flyConnection:Disconnect() end
    end
end

-- Speed
local function updateSpeed()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = Exploits.Speed and Exploits.SpeedValue or 16
    end
end

-- NoClip
local function toggleNoClip(state)
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if not Exploits.NoClip or not localPlayer.Character then return end
            for _, part in pairs(localPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end

-- Time Stop
local function toggleTimeStop(state)
    if state then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Anchored = true
            end
        end
    else
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Anchored = false
            end
        end
    end
end

-- Update loop for ESP
game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()
end)

-- Create the GUI using the UI Library
local MainWindow = UILibrary:CreateWindow({
    Title = "Grok 3 Test",
    Size = Vector2.new(600, 400)
})

-- GUI Keybind
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Keybinds.GUI.Value then
        if MainWindow.ScreenGui.Enabled then
            MainWindow:Hide()
        else
            MainWindow:Show()
        end
    end
end)

-- Create the sidebar
local Sidebar = MainWindow:CreateSidebar({
    Width = 150
})

-- Add sidebar tabs
Sidebar:AddTab("Aimbot")
Sidebar:AddTab("Visuals", true)
Sidebar:AddTab("Exploits")
Sidebar:AddTab("Settings")
Sidebar:AddTab("Lua")

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

-- Highlight Box Checkbox
local highlightBoxCheckbox = VisualsPage:AddCheckbox({
    Name = "Highlight Box",
    Default = false,
    Callback = function(state)
        ESP.HighlightBox = state
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

-- Dead Check Checkbox
local deadCheckCheckbox = VisualsPage:AddCheckbox({
    Name = "Dead Check",
    Default = false,
    Callback = function(state)
        ESP.DeadCheck = state
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
    Keybind = Keybinds.Aimlock,
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

-- Dead Check Checkbox
local aimbotDeadCheckCheckbox = AimbotPage:AddCheckbox({
    Name = "Dead Check",
    Default = false,
    Callback = function(state)
        Aimbot.DeadCheck = state
    end
})

-- Exploits Page
local ExploitsPage = MainWindow:CreatePage("Exploits")
ExploitsPage:AddLabel("EXPLOITS")

-- Fly Toggle
local flyCheckbox = ExploitsPage:AddCheckbox({
    Name = "Fly",
    Default = false,
    Keybind = Keybinds.Fly,
    Callback = function(state)
        Exploits.Fly = state
        toggleFly(state)
    end
})

-- Fly Speed Slider
local flySpeedSlider = ExploitsPage:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(value)
        Exploits.FlySpeed = value
    end
})

-- Speed Toggle
local speedCheckbox = ExploitsPage:AddCheckbox({
    Name = "Speed",
    Default = false,
    Keybind = Keybinds.Speed,
    Callback = function(state)
        Exploits.Speed = state
        updateSpeed()
    end
})

-- Speed Slider
local speedSlider = ExploitsPage:AddSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 100,
    Default = 32,
    Callback = function(value)
        Exploits.SpeedValue = value
        updateSpeed()
    end
})

-- NoClip Toggle
local noClipCheckbox = ExploitsPage:AddCheckbox({
    Name = "NoClip",
    Default = false,
    Keybind = Keybinds.NoClip,
    Callback = function(state)
        Exploits.NoClip = state
        toggleNoClip(state)
    end
})

-- Time Stop Toggle
local timeStopCheckbox = ExploitsPage:AddCheckbox({
    Name = "Time Stop",
    Default = false,
    Keybind = Keybinds.TimeStop,
    Callback = function(state)
        Exploits.TimeStop = state
        toggleTimeStop(state)
    end
})

-- Settings Page
local SettingsPage = MainWindow:CreatePage("Settings")
SettingsPage:AddLabel("SETTINGS")

-- GUI Bind Button
local guiBindButton = SettingsPage:AddButton({
    Name = "GUI Bind: " .. Keybinds.GUI.Value.Name,
    Keybind = Keybinds.GUI
})

-- Theme Toggle
local themeCheckbox = SettingsPage:AddCheckbox({
    Name = "Light Mode",
    Default = false,
    Callback = function(state)
        MainWindow:UpdateTheme(state and "Light" or "Dark")
    end
})

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
