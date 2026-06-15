-- init
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/qwiix21/Venyx-UI-Library/refs/heads/main/source.lua"))()
local venyx = library.new("Venyx")

-- themes
local themes = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),
	TextColor = Color3.fromRGB(255, 255, 255)
}

-- first page
local page = venyx:addPage("Test", 5012544693)
local section1 = page:addSection("Section 1")
local section2 = page:addSection("Section 2")

section1:addToggle("Toggle", nil, function(value)
	print("Toggle:", value)
end)

section1:addButton("Button", function()
	print("Clicked")
end)

section1:addTextbox("Textbox", "Default", function(value, focusLost)
	print("Textbox:", value)
	if focusLost then
		venyx:Notify("Title", value)
	end
end)

-- "command" style input: callback fires ONLY on Enter (not on click-away),
-- and the field is cleared right after — like Rayfield's command box
section1:addInput("Run command", {
	placeholder = "Type a command and press Enter...",
	submitOnly = true,
	clearOnSubmit = true
}, function(value)
	print("Command executed:", value)
end)

-- Notify: info style (without callback) shows only one close button,
-- confirm style (with callback) shows Accept/Decline
section1:addButton("Show info notification", function()
	venyx:Notify({
		title = "Info",
		text = "Just an informational message",
		type = "info" -- info / success / warning / error
	})
end)

section1:addButton("Show confirm notification", function()
	venyx:Notify({
		title = "Confirm",
		text = "Are you sure?",
		type = "warning",
		duration = 0, -- 0 = do not close automatically
		callback = function(accepted)
			print("User chose:", accepted)
		end
	})
end)

section2:addKeybind("Toggle Keybind", Enum.KeyCode.One, function()
	print("Activated Keybind")
	venyx:toggle()
end, function()
	print("Changed Keybind")
end)

section2:addColorPicker("ColorPicker", Color3.fromRGB(50, 50, 50))
section2:addColorPicker("ColorPicker2")

-- addSlider: new format with options table, supports increment and suffix
section2:addSlider("Slider", {
	default = 0,
	min = -100,
	max = 100,
	increment = 1,
	suffix = ""
}, function(value)
	print("Dragged", value)
end)

-- addSlider with step 0.01 (from 0 to 1)
section2:addSlider("Slider with non-integer values", {
	default = 0.5,
	min = 0,
	max = 1,
	increment = 0.01,
	suffix = ""
}, function(value)
	print("Slider value:", value)
end)

-- Dropdown: now supports search ("best match") on click,
-- previously selected value is shown as placeholder and not editable
section2:addDropdown("Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"})

section2:addDropdown("Dropdown with callback", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"}, function(text)
	print("Selected", text)
end)

-- Multi-select dropdown
section2:addDropdown("Multi Dropdown", {
	list = {"Select 1", "Select 2", "Select 3", "Select 4", "Select 5"},
	multi = true,
	default = {"Select 1", "Select 3"}
}, function(selected)
	print("Selected items:", table.concat(selected, ", "))
end)

section2:addButton("Button")

-- second page
local theme = venyx:addPage("Theme", 5012544693)
local colors = theme:addSection("Colors")

for themeName, color in pairs(themes) do -- all in one theme changer, i know, im cool
	colors:addColorPicker(themeName, color, function(color3)
		venyx:setTheme(themeName, color3)
	end)
end

-- third page: Config / save settings
local configPage = venyx:addPage("Config", 5012544693)
local configSection = configPage:addSection("Settings")

local toggle1 = configSection:addToggle("Toggle", false, function(value)
	print("Toggle:", value)
end)

local slider1 = configSection:addSlider("Slider", {
	default = 50,
	min = 0,
	max = 100,
	increment = 1,
	suffix = ""
}, function(value)
	print("Slider:", value)
end)

local slider2 = configSection:addSlider("Slider with non-integer values", {
	default = 0.5,
	min = 0,
	max = 1,
	increment = 0.01,
	suffix = ""
}, function(value)
	print("Slider non-integer:", value)
end)

local input1 = configSection:addInput("Input", {
	default = "Text",
	placeholder = "Enter text..."
}, function(text, enterPressed, update)
	print("Input:", text)
end)

local keybind1 = configSection:addKeybind("Keybind", Enum.KeyCode.T, function()
	print("Keybind pressed")
end, function()
	print("Keybind changed")
end)

