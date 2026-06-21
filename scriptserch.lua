local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local FULL_SIZE = UDim2.new(0, 620, 0, 540)
local MINI_SIZE = UDim2.new(0, 220, 0, 48)
local isMinimized = false
local currentSource = "scriptblox"

local MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(80, 60, 180)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)
local TopFix = Instance.new("Frame", TopBar)
TopFix.Size = UDim2.new(1, 0, 0.5, 0)
TopFix.Position = UDim2.new(0, 0, 0.5, 0)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
TopFix.BorderSizePixel = 0

local DragIcon = Instance.new("TextLabel", TopBar)
DragIcon.Size = UDim2.new(0, 20, 1, 0)
DragIcon.Position = UDim2.new(0, 12, 0, 0)
DragIcon.BackgroundTransparency = 1
DragIcon.Text = "⠿"
DragIcon.TextColor3 = Color3.fromRGB(100, 80, 160)
DragIcon.TextSize = 16
DragIcon.Font = Enum.Font.GothamBold

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -130, 1, 0)
TitleLabel.Position = UDim2.new(0, 36, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⬡ Script Hub Search"
TitleLabel.TextColor3 = Color3.fromRGB(210, 200, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -76, 0.5, -16)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(180, 160, 255)
MinBtn.TextSize = 13
MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 160, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local Tooltip = Instance.new("Frame", ScreenGui)
Tooltip.Size = UDim2.new(0, 0, 0, 28)
Tooltip.BackgroundColor3 = Color3.fromRGB(30, 24, 55)
Tooltip.BorderSizePixel = 0
Tooltip.Visible = false
Tooltip.ZIndex = 50
Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 6)
local TooltipStroke = Instance.new("UIStroke", Tooltip)
TooltipStroke.Color = Color3.fromRGB(100, 70, 200)
TooltipStroke.Thickness = 1
TooltipStroke.Transparency = 0.4
local TooltipLabel = Instance.new("TextLabel", Tooltip)
TooltipLabel.Size = UDim2.new(1, -16, 1, 0)
TooltipLabel.Position = UDim2.new(0, 8, 0, 0)
TooltipLabel.BackgroundTransparency = 1
TooltipLabel.TextColor3 = Color3.fromRGB(210, 200, 255)
TooltipLabel.TextSize = 12
TooltipLabel.Font = Enum.Font.Gotham
TooltipLabel.TextXAlignment = Enum.TextXAlignment.Left
TooltipLabel.ZIndex = 51

local function showTooltip(text, btn)
    TooltipLabel.Text = text
    local textSize = game:GetService("TextService"):GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(400, 28))
    Tooltip.Size = UDim2.new(0, textSize.X + 16, 0, 28)
    local abs = btn.AbsolutePosition
    local sz = btn.AbsoluteSize
    Tooltip.Position = UDim2.new(0, abs.X + sz.X / 2 - (textSize.X + 16) / 2, 0, abs.Y - 34)
    Tooltip.Visible = true
end
local function hideTooltip() Tooltip.Visible = false end
local function addTooltip(btn, text)
    btn.MouseEnter:Connect(function() showTooltip(text, btn) end)
    btn.MouseLeave:Connect(function() hideTooltip() end)
end

addTooltip(CloseBtn, "关闭窗口")
addTooltip(MinBtn, "最小化 / 展开窗口")
addTooltip(DragIcon, "拖动移动窗口")

local SourceFrame = Instance.new("Frame", MainFrame)
SourceFrame.Size = UDim2.new(1, -32, 0, 32)
SourceFrame.Position = UDim2.new(0, 16, 0, 58)
SourceFrame.BackgroundTransparency = 1

local SBSourceBtn = Instance.new("TextButton", SourceFrame)
SBSourceBtn.Size = UDim2.new(0, 110, 1, 0)
SBSourceBtn.Position = UDim2.new(0, 0, 0, 0)
SBSourceBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 200)
SBSourceBtn.BorderSizePixel = 0
SBSourceBtn.Text = "● ScriptBlox"
SBSourceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SBSourceBtn.TextSize = 12
SBSourceBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SBSourceBtn).CornerRadius = UDim.new(0, 8)
addTooltip(SBSourceBtn, "使用 ScriptBlox 脚本库搜索")

