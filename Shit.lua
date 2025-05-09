local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local DiscordEnabled = false
local WebhookURL = ""

local args = {
	"HideTags",
	true
}
game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("Settings"):FireServer(unpack(args))


-- ============= // Notification
pcall(function()
	if CoreGui:FindFirstChild("NotificationQueue") then
		CoreGui.NotificationQueue:Destroy()
	end
end)

local NotificationHolder = Instance.new("ScreenGui", CoreGui)
NotificationHolder.Name = "NotificationQueue"
NotificationHolder.ResetOnSpawn = false
NotificationHolder.IgnoreGuiInset = true

local notifications = {}

function ShowNotification(TitleText, BodyText)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 320, 0, 90)
	notif.Position = UDim2.new(1, 340, 0, 80 + (#notifications * 100))
	notif.AnchorPoint = Vector2.new(1, 0)
	notif.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	notif.BackgroundTransparency = 1
	notif.BorderSizePixel = 0
	notif.Parent = NotificationHolder
	table.insert(notifications, notif)

	local corner = Instance.new("UICorner", notif)
	corner.CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke", notif)
	stroke.Color = Color3.fromRGB(50, 50, 60)

	local title = Instance.new("TextLabel", notif)
	title.Text = TitleText or "Notification"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.new(1, 1, 1)
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -24, 0, 26)
	title.Position = UDim2.new(0, 12, 0, 10)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local message = Instance.new("TextLabel", notif)
	message.Text = BodyText or "Message goes here."
	message.Font = Enum.Font.Gotham
	message.TextSize = 16
	message.TextColor3 = Color3.fromRGB(200, 200, 200)
	message.BackgroundTransparency = 1
	message.Size = UDim2.new(1, -24, 1, -42)
	message.Position = UDim2.new(0, 12, 0, 36)
	message.TextWrapped = true
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.TextYAlignment = Enum.TextYAlignment.Top

	TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Position = UDim2.new(1, -20, 0, 80 + ((#notifications - 1) * 100)),
		BackgroundTransparency = 0
	}):Play()

	for _, label in ipairs({title, message}) do
		label.TextTransparency = 1
		TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	end

	task.delay(3, function()
		TweenService:Create(notif, TweenInfo.new(0.3), {
			Position = UDim2.new(1, 340, 0, notif.Position.Y.Offset),
			BackgroundTransparency = 1
		}):Play()
		for _, label in ipairs({title, message}) do
			TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		end

		task.wait(0.4)
		notif:Destroy()
		table.remove(notifications, table.find(notifications, notif))

		for i, n in ipairs(notifications) do
			TweenService:Create(n, TweenInfo.new(0.3), {
				Position = UDim2.new(1, -20, 0, 80 + ((i - 1) * 100))
			}):Play()
		end
	end)
end

-- ================= // Utilities
local Player = game.Players.LocalPlayer
local CarName = Player.Name .. "sCar"

function TweenToJob()
	ShowNotification("🚚 Job", "Tweening To PT.Shad Factory...")
	game.ReplicatedStorage.NetworkContainer.RemoteEvents.Job:FireServer("Truck")
	
	local Root = Player.Character:FindFirstChild("HumanoidRootPart")
	if not Root then return end

	TweenService:Create(Root, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
		CFrame = Root.CFrame + Vector3.new(0, 100, 0)
	}):Play()

	task.delay(0.5, function()
		TweenService:Create(Root, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			CFrame = CFrame.new(-21799.8, 1142.65, -26797.7)
		}):Play()

		task.delay(1, function()
			TweenService:Create(Root, TweenInfo.new(1, Enum.EasingStyle.Exponential), {
				CFrame = CFrame.new(-21799.8, 1042.65, -26797.7)
			}):Play()

			task.delay(1, function()
				Root.Anchored = true
				task.wait(0.3)
				Root.Anchored = false
			end)
		end)
	end)
end


function TakingJob()
	ShowNotification("🚚 Job", "Finding Best Destination...")
	repeat
		local Root = Player.Character:FindFirstChild("HumanoidRootPart")
		local Waypoint = workspace.Etc.Waypoint:FindFirstChild("Waypoint")
		local Label = Waypoint and Waypoint:FindFirstChild("BillboardGui") and Waypoint.BillboardGui:FindFirstChild("TextLabel")

		if Root then Root.Anchored = true end

		if Label and Label.Text ~= "Rojod Semarang" then
			game.ReplicatedStorage.NetworkContainer.RemoteEvents.Job:FireServer("Truck")
			local Prompt = workspace.Etc.Job.Truck.Starter:FindFirstChildWhichIsA("ProximityPrompt", true)
			if Prompt then
				Prompt.MaxActivationDistance = 100000
				fireproximityprompt(Prompt)
			end
		end

		if Root then Root.Anchored = false end
		task.wait(0.8)
	until Label and Label.Text == "Rojod Semarang"

	Player.Character.HumanoidRootPart.Anchored = false
	ShowNotification("🚚 Job", "Destination Found...")
