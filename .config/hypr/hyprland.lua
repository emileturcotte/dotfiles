-- Hyprland config — Émile Turcotte
-- https://wiki.hypr.land/Configuring/Start/

----------------
-- MONITORS   --
----------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


----------------
-- PROGRAMS   --
----------------

local terminal    = "alacritty"
local fileManager = "alacritty -e lf"
local menu        = "wofi --show drun"
local mainMod     = "SUPER"


----------------
-- AUTOSTART  --
----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)


-----------------
-- ENVIRONMENT --
-----------------

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")


-------------------
-- LOOK AND FEEL --
-------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(88c0d0ff)", "rgba(81a1c1ff)"}, angle = 45 },
            inactive_border = "rgba(4c566aff)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 6,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,
        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 2,
            color        = 0xaa1a1a2e,
        },
        blur = {
            enabled  = true,
            size     = 6,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },

    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll    = true,
            disable_while_typing = true,
        },
    },
})

hl.curve("easeOut",   { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("overshot",  { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "easeOut" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot" })


------------------
-- KEYBINDINGS  --
------------------

-- Launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + b",      hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + SHIFT + b", hl.dsp.exec_cmd("brave --incognito"))
hl.bind(mainMod .. " + e",      hl.dsp.exec_cmd("emacs"))
hl.bind(mainMod .. " + f",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + v",      hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + t",      hl.dsp.exec_cmd("slack"))

-- Screenshot (grim+slurp = Wayland equivalent of flameshot)
hl.bind(mainMod .. " + s", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("Print",            hl.dsp.exec_cmd("grim - | wl-copy"))

-- Notifications (mako = Wayland equivalent of naughty)
hl.bind("CTRL + space", hl.dsp.exec_cmd("makoctl dismiss -a"))

-- Lock screen
hl.bind(mainMod .. " + CTRL + l", hl.dsp.exec_cmd("slock"))

-- Window management
hl.bind(mainMod .. " + SHIFT + c", hl.dsp.window.close())
hl.bind(mainMod .. " + m",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + n",         hl.dsp.window.move({ workspace = "special:minimized" }))
hl.bind(mainMod .. " + SHIFT + n", hl.dsp.focus({ workspace = "special:minimized" }))
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + o",         hl.dsp.window.move({ monitor = "next" }))
hl.bind(mainMod .. " + p",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.layout("togglesplit"))

-- Focus (vim keys)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Swap windows (vim keys)
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Workspaces (arrow keys = prev/next, numbers = direct)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "e+1" }))

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces with mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),  { locked = true, repeating = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })

-- Reload / Exit
hl.bind(mainMod .. " + CTRL + r",  hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + q", hl.dsp.exit())


------------------
-- WINDOW RULES --
------------------

hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "pavucontrol" },
    float = true,
})

hl.window_rule({
    name  = "float-nm-connection-editor",
    match = { class = "nm-connection-editor" },
    float = true,
})

hl.window_rule({
    name  = "pip",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin   = true,
})
