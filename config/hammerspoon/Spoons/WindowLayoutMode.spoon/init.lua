---@diagnostic disable: need-check-nil, undefined-field
local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'WindowLayoutMode'
obj.version = '1.0'
obj.author = 'Dorian Karter'
obj.homepage = 'https://github.com/dkarter/dotfiles'
obj.license = 'MIT - https://opensource.org/licenses/MIT'

-- Variable to hold the original window positions
local originalWindows = {}

-- Variable to track if we're in layout mode
local inLayoutMode = false

local layoutModeIndicator = nil

-- Variables to hold the hotkey objects so we can disable/enable them
local hotkeys = {}

local function moveWindowToAlmostMaximize()
  if not inLayoutMode then
    return
  end

  local win = hs.window.focusedWindow()

  if not win then
    return
  end

  local screenFrame = win:screen():frame()
  local newFrame = screenFrame:scale(0.9)
  newFrame.center = screenFrame.center -- Center the window
  win:setFrame(newFrame)
end

local function moveWindowToFullScreen()
  if not inLayoutMode then
    return
  end
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local screenFrame = win:screen():frame()
  win:setFrame(screenFrame)
end

-- Unbind layout keys when exiting layout mode
local function unbind_layout_keys()
  for _, hotkey in pairs(hotkeys) do
    hotkey:delete()
  end
  hotkeys = {}
end

-- Function to move the focused window to a specified position
local function moveWindowTo(position)
  if not inLayoutMode then
    return
  end
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local screenFrame = win:screen():frame()
  local newFrame = win:frame()

  if position == 'left' then
    newFrame.x = screenFrame.x
    newFrame.y = screenFrame.y
    newFrame.w = screenFrame.w / 2
    newFrame.h = screenFrame.h
  elseif position == 'right' then
    newFrame.x = screenFrame.x + (screenFrame.w / 2)
    newFrame.y = screenFrame.y
    newFrame.w = screenFrame.w / 2
    newFrame.h = screenFrame.h
  elseif position == 'bottom' then
    newFrame.x = screenFrame.x
    newFrame.y = screenFrame.y + (screenFrame.h / 2)
    newFrame.w = screenFrame.w
    newFrame.h = screenFrame.h / 2
  elseif position == 'top' then
    newFrame.x = screenFrame.x
    newFrame.y = screenFrame.y
    newFrame.w = screenFrame.w
    newFrame.h = screenFrame.h / 2
  end

  win:setFrame(newFrame)
end

-- Function to commit changes and exit layout mode
local function commitChanges()
  if not inLayoutMode then
    return
  end

  -- remove layout mode indicator
  layoutModeIndicator:delete()
  layoutModeIndicator = nil

  inLayoutMode = false
  hs.alert.show 'Exited Window Layout Mode (changes committed)'
  unbind_layout_keys()
end

-- Function to cancel changes and exit layout mode
local function cancelChanges()
  if not inLayoutMode then
    return
  end

  -- remove layout mode indicator
  layoutModeIndicator:delete()
  layoutModeIndicator = nil

  -- Move windows back to their original positions
  for id, frame in pairs(originalWindows) do
    local win = hs.window.get(id)
    if win then
      win:setFrame(frame)
    end
  end
  originalWindows = {}
  inLayoutMode = false
  hs.alert.show 'Exited Window Layout Mode (changes reverted)'
  unbind_layout_keys()
end

local function moveWindowBy(direction, amount)
  if not inLayoutMode then
    return
  end
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local stepSize = amount or 50
  local currentFrame = win:frame()

  if direction == 'left' then
    currentFrame.x = currentFrame.x - stepSize
  elseif direction == 'right' then
    currentFrame.x = currentFrame.x + stepSize
  elseif direction == 'up' then
    currentFrame.y = currentFrame.y - stepSize
  elseif direction == 'down' then
    currentFrame.y = currentFrame.y + stepSize
  end

  win:setFrame(currentFrame)
end