local colorPicker1 = configSection:addColorPicker("ColorPicker", Color3.fromRGB(100, 150, 255), function(color)
	print("ColorPicker:", color)
end)

local dropdown1 = configSection:addDropdown("Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"}, function(selected)
	print("Dropdown:", selected)
end)

local multiDropdown1 = configSection:addDropdown("Multi Dropdown", {
	list = {"Select 1", "Select 2", "Select 3", "Select 4", "Select 5"},
	multi = true,
	default = {"Select 1", "Select 3"}
}, function(selected)
	print("Multi Dropdown:", table.concat(selected, ", "))
end)

configSection:addButton("Button", function()
	print("Button clicked")
end)

local textbox1 = configSection:addTextbox("Textbox", "Default", function(value, focusLost)
	print("Textbox:", value, "Focus lost:", focusLost)
end)

-- Register flags: applyFn is called on LoadConfig.
-- IMPORTANT: pass `true` as the second argument to :Set() — this tells the
-- control to also fire its own callback (so the loaded value actually gets
-- applied to your game logic, not just shown in the UI).
venyx:RegisterFlag("Toggle", false, function(value)
	toggle1:Set(value, true)
end)

venyx:RegisterFlag("Slider", 50, function(value)
	slider1:Set(value, true)
end)

venyx:RegisterFlag("SliderNonInteger", 0.5, function(value)
	slider2:Set(value, true)
end)

venyx:RegisterFlag("Textbox", "Default", function(value)
	textbox1:Set(value, true)
end)

venyx:RegisterFlag("Input", "Text", function(value)
	input1:Set(value, true)
end)

venyx:RegisterFlag("Keybind", Enum.KeyCode.T, function(value)
	keybind1:Set(value, true)
end)

venyx:RegisterFlag("ColorPicker", Color3.fromRGB(100, 150, 255), function(value)
	colorPicker1:Set(value, true)
end)

venyx:RegisterFlag("Dropdown", "Option 1", function(value)
	dropdown1:Set(value, true)
end)

venyx:RegisterFlag("MultiDropdown", {"Select 1", "Select 3"}, function(value)
	multiDropdown1:Set(value, true)
end)

-- Save/Load buttons
local saveSection = configPage:addSection("Save/Load")

-- Configs can live inside a folder — just use "/" in the name.
-- SaveConfig will create the folder automatically (via makefolder) if it
-- doesn't exist yet. The file ends up at "MyScript/config.json".
local CONFIG_PATH = "MyScript/config"

saveSection:addButton("Save Config", function()
	venyx:SetFlag("Toggle", toggle1:Get())
	venyx:SetFlag("Slider", slider1:Get())
	venyx:SetFlag("SliderNonInteger", slider2:Get())
	venyx:SetFlag("Textbox", textbox1:Get())
	venyx:SetFlag("Input", input1:Get())
	venyx:SetFlag("Keybind", keybind1:Get())
	venyx:SetFlag("ColorPicker", colorPicker1:Get())
	venyx:SetFlag("Dropdown", dropdown1:Get())
	venyx:SetFlag("MultiDropdown", multiDropdown1:Get())
	venyx:SaveConfig(CONFIG_PATH)
	venyx:Notify({title = "Config", text = "Saved!", type = "success"})
end)

saveSection:addButton("Load Config", function()
	venyx:LoadConfig(CONFIG_PATH)
	venyx:Notify({title = "Config", text = "Loaded!", type = "success"})
end)

--[[
Automatic save/load (no buttons needed):

1. Call SetFlagSilent(name, value) inside each control's callback —
   it just records the value WITHOUT re-triggering applyFn (avoids
   infinite feedback loops with :Set()).
2. Debounce SaveConfig so it isn't written on every single frame
   while dragging a slider.
3. Call LoadConfig once on startup, after all controls/flags exist.

local saveDirty = false
task.spawn(function()
	while true do
		task.wait(2)
		if saveDirty then
			saveDirty = false
			venyx:SaveConfig(CONFIG_PATH)
		end
	end
end)

local function AutoSave()
	saveDirty = true
end

-- inside a control's callback:
-- venyx:SetFlagSilent("Slider", value)
-- AutoSave()

-- on startup, after RegisterFlag calls:
-- venyx:LoadConfig(CONFIG_PATH)
]]

-- load
venyx:SelectPage(venyx.pages[1], true)
