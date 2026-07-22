hl.window_rule({
    name = "windowrule-1",
    match = { title = "^(Microsoft-edge)$" },
    tile = true
})

hl.window_rule({
    name = "windowrule-2",
    match = { title = "^(Brave-browser)$" },
    tile = true
})

hl.window_rule({
    name = "windowrule-3",
    match = { title = "^(Chromium)$" },
    tile = true
})

hl.window_rule({
    name = "windowrule-4",
    match = { title = "^(pavucontrol)$" },
    float = true
})

hl.window_rule({
    name = "windowrule-5",
    match = { title = "^(blueman-manager)$" },
    float = true
})

hl.window_rule({
    name = "windowrule-6",
    match = { title = "^(nm-connection-editor)$" },
    float = true
})

hl.window_rule({
    name = "windowrule-7",
    match = { title = "^(qalculate-gtk)$" },
    float = true
})

-- Browser Picture in Picture
hl.window_rule({
    name = "windowrule-8",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    move = "((monitor_w*0.695)) ((monitor_h*0.04))"
})

-- idleinhibit
hl.window_rule({
    name = "windowrule-9",
    match = { class = "([window])" },
    idle_inhibit = "fullscreen",
    fullscreen = true
})

-- xwayland related rules
hl.window_rule({
    name = "windowrule-10",
    match = {
        class = "^(\\bresolve\\b)$",
        xwayland = true
    },
    no_blur = true
})

hl.window_rule({
    name = "windowrule-11",
    match = { initial_title = "(UnityEditor.AddComponent.AddComponentWindow)" },
    min_size = "230 200"
})

hl.window_rule({
    name = "windowrule-12",
    match = { initial_title = "(UnityEditor.IMGUI.Controls.AdvancedDropdownWindow)" },
    min_size = "300 200"
})

hl.window_rule({
    name = "windowrule-13",
    match = { initial_title = "(UnityEditor.Rendering.FilterWindow)" },
    min_size = "230 200"
})

hl.window_rule({
    name = "windowrule-14",
    match = { initial_title = "(UnityEditor.LayerVisibilityWindow)" },
    min_size = "300 200"
})

hl.window_rule({
    name = "windowrule-15",
    match = { initial_title = "(UnityEditor.AnnotationWindow)" },
    min_size = "230 500"
})

hl.window_rule({
    name = "windowrule-16",
    match = { initial_title = "(UnityEditor.PopupWindow)" },
    min_size = "150 300"
})

hl.window_rule({
    name = "windowrule-17",
    match = { initial_title = "(Select Preset...)" },
    min_size = "500 350"
})

hl.window_rule({
    name = "windowrule-18",
    match = { initial_title = "(UnityEditor.Snap.GridSettingsWindow)" },
    min_size = "300 100"
})

hl.window_rule({
    name = "windowrule-19",
    match = { initial_title = "(UnityEngine.InputSystem.Editor.AdvancedDropdownWindow)" },
    min_size = "500 500"
})