local function resizeWindowBy(direction, amount)
  if not inLayoutMode then
    return
  end
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local stepSize = amount or 50 -- Define the step size
  local currentFrame = win:frame()

  if direction == 'left' then
    currentFrame.w = currentFrame.w - stepSize
  elseif direction == 'right' then
    currentFrame.w = currentFrame.w + stepSize
  elseif direction == 'up' then
    currentFrame.h = currentFrame.h - stepSize
  elseif direction == 'down' then
    currentFrame.h = currentFrame.h + stepSize
  end

  win:setFrame(currentFrame)
end

-- Bind keys only within layout mode
local function bindLayoutKeys()
  hotkeys.cmd_h = hs.hotkey.bind({ 'cmd' }, 'h', function()
    moveWindowTo 'left'
  end)
  hotkeys.cmd_l = hs.hotkey.bind({ 'cmd' }, 'l', function()
    moveWindowTo 'right'
  end)
  hotkeys.cmd_j = hs.hotkey.bind({ 'cmd' }, 'j', function()
    moveWindowTo 'bottom'
  end)
  hotkeys.cmd_k = hs.hotkey.bind({ 'cmd' }, 'k', function()
    moveWindowTo 'top'
  end)

  -- New bindings without modifiers to move window
  hotkeys.h = hs.hotkey.bind({}, 'h', function()
    moveWindowBy 'left'
  end)
  hotkeys.l = hs.hotkey.bind({}, 'l', function()
    moveWindowBy 'right'
  end)
  hotkeys.j = hs.hotkey.bind({}, 'j', function()
    moveWindowBy 'down'
  end)
  hotkeys.k = hs.hotkey.bind({}, 'k', function()
    moveWindowBy 'up'
  end)

  -- New bindings with ctrl modifier to resize window
  hotkeys.ctrl_h = hs.hotkey.bind({ 'ctrl' }, 'h', function()
    resizeWindowBy 'left'
  end)
  hotkeys.ctrl_l = hs.hotkey.bind({ 'ctrl' }, 'l', function()
    resizeWindowBy 'right'
  end)
  hotkeys.ctrl_j = hs.hotkey.bind({ 'ctrl' }, 'j', function()
    resizeWindowBy 'down'
  end)
  hotkeys.ctrl_k = hs.hotkey.bind({ 'ctrl' }, 'k', function()
    resizeWindowBy 'up'
  end)

  hotkeys.space = hs.hotkey.bind({}, 'space', moveWindowToFullScreen)
  hotkeys.a = hs.hotkey.bind({}, 'a', moveWindowToAlmostMaximize)
  hotkeys.returnKey = hs.hotkey.bind({}, 'return', commitChanges)
  hotkeys.escapeKey = hs.hotkey.bind({}, 'escape', cancelChanges)
end

local function buildLayoutModeIndicator()
  -- Create and show the layout mode indicator (image)
  local screenFrame = hs.screen.primaryScreen():frame()
  local imagePath = '~/.config/hammerspoon/Spoons/WindowLayoutMode.spoon/WindowLayoutMode.png'
  local iconSize = 500

  local indicator = hs.drawing.image(
    hs.geometry.rect(
      (screenFrame.w - iconSize) / 2, -- Center horizontally
      (screenFrame.h - iconSize) / 2, -- Center vertically
      iconSize,
      iconSize
    ),
    imagePath
  )
  indicator:setAlpha(0.8)
  indicator:setBehaviorByLabels { 'canJoinAllSpaces', 'stationary' }
  indicator:bringToFront(true)

  return indicator
end

-- Function to enter layout mode
local function enterLayoutMode()
  if inLayoutMode then
    return
  end

  -- Create and show the layout mode indicator
  layoutModeIndicator = buildLayoutModeIndicator()
  layoutModeIndicator:show()

  -- Save the original positions of all windows
  originalWindows = {}
  local allWindows = hs.window.allWindows()
  for _, win in ipairs(allWindows) do
    originalWindows[win:id()] = win:frame()
  end

  inLayoutMode = true
  hs.alert.show 'Entered Window Layout Mode'
  bindLayoutKeys()
end

function obj:init()
  -- Bind the key to activate layout mode
  hs.hotkey.bind({ 'cmd' }, 'escape', enterLayoutMode)
end

return obj