local RSSourceBtn = Instance.new("TextButton", SourceFrame)
RSSourceBtn.Size = UDim2.new(0, 110, 1, 0)
RSSourceBtn.Position = UDim2.new(0, 118, 0, 0)
RSSourceBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
RSSourceBtn.BorderSizePixel = 0
RSSourceBtn.Text = "○ Rscripts"
RSSourceBtn.TextColor3 = Color3.fromRGB(140, 130, 180)
RSSourceBtn.TextSize = 12
RSSourceBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RSSourceBtn).CornerRadius = UDim.new(0, 8)
addTooltip(RSSourceBtn, "使用 Rscripts.net 脚本库搜索")

local SourceStatusLabel = Instance.new("TextLabel", SourceFrame)
SourceStatusLabel.Size = UDim2.new(0, 220, 1, 0)
SourceStatusLabel.Position = UDim2.new(1, -220, 0, 0)
SourceStatusLabel.BackgroundTransparency = 1
SourceStatusLabel.Text = "当前来源: ScriptBlox"
SourceStatusLabel.TextColor3 = Color3.fromRGB(110, 95, 160)
SourceStatusLabel.TextSize = 11
SourceStatusLabel.Font = Enum.Font.Gotham
SourceStatusLabel.TextXAlignment = Enum.TextXAlignment.Right

local function setSource(src)
    currentSource = src
    if src == "scriptblox" then
        SBSourceBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 200)
        SBSourceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SBSourceBtn.Text = "● ScriptBlox"
        RSSourceBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
        RSSourceBtn.TextColor3 = Color3.fromRGB(140, 130, 180)
        RSSourceBtn.Text = "○ Rscripts"
        SourceStatusLabel.Text = "当前来源: ScriptBlox"
    else
        RSSourceBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 200)
        RSSourceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        RSSourceBtn.Text = "● Rscripts"
        SBSourceBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
        SBSourceBtn.TextColor3 = Color3.fromRGB(140, 130, 180)
        SBSourceBtn.Text = "○ ScriptBlox"
        SourceStatusLabel.Text = "当前来源: Rscripts.net"
    end
end

SBSourceBtn.MouseButton1Click:Connect(function() setSource("scriptblox") end)
RSSourceBtn.MouseButton1Click:Connect(function() setSource("rscripts") end)

local SearchFrame = Instance.new("Frame", MainFrame)
SearchFrame.Size = UDim2.new(1, -32, 0, 40)
SearchFrame.Position = UDim2.new(0, 16, 0, 98)
SearchFrame.BackgroundTransparency = 1

local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -130, 1, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
SearchBox.BorderSizePixel = 0
SearchBox.Text = ""
SearchBox.PlaceholderText = "搜索脚本关键词..."
SearchBox.TextColor3 = Color3.fromRGB(210, 200, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 140)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 8)
local SBStroke = Instance.new("UIStroke", SearchBox)
SBStroke.Color = Color3.fromRGB(80, 60, 160)
SBStroke.Thickness = 1
SBStroke.Transparency = 0.6

local PagesBox = Instance.new("TextBox", SearchFrame)
PagesBox.Size = UDim2.new(0, 50, 1, 0)
PagesBox.Position = UDim2.new(1, -120, 0, 0)
PagesBox.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
PagesBox.BorderSizePixel = 0
PagesBox.Text = "5"
PagesBox.TextColor3 = Color3.fromRGB(210, 200, 255)
PagesBox.TextSize = 14
PagesBox.Font = Enum.Font.Gotham
PagesBox.ClearTextOnFocus = false
Instance.new("UICorner", PagesBox).CornerRadius = UDim.new(0, 8)
local PBStroke = Instance.new("UIStroke", PagesBox)
PBStroke.Color = Color3.fromRGB(80, 60, 160)
PBStroke.Thickness = 1
PBStroke.Transparency = 0.6
addTooltip(PagesBox, "设置搜索页数")