end

function SpawningTruck()
	ShowNotification("🚚 Job", "Spawning Truck...")
	local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if not Root then return end

	Root.CFrame = CFrame.new(-21782.941, 1042.03, -26786.959)

	task.wait(2)
	local Vim = game:GetService("VirtualInputManager")
	Vim:SendKeyEvent(true, "F", false, game)
	task.wait(0.3)
	Vim:SendKeyEvent(false, "F", false, game)
	task.wait(5)

	local Car = workspace.Vehicles:FindFirstChild(CarName)
	local Humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
	local Seat = Car and Car:FindFirstChild("DriveSeat")
	if Humanoid and Seat then
		pcall(function() Seat:Sit(Humanoid) end)
		task.wait(0.5)
		Vim:SendKeyEvent(true, "Space", false, game)
		task.wait(0.1)
		Vim:SendKeyEvent(false, "Space", false, game)
	end

	local Trailer = Car and Car:FindFirstChild("Trailer1")
	if Trailer then
		Trailer:Destroy()
		print("Trailer destroyed to prevent interference.")
	end

end

function MovingCharacterToDestination(Destination)
	ShowNotification("🚚 Job", "Moving You To Near Destination...")

	local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	local Car = workspace.Vehicles:FindFirstChild(CarName)
	if not (Root and Car) then return end

	if not Car.PrimaryPart then
		for _, Part in ipairs(Car:GetDescendants()) do
			if Part:IsA("BasePart") then
				Car.PrimaryPart = Part
				break
			end
		end
	end

	local Follow = true
	task.spawn(function()
		while Follow do
			if Car.PrimaryPart then
				Car:PivotTo(Root.CFrame + Vector3.new(5, 0, 0))
			end
			task.wait(0.15)
		end
	end)

	local AboveStart = Root.CFrame + Vector3.new(0, 100, 0)
	local AboveDest = CFrame.new(Destination.Position + Vector3.new(0, 100, 0))

	TweenService:Create(Root, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
		CFrame = AboveStart
	}):Play()

	task.delay(0.4, function()
		TweenService:Create(Root, TweenInfo.new(1.6, Enum.EasingStyle.Sine), {
			CFrame = AboveDest
		}):Play()

		task.delay(1.6, function()
			TweenService:Create(Root, TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				CFrame = Destination
			}):Play()

			task.delay(1.8, function()
				Follow = false

				Root.Anchored = true
				if Car.PrimaryPart then Car.PrimaryPart.Anchored = true end

				task.wait(0.8)
				
				if Car.PrimaryPart then Car.PrimaryPart.Anchored = false end

				ShowNotification("🚚 Job", "Moved, Wait 50 seconds To Claim Salary...")
			end)
		end)
	end)
end


function SitInVehicle()
	local Car = workspace.Vehicles:FindFirstChild(CarName)
	local Hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
	local Seat = Car and Car:FindFirstChild("DriveSeat")
	if Hum and Seat then pcall(function() Seat:Sit(Hum) end) end
end

function InitialMap()
	local Workspace = cloneref(game:GetService("Workspace"))
	local Map = Workspace:FindFirstChild("Map", true)
	Map = Map and Map:FindFirstChild("Prop", true)
	if not Map then warn("Map not found") return true end

	local Target = Map:GetChildren()[499]
	if not Target then warn("Target object not found in Map") return false end
	Target:Destroy()

	local function Create(size, pos, name)
		local p = Instance.new("Part")
		p.Size, p.CFrame, p.Anchored, p.CanCollide, p.Material, p.Color, p.Name, p.Parent =
			size, CFrame.new(pos), true, true, Enum.Material.Plastic, Color3.fromRGB(163, 162, 165), name, workspace
		print(name .. " created at " .. tostring(pos))
	end

	local CharPos = Player.Character.HumanoidRootPart.Position
	Create(Vector3.new(128, 1, 128), Vector3.new(CharPos.X, 1, CharPos.Z), "BaseChar")
	Create(Vector3.new(128, 1, 128), Vector3.new(-21797.74, 1037.11, -26793.34), "BaseCarPart")
	Create(Vector3.new(2048, 1, 2048), Vector3.new(-21801, 1015, -26836), "BaseTruckPart")
	Create(Vector3.new(2048, 1, 2048), Vector3.new(-50919, 1005, -86457), "BaseRGPart")

	local mapFolder = workspace:FindFirstChild("Map")
	if mapFolder then mapFolder:Destroy() else print("Map folder not found") end
	return true
