-- -----------------------------------------------------
-- Window rules
-- -----------------------------------------------------

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
-- when moving objects in resolve a large border is produced
-- This rule prevents that and serves as a template for any problematic xwayland apps
hl.window_rule({
    name = "windowrule-10",
    match = {
        class = "^(\\bresolve\\b)$",
        xwayland = true
    },
    no_blur = true
})

-- This is a general rule for xwayland apps but can have other consequences
-- for one user it impacted EMACs so it's disabled by default
-- It's here as a reference or for quick triage of xwayland apps
-- hl.window_rule({
--     name = "noblur-xwayland",
--     match = { xwayland = true },
--     no_blur = true
-- })