local UI = {}
UI.__index = UI

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local CreditsData = {
    {
        Name = "Bratic",
        Description = "Love Everyone With a Purpose.",
        Image = "rbxassetid://0",
    },
    {
        Name = "Luci",
        Description = "One of Bratics Besties, Lucistrap Owner",
        Image = "rbxassetid://0",
    }
}

local Theme = {
    MainBg = Color3.fromRGB(20, 20, 28),
    SidebarBg = Color3.fromRGB(15, 15, 22),
    CardBg = Color3.fromRGB(35, 35, 48),
    Accent = Color3.fromRGB(147, 51, 234),
    Text = Color3.fromRGB(255, 255, 255),
    Subtext = Color3.fromRGB(170, 170, 190),
    CornerSize = UDim.new(0, 8),
    GradientStart = Color3.fromRGB(50, 18, 100),
    GradientEnd = Color3.fromRGB(10, 10, 18),
}

local function CreateGradientFrame(parent, size, pos, zIndex)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(1, 0, 1, 0)
    frame.Position = pos or UDim2.new(0, 0, 0, 0)
    frame.ZIndex = zIndex or 1
    frame.BackgroundColor3 = Theme.MainBg
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.GradientStart),
        ColorSequenceKeypoint.new(1, Theme.GradientEnd)
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.CornerSize
    corner.Parent = frame

    return frame
end

local function CreateLabel(parent, text, size, pos, font, sizeVal, align, color)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(1, 0, 1, 0)
    label.Position = pos or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or Theme.Text
    label.TextSize = sizeVal or 14
    label.Font = font or Enum.Font.GothamBold
    label.TextScaled = false
    label.TextXAlignment = align or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function CreateButton(parent, text, size, pos, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(1, 0, 0, 35)
    button.Position = pos or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Theme.Accent
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.CornerSize
    corner.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)

    if callback then button.MouseButton1Click:Connect(callback) end
    return button
end

local function CreateToggle(parent, text, defaultValue, callback)
    local state = defaultValue or false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent

    CreateLabel(container, text, UDim2.new(0, 200, 1, 0), UDim2.new(0, 0, 0, 0))

    local toggleTrack = Instance.new("Frame")
    toggleTrack.Size = UDim2.new(0, 40, 0, 20)
    toggleTrack.Position = UDim2.new(1, -40, 0.5, -10)
    toggleTrack.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 70)
    toggleTrack.BorderSizePixel = 0
    toggleTrack.Parent = container

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleTrack

    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 16, 0, 16)
    toggleButton.Position = state and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = Theme.Text
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleTrack

    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(1, 0)
    toggleBtnCorner.Parent = toggleButton

    local clickOverlay = Instance.new("TextButton")
    clickOverlay.Size = UDim2.new(1, 0, 1, 0)
    clickOverlay.BackgroundTransparency = 1
    clickOverlay.Text = ""
    clickOverlay.Parent = container

    local function updateToggle(isOn)
        local targetColor = isOn and Theme.Accent or Color3.fromRGB(50, 50, 70)
        local targetPos = isOn and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
        TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {Position = targetPos}):Play()
    end

    clickOverlay.MouseButton1Click:Connect(function()
        state = not state
        updateToggle(state)
        if callback then callback(state) end
    end)

    return container
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    min = min or 0
    max = max or 100
    defaultValue = math.clamp(defaultValue or min, min, max)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = parent

    CreateLabel(container, text, UDim2.new(0.5, 0, 0, 20), UDim2.new(0, 0, 0, 0))
    local valueLabel = CreateLabel(container, tostring(defaultValue), UDim2.new(0.5, 0, 0, 20), UDim2.new(0.5, 0, 0, 0), Enum.Font.Gotham, 14, Enum.TextXAlignment.Right, Theme.Subtext)

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 0, 8)
    sliderTrack.Position = UDim2.new(0, 0, 1, -12)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    local dragging = false
    local function updateValue(input)
        local posX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
        local percentage = posX / sliderTrack.AbsoluteSize.X
        local value = math.floor(min + ((max - min) * percentage))
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input)
        end
    end)

    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input)
        end
    end)

    return container
end