local SearchBtn = Instance.new("TextButton", SearchFrame)
SearchBtn.Size = UDim2.new(0, 60, 1, 0)
SearchBtn.Position = UDim2.new(1, -60, 0, 0)
SearchBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 200)
SearchBtn.BorderSizePixel = 0
SearchBtn.Text = "搜索"
SearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.TextSize = 13
SearchBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 8)
addTooltip(SearchBtn, "开始搜索（或按 Enter）")

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -32, 0, 20)
StatusLabel.Position = UDim2.new(0, 16, 0, 146)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "输入关键词开始搜索"
StatusLabel.TextColor3 = Color3.fromRGB(120, 100, 180)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -32, 1, -186)
ScrollFrame.Position = UDim2.new(0, 16, 0, 172)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 55, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
local ListLayout = Instance.new("UIListLayout", ScrollFrame)
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ScriptModal = Instance.new("Frame", MainFrame)
ScriptModal.Size = UDim2.new(1, -32, 1, -186)
ScriptModal.Position = UDim2.new(0, 16, 0, 172)
ScriptModal.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
ScriptModal.BorderSizePixel = 0
ScriptModal.Visible = false
ScriptModal.ZIndex = 10
Instance.new("UICorner", ScriptModal).CornerRadius = UDim.new(0, 10)
local SMStroke = Instance.new("UIStroke", ScriptModal)
SMStroke.Color = Color3.fromRGB(80, 60, 180)
SMStroke.Thickness = 1
SMStroke.Transparency = 0.4

local ModalTitleBar = Instance.new("Frame", ScriptModal)
ModalTitleBar.Size = UDim2.new(1, 0, 0, 44)
ModalTitleBar.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
ModalTitleBar.BorderSizePixel = 0
ModalTitleBar.ZIndex = 11
Instance.new("UICorner", ModalTitleBar).CornerRadius = UDim.new(0, 10)
local MTBFix = Instance.new("Frame", ModalTitleBar)
MTBFix.Size = UDim2.new(1, 0, 0.5, 0)
MTBFix.Position = UDim2.new(0, 0, 0.5, 0)
MTBFix.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
MTBFix.BorderSizePixel = 0
MTBFix.ZIndex = 11

local ModalTitle = Instance.new("TextLabel", ModalTitleBar)
ModalTitle.Size = UDim2.new(1, -210, 1, 0)
ModalTitle.Position = UDim2.new(0, 12, 0, 0)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = ""
ModalTitle.TextColor3 = Color3.fromRGB(210, 200, 255)
ModalTitle.TextSize = 13
ModalTitle.Font = Enum.Font.GothamBold
ModalTitle.TextXAlignment = Enum.TextXAlignment.Left
ModalTitle.TextTruncate = Enum.TextTruncate.AtEnd
ModalTitle.ZIndex = 12

local ExecBtn = Instance.new("TextButton", ModalTitleBar)
ExecBtn.Size = UDim2.new(0, 64, 0, 28)
ExecBtn.Position = UDim2.new(1, -202, 0.5, -14)
ExecBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
ExecBtn.BorderSizePixel = 0
ExecBtn.Text = "▶ 执行"
ExecBtn.TextColor3 = Color3.fromRGB(80, 220, 140)
ExecBtn.TextSize = 12
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.ZIndex = 12
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)
local ExecStroke = Instance.new("UIStroke", ExecBtn)
ExecStroke.Color = Color3.fromRGB(40, 180, 100)
ExecStroke.Thickness = 1
ExecStroke.Transparency = 0.5
addTooltip(ExecBtn, "在游戏中立即执行此脚本")

local CopyBtn = Instance.new("TextButton", ModalTitleBar)
CopyBtn.Size = UDim2.new(0, 60, 0, 28)
CopyBtn.Position = UDim2.new(1, -130, 0.5, -14)
CopyBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 200)
CopyBtn.BorderSizePixel = 0
CopyBtn.Text = "⎘ 复制"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 12
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.ZIndex = 12
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
addTooltip(CopyBtn, "复制脚本内容到剪贴板")

