local Creator = {
	Registry = {},
	Signals = {},
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = -5,
			IgnoreGuiInset = true,
		},

		Frame = {
			BackgroundColor3 = Color3.fromRGB(10, 10, 10),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = true,
		},

		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			FontFace = Font.new("rbxassetid://12187365364"),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			TextStrokeTransparency = 0.95,
			TextSize = 14,
			TextScaled = true,
		},

		ImageLabel = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		},

		CanvasGroup = {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
		},

		UICorner = {
			CornerRadius = UDim.new(1, 0),
		},

		UIStroke = {
			Thickness = 1.5,
		},
	},
}

function Creator.AddSignal(Signal, Function)
	table.insert(Creator.Signals, Signal:Connect(Function))
end

function Creator.Disconnect()
	for Idx = #Creator.Signals, 1, -1 do
		local Connection = table.remove(Creator.Signals, Idx)
		Connection:Disconnect()
	end
end

function Creator.New(Name, Properties)
	local Object = Instance.new(Name)

	-- Default properties
	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end

	-- Properties
	for Name, Value in next, Properties or {} do
		Object[Name] = Value
	end

	return Object
end

return Creator