end

function AntiAFK()
	local VIM = game:GetService("VirtualInputManager")
	local Player = game:GetService("Players").LocalPlayer
	local Keys = {"W", "A", "S", "D"}

	local Connection = Player.Idled:Connect(function()
		task.spawn(function()
			local key = Keys[math.random(1, #Keys)]
			VIM:SendKeyEvent(true, key, false, game)
			task.wait(0.2)
			VIM:SendKeyEvent(false, key, false, game)

			local dx, dy = math.random(-5, 5), math.random(-5, 5)
			VIM:SendMouseMoveEvent(dx, dy, game)
		end)
	end)

	return Connection
end
AntiAFK()


-- Home
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer

local CoolNames = {
	"ShadowBlitz", "RexThunder", "NeoPhantom", "VenomAce", "GhostNova",
	"ZeroStrike", "AlphaDrift", "DarkVortex", "CrimsonByte", "TurboWolf"
}

local function RandomUsername()
	return CoolNames[math.random(1, #CoolNames)]
end

-- Destroy if exists
pcall(function()
	if game.CoreGui:FindFirstChild("TruckerUI") then
		game.CoreGui.TruckerUI:Destroy()
	end
end)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LunarDisplay"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = Lighting

local darkOverlay = Instance.new("Frame")
darkOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
darkOverlay.BackgroundTransparency = 1
darkOverlay.Size = UDim2.new(1, 0, 1, 0)
darkOverlay.ZIndex = 0
darkOverlay.Parent = screenGui

TweenService:Create(darkOverlay, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
	BackgroundTransparency = 0.2
}):Play()

local originalFOV = camera.FieldOfView
local zoomFOV = originalFOV * 0.8

TweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
	FieldOfView = zoomFOV
}):Play()

TweenService:Create(blurEffect, TweenInfo.new(1, Enum.EasingStyle.Sine), {
	Size = 20
}):Play()

local textList = {"L", "U", "N", "A", "R"}
local fontSize = 120
local spacing = 20
local labelWidth = fontSize + spacing
local totalWidth = #textList * labelWidth
local letterLabels = {}

for i, letter in ipairs(textList) do
	task.delay((i - 1) * 0.25, function()
		local label = Instance.new("TextLabel")
		label.Name = "Letter_" .. letter
		label.Parent = screenGui
		label.Size = UDim2.new(0, labelWidth, 0, fontSize + 40)
		label.Position = UDim2.new(0.5, ((i - (#textList / 2 + 0.5)) * labelWidth), 0.5, -(fontSize + 40)/2)
		label.BackgroundTransparency = 1
		label.Text = letter
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.GothamBlack
		label.TextScaled = true

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(0, 0, 0)
		stroke.Thickness = 2
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		stroke.Parent = label

		table.insert(letterLabels, label)
	end)
end

task.delay(0.25 * #textList + 3, function()
	for _, label in ipairs(letterLabels) do
		local xOffset = math.random(-200, 200)
		local yOffset = math.random(-150, 150)
		local rotation = math.random(-30, 30)

		local tween = TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = label.Position + UDim2.new(0, xOffset, 0, yOffset),
			Rotation = rotation,
			TextTransparency = 1
		})
		tween:Play()

		local stroke = label:FindFirstChildOfClass("UIStroke")
		if stroke then
			TweenService:Create(stroke, TweenInfo.new(1), { Transparency = 1 }):Play()
		end
	end
end)

task.delay(0.25 * #textList + 4.2, function()
	TweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Sine), {
		FieldOfView = originalFOV
	}):Play()

	TweenService:Create(blurEffect, TweenInfo.new(1), {
		Size = 0
	}):Play()

	TweenService:Create(darkOverlay, TweenInfo.new(1), {
		BackgroundTransparency = 1
	}):Play()
end)

task.delay(0.25 * #textList + 5.5, function()
	if blurEffect then blurEffect:Destroy() end
	if screenGui then screenGui:Destroy() end
end)

task.wait(6)

-- ScreenGui
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "TruckerUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Name = "MainUI"
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.BackgroundTransparency = 1
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 60)

-- Tween muncul UI
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
	Size = UDim2.new(0, 360, 0, 330),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	BackgroundTransparency = 0
}):Play()