local BackBtn = Instance.new("TextButton", ModalTitleBar)
BackBtn.Size = UDim2.new(0, 52, 0, 28)
BackBtn.Position = UDim2.new(1, -62, 0.5, -14)
BackBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
BackBtn.BorderSizePixel = 0
BackBtn.Text = "← 返回"
BackBtn.TextColor3 = Color3.fromRGB(180, 160, 255)
BackBtn.TextSize = 12
BackBtn.Font = Enum.Font.GothamBold
BackBtn.ZIndex = 12
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)
addTooltip(BackBtn, "返回搜索结果列表")

local ModalScroll = Instance.new("ScrollingFrame", ScriptModal)
ModalScroll.Size = UDim2.new(1, -16, 1, -54)
ModalScroll.Position = UDim2.new(0, 8, 0, 50)
ModalScroll.BackgroundTransparency = 1
ModalScroll.BorderSizePixel = 0
ModalScroll.ScrollBarThickness = 3
ModalScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 55, 200)
ModalScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ModalScroll.ZIndex = 11

local ModalCodeLabel = Instance.new("TextLabel", ModalScroll)
ModalCodeLabel.Size = UDim2.new(1, -8, 0, 0)
ModalCodeLabel.BackgroundTransparency = 1
ModalCodeLabel.Text = ""
ModalCodeLabel.TextColor3 = Color3.fromRGB(170, 210, 170)
ModalCodeLabel.TextSize = 12
ModalCodeLabel.Font = Enum.Font.Code
ModalCodeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModalCodeLabel.TextYAlignment = Enum.TextYAlignment.Top
ModalCodeLabel.TextWrapped = true
ModalCodeLabel.AutomaticSize = Enum.AutomaticSize.Y
ModalCodeLabel.ZIndex = 12

local NotifyFrame = Instance.new("Frame", ScreenGui)
NotifyFrame.Size = UDim2.new(0, 280, 0, 44)
NotifyFrame.Position = UDim2.new(0.5, -140, 1, -70)
NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
NotifyFrame.BorderSizePixel = 0
NotifyFrame.Visible = false
NotifyFrame.ZIndex = 60
Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 10)
local NotifyStroke = Instance.new("UIStroke", NotifyFrame)
NotifyStroke.Color = Color3.fromRGB(80, 55, 200)
NotifyStroke.Thickness = 1
NotifyStroke.Transparency = 0.4
local NotifyLabel = Instance.new("TextLabel", NotifyFrame)
NotifyLabel.Size = UDim2.new(1, -16, 1, 0)
NotifyLabel.Position = UDim2.new(0, 8, 0, 0)
NotifyLabel.BackgroundTransparency = 1
NotifyLabel.TextColor3 = Color3.fromRGB(210, 200, 255)
NotifyLabel.TextSize = 13
NotifyLabel.Font = Enum.Font.GothamBold
NotifyLabel.ZIndex = 61

local function showNotify(text, color)
    NotifyLabel.Text = text
    NotifyLabel.TextColor3 = color or Color3.fromRGB(210, 200, 255)
    NotifyStroke.Color = color or Color3.fromRGB(80, 55, 200)
    NotifyFrame.Visible = true
    task.delay(2.5, function() NotifyFrame.Visible = false end)
end

local isDragging = false
local dragStartPos
local frameStartPos