local function CreateCreditCard(parent, data)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 65)
    card.BackgroundColor3 = Theme.CardBg
    card.BorderSizePixel = 0
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = Theme.CornerSize
    cardCorner.Parent = card

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 45, 0, 45)
    avatar.Position = UDim2.new(0, 10, 0.5, -22)
    avatar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    avatar.Image = data.Image or ""
    avatar.BorderSizePixel = 0
    avatar.Parent = card

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 6)
    avatarCorner.Parent = avatar

    CreateLabel(card, data.Name or "User", UDim2.new(1, -70, 0, 20), UDim2.new(0, 65, 0, 12), Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, Theme.Text)
    CreateLabel(card, data.Description or "", UDim2.new(1, -70, 0, 18), UDim2.new(0, 65, 0, 32), Enum.Font.Gotham, 12, Enum.TextXAlignment.Left, Theme.Subtext)

    return card
end

local function CreateKeybind(parent, text, defaultKey, callback)
    local keybind = defaultKey or Enum.KeyCode.RightControl

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent

    CreateLabel(container, text, UDim2.new(0, 200, 1, 0), UDim2.new(0, 0, 0, 0))

    local bindButton = Instance.new("TextButton")
    bindButton.Size = UDim2.new(0, 100, 0, 26)
    bindButton.Position = UDim2.new(1, -100, 0.5, -13)
    bindButton.BackgroundColor3 = Theme.CardBg
    bindButton.BorderSizePixel = 0
    bindButton.Text = keybind.Name
    bindButton.TextColor3 = Theme.Text
    bindButton.Font = Enum.Font.GothamBold
    bindButton.TextSize = 12
    bindButton.Parent = container

    local bindCorner = Instance.new("UICorner")
    bindCorner.CornerRadius = Theme.CornerSize
    bindCorner.Parent = bindButton

    local listening = false
    bindButton.MouseButton1Click:Connect(function()
        listening = true
        bindButton.Text = "Press key..."
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            keybind = input.KeyCode
            bindButton.Text = keybind.Name
            if callback then callback(keybind) end
        end
    end)

    return container
end

