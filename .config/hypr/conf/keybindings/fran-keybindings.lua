-- -----------------------------------------------------
-- Fran key bindings
-- -----------------------------------------------------

local mainMod = "SUPER"

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh"), { description = "Open the terminal" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/ml4w/settings/browser.sh"), { description = "Open the browser" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/filemanager"), { description = "Open the filemanager" })
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/emojipicker.sh"), { description = "Open the emoji picker" })
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh"), { description = "Open the calculator" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"), { description = "Open VS Code" })

-- fr keyboard layout setup
local is_fr = false
local f = io.open(os.getenv("HOME") .. "/.config/hypr/input.lua", "r")
if f then
    local content = f:read("*all")
    if content:match('kb_layout%s*=%s*"fr"') and not content:match('kb_variant%s*=%s*"us"') then
        is_fr = true
    end
    f:close()
end

local fr_keys = {
    "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft",
    "minus", "egrave", "underscore", "ccedilla", "agrave"
}

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    if is_fr then
        key = fr_keys[i]
    end

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Focus workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/killactive.sh"), { description = "Kill active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"), { description = "Quit active window and all open instances" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle Fullscreen" })
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle Maximize Window" })
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-allfloat"), { description = "Toggle floating for all windows of workspace" })
hl.bind(mainMod .. " + ALT + T", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
end, { description = "Toggle floating + pinned" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with the mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with the mouse" })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true }, { description = "Increase window width with keyboard" })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true }, { description = "Reduce window width with keyboard" })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true }, { description = "Increase window height with keyboard" })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true }, { description = "Reduce window height with keyboard" })
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"), { description = "Swapsplit" })
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap tiled window left" })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap tiled window right" })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap tiled window up" })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap tiled window down" })

-- Display zoom
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd([[
hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")
]]), { description = "Increase display zoom" })
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd([[
hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")
]]), { description = "Decrease display zoom" })
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"), { description = "Reset display zoom" })

-- Actions
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland configuration" })
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-animations.sh"), { description = "Toggle animations" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"), { description = "Take a screenshot" })
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --instant"), { description = "Take an instant full-screen screenshot" })
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --instant-area"), { description = "Take an instant area screenshot" })
hl.bind(mainMod .. " + ALT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/text-extractor.sh"), { description = "Extract text from an area" })
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("qs ipc call power toggle"), { description = "Start Power Menu" })
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --random"), { description = "Change the wallpaper" })
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app"), { description = "Open wallpaper selector" })
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-automation"), { description = "Start random wallpaper script" })
hl.bind(mainMod .. " + CTRL + RETURN", hl.dsp.exec_cmd("~/.config/hypr/scripts/launcher.sh"), { description = "Open application launcher" })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/keybindings.sh"), { description = "Show keybindings" })
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-reload-statusbar"), { description = "Reload Status Bar" })
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-statusbar"), { description = "Toggle Status Bar" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/loadconfig.sh"), { description = "Reload hyprland config" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-cliphist"), { description = "Open clipboard manager" })
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("~/.config/waybar/themeswitcher.sh"), { description = "Open waybar theme switcher" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-theme"), { description = "Toggle between light and dark mode" })
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("qs ipc call sidebar toggle"), { description = "Open ML4W Sidebar widget" })
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("qs ipc call calendar toggle"), { description = "Open ML4W Calendar widget" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("qs ipc call statusbar focus"), { description = "Expand statusbar and focus it for keyboard navigation" })
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"), { description = "Toggle game mode" })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), { description = "Lock Screen" })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-hyprsunset"), { description = "Toggle Hyprsunset" })
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("qs -p ~/.config/quickshell/overview ipc call overview toggle"), { description = "Open Select Window Menu" })
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("~/.config/ml4w/themes/themes.sh"), { description = "Open Select Window Menu" })

-- Sidepad
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-sidepad"), { description = "Open Sidepad" })
hl.bind(mainMod .. " + CTRL + left", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-sidepad --hide"), { description = "Close Sidepad" })
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-sidepad --init"), { description = "Init Sidepad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-sidepad --select"), { description = "Select Sidepad" })

-- Alt+Tab
hl.bind("ALT + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext"), { description = "Cycle between windows" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd("hyprctl dispatch bringactivetotop"), { description = "Bring active window to the top" })

-- Multimedia and Fn keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 2.5 @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true, description = "Raise volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true, description = "Lower volume" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true, description = "Mute audio" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true, description = "Mute microphone" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true, description = "Increase brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true, description = "Decrease brightness" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Pause audio" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play audio" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Previous track" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh"), { description = "Open calculator" })
hl.bind("XF86Lock", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })
hl.bind("XF86Tools", hl.dsp.exec_cmd("flatpak run com.ml4w.settings"), { description = "Open ML4W Settings app" })
hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"), { description = "Increase keyboard backlight" })
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"), { description = "Decrease keyboard backlight" })