local function clampPosition(pos)
    local vp = workspace.CurrentCamera.ViewportSize
    local sx = MainFrame.AbsoluteSize.X
    local sy = MainFrame.AbsoluteSize.Y
    local ox = math.clamp(pos.X.Offset, 0, vp.X - sx)
    local oy = math.clamp(pos.Y.Offset, 0, vp.Y - sy)
    return UDim2.new(0, ox, 0, oy)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = input.Position
        frameStartPos = MainFrame.Position
        hideTooltip()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        local newPos = UDim2.new(0, frameStartPos.X.Offset + delta.X, 0, frameStartPos.Y.Offset + delta.Y)
        MainFrame.Position = clampPosition(newPos)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    hideTooltip()
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = MINI_SIZE}):Play()
        MinBtn.Text = "▢"
        TitleLabel.Text = "⬡ Script Hub"
        showNotify("窗口已最小化，点击 ▢ 展开", Color3.fromRGB(150, 130, 220))
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = FULL_SIZE}):Play()
        MinBtn.Text = "—"
        TitleLabel.Text = "⬡ Script Hub Search"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local currentScriptText = ""

BackBtn.MouseButton1Click:Connect(function()
    ScriptModal.Visible = false
end)

CopyBtn.MouseButton1Click:Connect(function()
    if currentScriptText ~= "" then
        setclipboard(currentScriptText)
        CopyBtn.Text = "✓ 已复制"
        showNotify("✓ 脚本已复制到剪贴板", Color3.fromRGB(80, 200, 140))
        task.delay(1.5, function() CopyBtn.Text = "⎘ 复制" end)
    end
end)

ExecBtn.MouseButton1Click:Connect(function()
    if currentScriptText ~= "" then
        local ok, err = pcall(function() loadstring(currentScriptText)() end)
        if ok then
            ExecBtn.Text = "✓ 成功"
            ExecBtn.BackgroundColor3 = Color3.fromRGB(15, 100, 50)
            showNotify("✓ 脚本执行成功", Color3.fromRGB(80, 200, 140))
            task.delay(1.8, function()
                ExecBtn.Text = "▶ 执行"
                ExecBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
            end)
        else
            ExecBtn.Text = "✕ 错误"
            ExecBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
            showNotify("✕ 执行失败: " .. tostring(err):sub(1, 40), Color3.fromRGB(220, 80, 80))
            task.delay(2, function()
                ExecBtn.Text = "▶ 执行"
                ExecBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
            end)
        end
    end
end)

local function resolveScriptText(entry, callback)
    if entry.script and entry.script ~= "" then
        callback(entry.script)
        return
    end
    if entry.rawUrl and entry.rawUrl ~= "" then
        local ok, content = pcall(function() return game:HttpGet(entry.rawUrl) end)
        if ok and content and content ~= "" then
            entry.script = content
            callback(content)
        else
            callback(nil)
        end
    else
        callback(nil)
    end
end