function UI.CreateWindow(title)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomUI_Window"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = CreateGradientFrame(screenGui, UDim2.new(0, 520, 0, 360), UDim2.new(0.5, -260, 0.5, -180), 1)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame

    CreateLabel(titleBar, title or "UI Window", UDim2.new(1, -20, 1, 0), UDim2.new(0, 15, 0, 0), Enum.Font.GothamBold, 16)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 120, 1, -45)
    sidebar.Position = UDim2.new(0, 10, 0, 40)
    sidebar.BackgroundColor3 = Theme.SidebarBg
    sidebar.BorderSizePixel = 0
    sidebar.ClipsDescendants = true
    sidebar.Parent = mainFrame

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = Theme.CornerSize
    sidebarCorner.Parent = sidebar

    local toggleSidebarBtn = Instance.new("TextButton")
    toggleSidebarBtn.Size = UDim2.new(0, 30, 0, 25)
    toggleSidebarBtn.Position = UDim2.new(1, -35, 0, 5)
    toggleSidebarBtn.BackgroundTransparency = 1
    toggleSidebarBtn.Text = "≡"
    toggleSidebarBtn.TextColor3 = Theme.Text
    toggleSidebarBtn.Font = Enum.Font.GothamBold
    toggleSidebarBtn.TextSize = 20
    toggleSidebarBtn.Parent = sidebar

    local sidebarContainer = Instance.new("Frame")
    sidebarContainer.Size = UDim2.new(1, 0, 1, -35)
    sidebarContainer.Position = UDim2.new(0, 0, 0, 35)
    sidebarContainer.BackgroundTransparency = 1
    sidebarContainer.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarContainer

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingLeft = UDim.new(0, 5)
    sidebarPadding.PaddingRight = UDim.new(0, 5)
    sidebarPadding.Parent = sidebarContainer

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -150, 1, -45)
    contentArea.Position = UDim2.new(0, 140, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    local sidebarOpen = true
    toggleSidebarBtn.MouseButton1Click:Connect(function()
        sidebarOpen = not sidebarOpen
        local targetWidth = sidebarOpen and 120 or 40
        local targetContentPos = sidebarOpen and 140 or 60
        local targetContentWidth = sidebarOpen and -150 or -70

        TweenService:Create(sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, targetWidth, 1, -45)}):Play()
        TweenService:Create(contentArea, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetContentPos, 0, 40),
            Size = UDim2.new(1, targetContentWidth, 1, -45)
        }):Play()
    end)

    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.new(0, 15, 0, 15)
    resizeHandle.Position = UDim2.new(1, -15, 1, -15)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Parent = mainFrame

    local resizeLines = Instance.new("TextLabel")
    resizeLines.Size = UDim2.new(1, 0, 1, 0)
    resizeLines.BackgroundTransparency = 1
    resizeLines.Text = "◢"
    resizeLines.TextColor3 = Theme.Subtext
    resizeLines.TextSize = 12
    resizeLines.Font = Enum.Font.Gotham
    resizeLines.TextXAlignment = Enum.TextXAlignment.Right
    resizeLines.TextYAlignment = Enum.TextYAlignment.Bottom
    resizeLines.Parent = resizeHandle

    local resizing = false
    local resizeStart, startSize

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = mainFrame.Size
        end
    end)

    resizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newX = math.max(380, startSize.X.Offset + delta.X)
            local newY = math.max(250, startSize.Y.Offset + delta.Y)
            mainFrame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    local tabs = {}
    local WindowAPI = {ScreenGui = screenGui}

    function WindowAPI:CreateTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 32)
        tabButton.BackgroundColor3 = Theme.CardBg
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = tabName
        tabButton.TextColor3 = Theme.Subtext
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 13
        tabButton.BorderSizePixel = 0
        tabButton.ClipsDescendants = true
        tabButton.Parent = sidebarContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = Theme.CornerSize
        btnCorner.Parent = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Theme.Accent
        tabContent.Visible = false
        tabContent.Parent = contentArea

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = tabContent

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        end)

        tabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundTransparency = 0.5
                tab.Button.TextColor3 = Theme.Subtext
            end
            tabContent.Visible = true
            tabButton.BackgroundTransparency = 0
            tabButton.TextColor3 = Theme.Text
        end)

        if #tabs == 0 then
            tabContent.Visible = true
            tabButton.BackgroundTransparency = 0
            tabButton.TextColor3 = Theme.Text
        end

        table.insert(tabs, {Button = tabButton, Content = tabContent})

        local TabAPI = {}
        function TabAPI:AddButton(text, callback)
            return CreateButton(tabContent, text, nil, nil, callback)
        end
        function TabAPI:AddToggle(text, defaultValue, callback)
            return CreateToggle(tabContent, text, defaultValue, callback)
        end
        function TabAPI:AddSlider(text, min, max, defaultValue, callback)
            return CreateSlider(tabContent, text, min, max, defaultValue, callback)
        end
        function TabAPI:AddLabel(text)
            return CreateLabel(tabContent, text, UDim2.new(1, 0, 0, 20), nil, Enum.Font.Gotham, 14, Enum.TextXAlignment.Left, Theme.Subtext)
        end
        function TabAPI:AddCreditCard(data)
            return CreateCreditCard(tabContent, data)
        end
        function TabAPI:AddKeybind(text, defaultKey, callback)
            return CreateKeybind(tabContent, text, defaultKey, callback)
        end

        return TabAPI
    end

    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return WindowAPI
end

local Window = UI.CreateWindow("Purple Gradient Hub")

local MainTab = Window:CreateTab("Main")
MainTab:AddLabel("Main Player Features")

MainTab:AddButton("Print Hello", function()
    print("Hello from Main Tab!")
end)

MainTab:AddToggle("Speed Toggle", false, function(enabled)
    print("Speed Toggle State:", enabled)
end)

MainTab:AddSlider("WalkSpeed", 16, 100, 16, function(value)
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

local CreditsTab = Window:CreateTab("Credits")
CreditsTab:AddLabel("Main Contributors")

for _, contributor in ipairs(CreditsData) do
    CreditsTab:AddCreditCard(contributor)
end

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:AddLabel("UI Settings")

local toggleKey = Enum.KeyCode.RightControl
SettingsTab:AddKeybind("Toggle UI Keybind", toggleKey, function(newKey)
    toggleKey = newKey
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleKey then
        Window.ScreenGui.Enabled = not Window.ScreenGui.Enabled
    end
end)