task.wait(0.1)

-- Header
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, -60, 0, 28)
Header.Position = UDim2.new(0, 10, 0, 10)
Header.BackgroundTransparency = 1
Header.Text = "🚛  Trucker Assistant"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Position = UDim2.new(1, -30, 0, 10)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 16
Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -60, 0, 10)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.TextSize = 16

local SettingsBtn = Instance.new("TextButton", Main)
SettingsBtn.Size = UDim2.new(0, 24, 0, 24)
SettingsBtn.Position = UDim2.new(1, -90, 0, 10)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = "⚙️"
SettingsBtn.TextColor3 = Color3.new(1, 1, 1)

local Info = Instance.new("Frame", Main)
Info.Name = "Info"
Info.Position = UDim2.new(0, 10, 0, 48)
Info.Size = UDim2.new(1, -20, 0, 240)
Info.BackgroundTransparency = 1

local InfoLayout = Instance.new("UIListLayout", Info)
InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
InfoLayout.Padding = UDim.new(0, 4)

local function InfoText(txt)
	local label = Instance.new("TextLabel", Info)
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Ubuntu
	label.Text = txt
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextSize = 16
	return label
end

local InfoLines = {
	InfoText("👤 Username: " .. Player.Name),
	InfoText("🆔 UserId: " .. Player.UserId),
	InfoText("📅 Account Age: " .. Player.AccountAge .. " days"),
	InfoText("--- Farming Statistic ---"),
	InfoText("💰 Uang: Loading..."),
	InfoText("⏱️ Waktu Farming: 0 detik"),
}

local TextService = game:GetService("TextService")

-- Ambil UsernameLabel dari InfoLines[1]
local UsernameLabel = InfoLines[1]

-- Buat tombol recyle sekali saja
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 20, 0, 20)
RefreshBtn.BackgroundTransparency = 1
RefreshBtn.Text = "♻️"
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 14
RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
RefreshBtn.Parent = UsernameLabel
RefreshBtn.AnchorPoint = Vector2.new(0, 0)

-- Fungsi untuk update posisi tombol
local function UpdateRefreshButtonPos()
	local fullText = UsernameLabel.Text
	local textSize = TextService:GetTextSize(fullText, UsernameLabel.TextSize, UsernameLabel.Font, Vector2.new(1000, 20))
	RefreshBtn.Position = UDim2.new(0, textSize.X + 6, 0, 0)
end

-- Update posisi pertama kali
UpdateRefreshButtonPos()

-- Saat tombol diklik
RefreshBtn.MouseButton1Click:Connect(function()
	local newName = RandomUsername()
	UsernameLabel.Text = "👤 Username: " .. newName
	UpdateRefreshButtonPos()
end)


local LabelMoney = InfoLines[5]
local LabelTime = InfoLines[6]
local LabelLastEarning = InfoText("📥 Last Earning: Rp 0")
local LabelTotalEarning = InfoText("📊 Total Earning: Rp 0")

table.insert(InfoLines, 7, LabelLastEarning)
table.insert(InfoLines, 8, LabelTotalEarning)

-- Webhook Row
local WebhookFrame = Instance.new("Frame", Info)
WebhookFrame.Size = UDim2.new(1, 0, 0, 26)
WebhookFrame.BackgroundTransparency = 1

local WebhookLayout = Instance.new("UIListLayout", WebhookFrame)
WebhookLayout.FillDirection = Enum.FillDirection.Horizontal
WebhookLayout.SortOrder = Enum.SortOrder.LayoutOrder
WebhookLayout.Padding = UDim.new(0, 4)

local WebhookBox = Instance.new("TextBox", WebhookFrame)
WebhookBox.Size = UDim2.new(0.58, 0, 1, 0)
WebhookBox.PlaceholderText = "Webhook URL"
WebhookBox.Text = "" -- biar placeholder bisa muncul
WebhookBox.Font = Enum.Font.Ubuntu
WebhookBox.TextSize = 14
WebhookBox.TextColor3 = Color3.fromRGB(200, 200, 200)
WebhookBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
WebhookBox.TextXAlignment = Enum.TextXAlignment.Left
WebhookBox.ClearTextOnFocus = true -- biar langsung ilang placeholder saat klik
WebhookBox.TextWrapped = false
WebhookBox.TextTruncate = Enum.TextTruncate.AtEnd
WebhookBox.ClipsDescendants = true