local function createCard(entry, index)
    local Card = Instance.new("Frame", ScrollFrame)
    Card.Size = UDim2.new(1, 0, 0, 62)
    Card.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
    Card.BorderSizePixel = 0
    Card.LayoutOrder = index
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    local CS = Instance.new("UIStroke", Card)
    CS.Color = Color3.fromRGB(70, 50, 150)
    CS.Thickness = 1
    CS.Transparency = 0.7

    local TitleT = Instance.new("TextLabel", Card)
    TitleT.Size = UDim2.new(1, -160, 0, 24)
    TitleT.Position = UDim2.new(0, 12, 0, 8)
    TitleT.BackgroundTransparency = 1
    TitleT.Text = tostring(index) .. ". " .. tostring(entry.title or "无标题")
    TitleT.TextColor3 = Color3.fromRGB(210, 200, 255)
    TitleT.TextSize = 13
    TitleT.Font = Enum.Font.GothamBold
    TitleT.TextXAlignment = Enum.TextXAlignment.Left
    TitleT.TextTruncate = Enum.TextTruncate.AtEnd

    local GameT = Instance.new("TextLabel", Card)
    GameT.Size = UDim2.new(1, -160, 0, 20)
    GameT.Position = UDim2.new(0, 12, 0, 34)
    GameT.BackgroundTransparency = 1
    GameT.Text = "🎮 " .. tostring(entry.game or "未知游戏")
    GameT.TextColor3 = Color3.fromRGB(100, 90, 150)
    GameT.TextSize = 11
    GameT.Font = Enum.Font.Gotham
    GameT.TextXAlignment = Enum.TextXAlignment.Left
    GameT.TextTruncate = Enum.TextTruncate.AtEnd

    local VerifiedBadge = Instance.new("TextLabel", Card)
    VerifiedBadge.Size = UDim2.new(0, 70, 0, 22)
    VerifiedBadge.Position = UDim2.new(1, -158, 0.5, -11)
    VerifiedBadge.BackgroundColor3 = entry.verified and Color3.fromRGB(15, 60, 40) or Color3.fromRGB(30, 25, 50)
    VerifiedBadge.BorderSizePixel = 0
    VerifiedBadge.Text = entry.verified and "✓ 已验证" or "未验证"
    VerifiedBadge.TextColor3 = entry.verified and Color3.fromRGB(80, 200, 140) or Color3.fromRGB(100, 90, 140)
    VerifiedBadge.TextSize = 11
    VerifiedBadge.Font = Enum.Font.GothamBold
    Instance.new("UICorner", VerifiedBadge).CornerRadius = UDim.new(0, 20)

    local QuickExecBtn = Instance.new("TextButton", Card)
    QuickExecBtn.Size = UDim2.new(0, 64, 0, 28)
    QuickExecBtn.Position = UDim2.new(1, -80, 0.5, -14)
    QuickExecBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
    QuickExecBtn.BorderSizePixel = 0
    QuickExecBtn.Text = "▶ 执行"
    QuickExecBtn.TextColor3 = Color3.fromRGB(80, 220, 140)
    QuickExecBtn.TextSize = 11
    QuickExecBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", QuickExecBtn).CornerRadius = UDim.new(0, 6)
    local QES = Instance.new("UIStroke", QuickExecBtn)
    QES.Color = Color3.fromRGB(40, 180, 100)
    QES.Thickness = 1
    QES.Transparency = 0.5
    addTooltip(QuickExecBtn, "直接执行此脚本，无需打开详情")

    local ClickBtn = Instance.new("TextButton", Card)
    ClickBtn.Size = UDim2.new(1, -90, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    addTooltip(ClickBtn, "点击查看完整脚本内容")

    ClickBtn.MouseEnter:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 24, 55)}):Play()
    end)
    ClickBtn.MouseLeave:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 16, 38)}):Play()
    end)

    ClickBtn.MouseButton1Click:Connect(function()
        ModalTitle.Text = tostring(entry.title or "脚本")
        ModalCodeLabel.Text = "正在加载脚本内容..."
        ScriptModal.Visible = true
        task.spawn(function()
            resolveScriptText(entry, function(text)
                if text then
                    currentScriptText = text
                    ModalCodeLabel.Text = text
                else
                    currentScriptText = ""
                    ModalCodeLabel.Text = "无法加载脚本内容"
                end
                task.wait()
                ModalScroll.CanvasSize = UDim2.new(0, 0, 0, ModalCodeLabel.AbsoluteSize.Y + 16)
            end)
        end)
    end)

    QuickExecBtn.MouseButton1Click:Connect(function()
        QuickExecBtn.Text = "..."
        task.spawn(function()
            resolveScriptText(entry, function(text)
                if text and text ~= "" then
                    local ok, err = pcall(function() loadstring(text)() end)
                    if ok then
                        QuickExecBtn.Text = "✓ 成功"
                        QuickExecBtn.BackgroundColor3 = Color3.fromRGB(15, 100, 50)
                        showNotify("✓ 「" .. tostring(entry.title or "脚本"):sub(1, 20) .. "」执行成功", Color3.fromRGB(80, 200, 140))
                    else
                        QuickExecBtn.Text = "✕ 错误"
                        QuickExecBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
                        showNotify("✕ 执行失败: " .. tostring(err):sub(1, 36), Color3.fromRGB(220, 80, 80))
                    end
                else
                    QuickExecBtn.Text = "✕ 无内容"
                    QuickExecBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
                    showNotify("✕ 无法获取脚本内容", Color3.fromRGB(220, 80, 80))
                end
                task.delay(1.8, function()
                    QuickExecBtn.Text = "▶ 执行"
                    QuickExecBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
                end)
            end)
        end)
    end)
