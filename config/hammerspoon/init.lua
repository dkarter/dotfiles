hs.loadSpoon 'EmmyLua'
hs.loadSpoon 'ReloadConfiguration'
spoon.ReloadConfiguration:start()

hs.hotkey.bind({ 'cmd', 'alt' }, 'w', function()
  hs.alert.show 'hi world!'
end)