local ToggleBtn = Instance.new("TextButton", WebhookFrame)
ToggleBtn.Size = UDim2.new(0.2, 0, 1, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Text = "OFF"
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local TestBtn = Instance.new("TextButton", WebhookFrame)
TestBtn.Size = UDim2.new(0.2, 0, 1, 0)
TestBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 100)
TestBtn.TextColor3 = Color3.new(1, 1, 1)
TestBtn.Font = Enum.Font.GothamBold
TestBtn.TextSize = 13
TestBtn.Text = "Test"
Instance.new("UICorner", TestBtn).CornerRadius = UDim.new(0, 6)

-- Config UI
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local truckerGui = CoreGui:WaitForChild("TruckerUI")
local mainUI = CoreGui:WaitForChild("TruckerUI"):WaitForChild("MainUI")

local Frame = Instance.new("Frame", mainUI)
Frame.Name = "ConfigFrame"
Frame.Size = UDim2.fromOffset(260, 210)
Frame.Position = UDim2.new(0, mainUI.Size.X.Offset + 160, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Visible = false
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame", Frame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚙️ Configuration"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "x"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundTransparency = 1

local Content = Instance.new("Frame", Frame)
Content.Name = "Content"
Content.Position = UDim2.new(0, 0, 0, 30)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", Content)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)

-- Countdown Teleport Section
local Row = Instance.new("Frame", Content)
Row.Size = UDim2.new(1, 0, 0, 32)
Row.BackgroundTransparency = 1
Row.Name = "CountdownRow"

local RowLayout = Instance.new("UIListLayout", Row)
RowLayout.FillDirection = Enum.FillDirection.Horizontal
RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
RowLayout.Padding = UDim.new(0, 4)

local Label = Instance.new("TextLabel", Row)
Label.Text = "   ⏳ Countdown Teleport" 
Label.Size = UDim2.new(0.55, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.Ubuntu
Label.TextSize = 16
Label.TextXAlignment = Enum.TextXAlignment.Left

local Input = Instance.new("TextBox", Row)
Input.Size = UDim2.new(0, 50, 1, 0) 
Input.PlaceholderText = "0"
Input.Text = "45"
Input.BackgroundTransparency = 1
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.Ubuntu
Input.TextSize = 16
Input.TextXAlignment = Enum.TextXAlignment.Right
Input.ClipsDescendants = true

_G.CountdownValue = 45

-- Update global saat user input
Input:GetPropertyChangedSignal("Text"):Connect(function()
	if not Input:IsFocused() then return end
	Input.Text = Input.Text:gsub("[^%d]", ""):sub(1, 3)
	_G.CountdownValue = tonumber(Input.Text) or 0
end)

local dragging = false
local dragStart, startPos = nil, nil

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainUI.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)

SettingsBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)



-- Toggle Mini
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	if Minimized then
		TweenService:Create(Main, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 360, 0, 48)
		}):Play()
		Info.Visible = false
	else
		TweenService:Create(Main, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 360, 0, 330)
		}):Play()
		task.delay(0.3, function()
			Info.Visible = true
		end)
	end
end)

-- [[ overlay glass black ]] -- 
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local CountdownLabel = nil

function CountdownTeleport(seconds)
	local overlay = CoreGui:FindFirstChild("GlassOverlay")
	if not overlay then return end

	if not CountdownLabel then
		CountdownLabel = Instance.new("TextLabel", overlay)
		CountdownLabel.Size = UDim2.new(0, 200, 0, 80)
		CountdownLabel.Position = UDim2.new(0.5, 0, 0.5, 100) 
		CountdownLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		CountdownLabel.BackgroundTransparency = 1
		CountdownLabel.Font = Enum.Font.GothamBold 
		CountdownLabel.TextSize = 70
		CountdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		CountdownLabel.TextStrokeTransparency = 0.5
		CountdownLabel.TextScaled = true
	end
	

	CountdownLabel.Visible = true
	for i = seconds, 1, -1 do
		CountdownLabel.Text = tostring(i)
		task.wait(1)
	end

	CountdownLabel.Visible = false
end