end

local function fetchScriptBlox(query, maxPages, onPageDone)
    local results = {}
    local completed = 0
    local function fetchPage(page)
        local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query) .. "&max=20&page=" .. tostring(page)
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok then
            local okD, decoded = pcall(function() return HttpService:JSONDecode(res) end)
            if okD and decoded and decoded.result and decoded.result.scripts then
                for _, s in ipairs(decoded.result.scripts) do
                    table.insert(results, {
                        title = s.title,
                        game = (s.game and s.game.name) or "未知游戏",
                        verified = s.verified,
                        script = s.script,
                        rawUrl = nil
                    })
                end
            end
        end
        completed = completed + 1
        onPageDone(completed, #results)
    end
    for i = 1, maxPages do task.spawn(fetchPage, i) end
    repeat task.wait(0.1) until completed >= maxPages
    return results
end

local function fetchRscripts(query, maxPages, onPageDone)
    local results = {}
    local completed = 0
    local function fetchPage(page)
        local url = "https://rscripts.net/api/v2/scripts?page=" .. tostring(page) .. "&orderBy=date&sort=desc&q=" .. HttpService:UrlEncode(query)
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok then
            local okD, decoded = pcall(function() return HttpService:JSONDecode(res) end)
            if okD and decoded and decoded.scripts then
                for _, s in ipairs(decoded.scripts) do
                    local gameName = "通用脚本"
                    if s.game and s.game.title then
                        gameName = s.game.title
                    end
                    local isVerified = false
                    if s.user and s.user.verified then
                        isVerified = true
                    end
                    table.insert(results, {
                        title = s.title,
                        game = gameName,
                        verified = isVerified,
                        script = nil,
                        rawUrl = s.rawScript
                    })
                end
            end
        end
        completed = completed + 1
        onPageDone(completed, #results)
    end
    for i = 1, maxPages do task.spawn(fetchPage, i) end
    repeat task.wait(0.1) until completed >= maxPages
    return results
end

local function doSearch()
    local query = SearchBox.Text
    local maxPages = tonumber(PagesBox.Text) or 5
    if query == "" then
        showNotify("⚠ 请先输入搜索关键词", Color3.fromRGB(220, 160, 60))
        return
    end
    if isMinimized then
        isMinimized = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = FULL_SIZE}):Play()
        MinBtn.Text = "—"
        TitleLabel.Text = "⬡ Script Hub Search"
    end
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local sourceName = (currentSource == "scriptblox") and "ScriptBlox" or "Rscripts.net"
    StatusLabel.Text = "正在 " .. sourceName .. " 搜索 \"" .. query .. "\"..."
    SearchBtn.Active = false
    SearchBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 120)

    local function onPageDone(completed, count)
        StatusLabel.Text = "加载中 " .. completed .. "/" .. maxPages .. " 页，已找到 " .. count .. " 个脚本"
    end

    local results
    if currentSource == "scriptblox" then
        results = fetchScriptBlox(query, maxPages, onPageDone)
    else
        results = fetchRscripts(query, maxPages, onPageDone)
    end

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    for i, entry in ipairs(results) do
        createCard(entry, i)
    end
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)

    if #results == 0 then
        StatusLabel.Text = "未找到相关脚本"
        showNotify("⚠ 未找到「" .. query .. "」相关脚本", Color3.fromRGB(220, 160, 60))
    else
        StatusLabel.Text = sourceName .. " 搜索完成，共 " .. #results .. " 个脚本"
        showNotify("✓ 从 " .. sourceName .. " 找到 " .. #results .. " 个脚本", Color3.fromRGB(80, 200, 140))
    end
    SearchBtn.Active = true
    SearchBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 200)
end

SearchBtn.MouseButton1Click:Connect(doSearch)
SearchBox.FocusLost:Connect(function(enter) if enter then doSearch() end end)
