local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- GUI chính
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "WOKINGLOG_PvPMenu"

-- Frame menu
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 360)
frame.Position = UDim2.new(0.5, -160, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Visible = false

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
title.Text = "Thanh Tài menu pvp"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20

-- Nút X để đóng
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)

-- Tạo nút 👹 bật menu
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
openBtn.Text = ":))"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.FredokaOne
openBtn.TextSize = 24
openBtn.ZIndex = 10
openBtn.Visible = true

-- Hiệu ứng hover xoay nút 👹
openBtn.MouseEnter:Connect(function()
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween1 = ts:Create(openBtn, info, {Rotation = 15})
	local tween2 = ts:Create(openBtn, info, {Rotation = 0})
	tween1:Play()
	tween1.Completed:Connect(function()
		tween2:Play()
	end)
end)

-- Click nút 👹 bật menu
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
end)

-- Bấm nút X thì ẩn menu nhưng giữ nút 👹
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

-- Phím K toggle menu
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.K then
		frame.Visible = not frame.Visible
	end
end)

-- Tạo toggle
local y = 50
local function createToggle(name, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
	btn.BorderSizePixel = 1
	btn.Text = name .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	y = y + 40

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. ": " .. (state and "Bật " or "Tắt ")
		callback(state)
	end)
end

-- Hitbox To
createToggle("Hitbox Nhỏ", function(on)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
			local head = p.Character.Head
			if on then
				head.Size = Vector3.new(5, 5, 5)
				head.Transparency = 0.8
				head.Material = Enum.Material.ForceField
				head.BrickColor = BrickColor.new("Pastel yellow")
			else
				head.Size = Vector3.new(2, 1, 1)
				head.Transparency = 0
				head.Material = Enum.Material.Plastic
			end
		end
	end
end)


-- Auto Aim fix
createToggle("Auto Aim", function(on)
	if on then
		rs:BindToRenderStep("thanhtai_ltt", Enum.RenderPriority.Camera.Value + 1, function()
			local closest, dist = nil, 100
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local d = (p.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
					if d < dist then
						dist = d
						closest = p
					end
				end
			end
			if closest and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
				local root = lp.Character.HumanoidRootPart
				local targetPos = Vector3.new(
					closest.Character.HumanoidRootPart.Position.X,
					root.Position.Y,
					closest.Character.HumanoidRootPart.Position.Z
				)
				root.CFrame = CFrame.new(root.Position, targetPos)
			end
		end)
	else
		rs:UnbindFromRenderStep("thanhtai_ltt")
	end
end)


-- Auto Attack
createToggle("Auto Attack", function(on)
	if on then
		_G._autoAttack = true
		spawn(function()
			while _G._autoAttack do wait(0.2)
				local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
				if tool then pcall(function() tool:Activate() end) end
			end
		end)
	else
		_G._autoAttack = false
	end
end)


-- Kill Aura
createToggle("Kill Aura", function(on)
	if on then
		_G._killAura = true
		spawn(function()
			while _G._killAura do wait(0.2)
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						if (p.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 15 then
							pcall(function()
								game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(p)
							end)
						end
					end
				end
			end
		end)
	else
		_G._killAura = false
	end
end)


-- ESP
createToggle("ESP", function(on)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character then
			local h = p.Character:FindFirstChild("ESPHighlight")
			if on then
				if not h then
					h = Instance.new("Highlight", p.Character)
					h.Name = "ESPHighlight"
					h.FillColor = Color3.fromRGB(255, 0, 0)
				end
			else
				if h then h:Destroy() end
			end
		end
	end
end)

print(" Thanh Tài- Nút  luôn hiện sau khi đóng ❌")