function ToggleGlassOverlay()
	local existing = CoreGui:FindFirstChild("GlassOverlay")
	if existing then
		existing:Destroy()
		print("[GlassOverlay] Removed from screen.")
	else
		local overlay = Instance.new("ScreenGui")
		overlay.Name = "GlassOverlay"
		overlay.IgnoreGuiInset = true
		overlay.ResetOnSpawn = false
		overlay.DisplayOrder = 1
		overlay.Parent = CoreGui

		local bg = Instance.new("Frame", overlay)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Position = UDim2.new(0, 0, 0, 0)
		bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BackgroundTransparency = 1
		bg.BorderSizePixel = 0

		local TextContainer = Instance.new("Frame", overlay)
		TextContainer.Size = UDim2.new(1, 0, 1, 0)
		TextContainer.BackgroundTransparency = 1

		local CombinedText = Instance.new("TextLabel", TextContainer)
		CombinedText.Size = UDim2.new(0, 800, 0, 50)
		CombinedText.Position = UDim2.new(0.5, 0, 0.5, -25)
		CombinedText.AnchorPoint = Vector2.new(0.5, 0.5)
		CombinedText.BackgroundTransparency = 1
		CombinedText.Font = Enum.Font.Ubuntu
		CombinedText.TextSize = 26
		CombinedText.TextColor3 = Color3.fromRGB(255, 255, 255)
		CombinedText.TextStrokeTransparency = 0.6
		CombinedText.TextWrapped = true
		CombinedText.TextScaled = true
		CombinedText.RichText = true
		CombinedText.Text = ""
		CombinedText.TextTransparency = 0

		local SubText = Instance.new("TextLabel", TextContainer)
		SubText.AnchorPoint = Vector2.new(0.5, 0.5)
		SubText.Position = UDim2.new(0.5, 0, 0.5, 30)
		SubText.Size = UDim2.new(0, 400, 0, 30)
		SubText.BackgroundTransparency = 1
		SubText.Text = "https://discord.gg/FMuRa8p5Hd"
		SubText.Font = Enum.Font.Ubuntu
		SubText.TextSize = 20
		SubText.TextColor3 = Color3.fromRGB(104, 168, 255)
		SubText.TextStrokeTransparency = 0.7
		SubText.TextWrapped = true
		SubText.TextScaled = true
		SubText.TextTransparency = 1

		TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
		TweenService:Create(SubText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

		task.spawn(function()
			local prefix = "Auto Farming"
			local suffix = " actived, dont close or do anyting"
			local fullText = prefix .. suffix

			local delayPerChar = 0.03
			for i = 1, #fullText do
				local typed = fullText:sub(1, i)
				if typed:sub(1, #prefix) == prefix then
					CombinedText.Text = "<font color='rgb(104,168,255)'>" ..
						typed:sub(1, #prefix) ..
						"</font>" .. typed:sub(#prefix + 1)
				else
					CombinedText.Text = typed
				end
				game:GetService("RunService").RenderStepped:Wait()
				task.wait(delayPerChar)
			end
		end)
	end
end

function GlassOverlayStopped()
	local existing = CoreGui:FindFirstChild("GlassOverlay")
	if existing then
		existing:Destroy()
	end

	local overlay = Instance.new("ScreenGui")
	overlay.Name = "GlassOverlay"
	overlay.IgnoreGuiInset = true
	overlay.ResetOnSpawn = false
	overlay.DisplayOrder = 1
	overlay.Parent = CoreGui

	local bg = Instance.new("Frame", overlay)
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.Position = UDim2.new(0, 0, 0, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0

	local TextContainer = Instance.new("Frame", overlay)
	TextContainer.Size = UDim2.new(1, 0, 1, 0)
	TextContainer.BackgroundTransparency = 1

	local CombinedText = Instance.new("TextLabel", TextContainer)
	CombinedText.Size = UDim2.new(0, 800, 0, 50)
	CombinedText.Position = UDim2.new(0.5, 0, 0.5, -25)
	CombinedText.AnchorPoint = Vector2.new(0.5, 0.5)
	CombinedText.BackgroundTransparency = 1
	CombinedText.Font = Enum.Font.Ubuntu
	CombinedText.TextSize = 26
	CombinedText.TextColor3 = Color3.fromRGB(255, 255, 255)
	CombinedText.TextStrokeTransparency = 0.6
	CombinedText.TextWrapped = true
	CombinedText.TextScaled = true
	CombinedText.RichText = true
	CombinedText.Text = ""
	CombinedText.TextTransparency = 0

	local SubText = Instance.new("TextLabel", TextContainer)
	SubText.AnchorPoint = Vector2.new(0.5, 0.5)
	SubText.Position = UDim2.new(0.5, 0, 0.5, 30)
	SubText.Size = UDim2.new(0, 400, 0, 30)
	SubText.BackgroundTransparency = 1
	SubText.Text = "https://discord.gg/FMuRa8p5Hd"
	SubText.Font = Enum.Font.Ubuntu
	SubText.TextSize = 20
	SubText.TextColor3 = Color3.fromRGB(104, 168, 255)
	SubText.TextStrokeTransparency = 0.7
	SubText.TextWrapped = true
	SubText.TextScaled = true
	SubText.TextTransparency = 1

	TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
	TweenService:Create(SubText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

	task.spawn(function()
		local prefix = "Auto Farming Stopped"
		local suffix = " thanks yall for using our script"
		local fullText = prefix .. suffix
		local delayPerChar = 0.03

		for i = 1, #fullText do
			local typed = fullText:sub(1, i)
			if typed:sub(1, #prefix) == prefix then
				CombinedText.Text =
					"<font color='rgb(255,80,80)'>" ..
					typed:sub(1, #prefix) ..
					"</font>" .. typed:sub(#prefix + 1)
			else
				CombinedText.Text = typed
			end
			RunService.RenderStepped:Wait()
			task.wait(delayPerChar)
		end

		task.wait(5)

		local fadeOutTime = 0.4
		TweenService:Create(bg, TweenInfo.new(fadeOutTime), {BackgroundTransparency = 1}):Play()
		TweenService:Create(CombinedText, TweenInfo.new(fadeOutTime), {TextTransparency = 1}):Play()
		TweenService:Create(SubText, TweenInfo.new(fadeOutTime), {TextTransparency = 1}):Play()

		task.wait(fadeOutTime + 0.1)
		overlay:Destroy()

		task.wait(0.8)
		local LocalPlayer = game:GetService("Players").LocalPlayer
		LocalPlayer:Kick("[Lunar Message]\nYour farming session has ended. Rejoin the game to resume safely.")

	end)
end


-- Farming Button
local Btn = Instance.new("TextButton", Info)
Btn.Size = UDim2.new(1, 0, 0, 36)
Btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
Btn.TextColor3 = Color3.new(1, 1, 1)
Btn.Text = "Start Auto Farming"
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 16
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

table.insert(InfoLines, Btn)

ToggleBtn.MouseButton1Click:Connect(function()
	DiscordEnabled = not DiscordEnabled
	WebhookURL = WebhookBox.Text

	ToggleBtn.Text = DiscordEnabled and "ON" or "OFF"
	ToggleBtn.BackgroundColor3 = DiscordEnabled and Color3.fromRGB(40, 160, 90) or Color3.fromRGB(100, 100, 200)

	ShowNotification("Webhook", DiscordEnabled and "Auto-report ENABLED" or "Auto-report DISABLED")
end)

TestBtn.MouseButton1Click:Connect(function()
	WebhookURL = WebhookBox.Text
	if WebhookURL == "" then
		ShowNotification("❌ Webhook", "Masukkan URL webhook terlebih dahulu!")
		return
	end

	local Http = (syn and syn.request) or http_request
	local data = {
		content = "**Test Message:** Webhook terhubung dari Trucker Assistant 🚛"
	}
	local json = game:GetService("HttpService"):JSONEncode(data)

	local success, err = pcall(function()
		Http({
			Url = WebhookURL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = json
		})
	end)

	if success then
		ShowNotification("✅ Webhook", "Pesan test berhasil dikirim ke Discord.")
	else
		ShowNotification("❌ Webhook", "Gagal kirim pesan: " .. tostring(err))
	end
end)

Btn.MouseButton1Click:Connect(function()
	local mainUI = CoreGui:WaitForChild("TruckerUI")
	if not Farming then
		mainUI.DisplayOrder = 2

		TweenService:Create(Main, TweenInfo.new(0.3), {
			Size = UDim2.new(0, 360, 0, 48)
		}):Play()
		Info.Visible = false

		ToggleGlassOverlay()
		StartFarming()
	else
		Farming = false
		GlassOverlayStopped()
		if FarmingThread then task.cancel(FarmingThread) end
		Btn.Text = "Start Auto Farming"
		Btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
	end
end)

-- Drag
local dragging, startPos, dragStart
Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
	end
end)

Main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

function StartFarming()
	Farming = true
	StartTime = os.clock()
	Btn.Text = "Stop Farming"
	Btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)

	FarmingThread = task.spawn(function()
		while Farming do
			game:GetService("RunService"):Set3dRenderingEnabled(false)
			InitialMap()
			task.wait(0.5)
			TweenToJob()
			task.wait(0.5)
			TakingJob()
			task.wait(0.5)
			SpawningTruck()
			task.wait(0.5)
			MovingCharacterToDestination(CFrame.new(-50937.152, 1012.215, -86353.031))
			CountdownTeleport(_G.CountdownValue)
			SitInVehicle()
			CarTween(CFrame.new(-50899.6015625, 1013.977783203125, -86534.9765625))
			task.wait(0.5)
		end
	end)
end

function UpdateEarningStats()

	local function cleanToNumber(text)
		text = tostring(text or "")
		text = text:gsub("[^%d]", "")
		return tonumber(text) or 0
	end

	local function formatRupiah(amount)
		local formatted = tostring(amount)
		local k
		while true do
			formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
			if k == 0 then break end
		end
		return "Rp" .. formatted
	end

	local uangLabel = Player.PlayerGui.Main.Container.Hub.CashFrame.Frame:FindFirstChild("TextLabel")
	local EarningText = Player.PlayerGui.Main.Container.Hub.CashFrame:FindFirstChild("TextLabel")

	if uangLabel and EarningText then
		local uangText = uangLabel.Text
		LabelMoney.Text = "💰 Money: " .. uangText

		local EarningValue = cleanToNumber(EarningText.Text)
		local earned = EarningValue

		TotalEarning = TotalEarning or 0
		TotalEarning += earned

		_G.LastEarningFormatted = formatRupiah(earned)
		_G.TotalEarningFormatted = formatRupiah(TotalEarning)

		LabelLastEarning.Text = "📥 Last Earning: " .. formatRupiah(earned)
		LabelTotalEarning.Text = "📊 Total Earning: " .. formatRupiah(TotalEarning)

		local orig = LabelLastEarning.Position
		TweenService:Create(LabelLastEarning, TweenInfo.new(0.1), {
			Position = orig + UDim2.new(0, 0, 0, -5)
		}):Play()
		task.wait(0.1)
		TweenService:Create(LabelLastEarning, TweenInfo.new(0.1), {
			Position = orig
		}):Play()

		LastRecorded = currentMoney or 0
	end

	if StartTime then
		LabelTime.Text = "⏱️ Waktu Farming: " .. math.floor(os.clock() - StartTime) .. " detik"
	end
end


function CarTween(TargetCFrame)
	local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	Root.Anchored = false

	task.wait(0.2)

	local Car = workspace.Vehicles:FindFirstChild(CarName)
	if not Car then warn("Vehicle not found.") return end
	if not Car.PrimaryPart then
		local Seat = Car:FindFirstChild("DriveSeat")
		if Seat then Car.PrimaryPart = Seat else return end
	end

	local Temp = Instance.new("CFrameValue", workspace)
	Temp.Value = Car:GetPivot()

	local Tween = game:GetService("TweenService"):Create(Temp, TweenInfo.new(3, Enum.EasingStyle.Linear), {
		Value = TargetCFrame
	})

	Temp:GetPropertyChangedSignal("Value"):Connect(function()
		Car:PivotTo(Temp.Value)
	end)

	Tween:Play()
	Tween.Completed:Wait()
	Temp:Destroy()

	game.ReplicatedStorage.NetworkContainer.RemoteEvents.Job:FireServer("Truck")

	task.wait(0.2)
	local Root = Player.Character:FindFirstChild("HumanoidRootPart")
	Root.Anchored = true
	task.wait(0.2)
	Root.Anchored = false
	task.wait(0.02)
	UpdateEarningStats()

	if DiscordEnabled and WebhookURL ~= "" then
		local Http = (syn and syn.request) or http_request
		local HttpService = game:GetService("HttpService")
	
		local uang = Player.PlayerGui.Main.Container.Hub.CashFrame.Frame:FindFirstChild("TextLabel")
		local waktuFarming = os.date("!%H:%M:%S", math.floor(os.clock() - StartTime))
	
		local embedData = {
			embeds = {{
				title = "💼 Jobs Data",
				color = 0x5865F2, -- Discord blurple
				fields = {
					{ name = "Nickname", value = "• " .. Player.Name, inline = false },
					{ name = "Elapsed Time", value = "• " .. waktuFarming, inline = false },
					{ name = "Current Money", value = "• " .. (uang and uang.Text or "-"), inline = false },
					{ name = "Money Received", value = "• " .. (_G.LastEarningFormatted or "-"), inline = false },
					{ name = "Total Earnings", value = "• " .. (_G.TotalEarningFormatted or "-"), inline = false }
				},
				footer = {
					text = "Send Time: " .. os.date("%X") .. "\nMade with love by Lunar"
				}
			}}
		}
	
		local json = HttpService:JSONEncode(embedData)
	
		pcall(function()
			Http({
				Url = WebhookURL,
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = json
			})
		end)
	end	

end

Player.CharacterAdded:Connect(function(char)
	if Farming then
		task.wait(1.5)
		if FarmingThread then
			task.cancel(FarmingThread)
		end
		StartFarming()
	end
end)







