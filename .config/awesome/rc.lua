--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")
local mytable       = awful.util.table or gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ 
	"picom --experimental-backends --config ~/.config/picom/picom.conf",
	"emacs --daemon",
	"flameshot",
	"nm-applet",
	"xautolock -time 5 -locker slock -nowlocker slock -detectsleep",
	"caffeine",
	"bluetoothctl scan on",
	"dunst"

}) -- comma-separated entries

-- }}}

-- {{{ Variable definitions

local themes = {
    "nord"
}

local chosen_theme = themes[1]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "alacritty"
local vi_focus     = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "vim"
local visual       = os.getenv("VISUAL") or "emacs"
local browser      = "brave"
local scrlocker    = "slock"

awful.util.terminal = terminal
awful.util.tagnames = { "web", "term", "code", "media", "files", "vm" }
awful.layout.layouts = {
    awful.layout.suit.tile,
}

awful.util.taglist_buttons = mytable.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = mytable.join(
     awful.button({ }, 1, function(c)
         if c == client.focus then
             c.minimized = true
         else
             c:emit_signal("request::activate", "tasklist", { raise = true })
         end
     end),
     awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

local themedir = string.format("%s/.config/awesome/themes/%s", os.getenv("HOME"), chosen_theme)
beautiful.init(themedir .. "/theme.lua")

-- Set random wallpaper (https://gist.github.com/anonymous/9072154f03247ab6e28c)
-- {{{ Function definitions

-- scan directory, and optionally filter outputs
function scandir(directory, filter)
    local i, t, popen = 0, {}, io.popen
    if not filter then
        filter = function(s) return true end
    end
    print(filter)
    for filename in popen('ls -a "'..directory..'"'):lines() do
        if filter(filename) then
            i = i + 1
            t[i] = filename
        end
    end
    return t
end

-- }}}

wp_path = themedir .. "/wallpapers/"
wp_filter = function(s) return string.match(s,"%.png$") or string.match(s,"%.jpg$") end
wp_files = scandir(wp_path, wp_filter)

-- Select random wallpaper
math.randomseed(os.time())
wp_index = math.random(1, #wp_files)
beautiful.wallpaper = wp_path .. wp_files[wp_index]

-- Set wallpaper to current index for all screens
for s = 1, screen.count() do
  gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", string.format("%s -e man awesome", terminal) },
   { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- }}}

-- {{{ Screen

-- Set client border
screen.connect_signal("arrange", function (s)
    for _, c in pairs(s.clients) do
	if c.maximized or c.fullscreen then
  	    c.border_width = 0
	else
	    c.border_width = beautiful.border_width
	end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) 
    beautiful.at_screen_connect(s) 
end)

-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = mytable.join(

    --    AWESOME
    awful.key({ modkey }, "F1", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),


    --	  LAUNCHER
    awful.key({ modkey }, "space", 
    	      function ()
              	  os.execute(string.format("dmenu_run -i -fn '%s' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
                  beautiful.font, beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
              end,
              {description = "show dmenu", group = "launcher"}), 
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
              {description = "launch terminal", group = "launcher"}),
    awful.key({ modkey }, "b", function () awful.spawn(browser) end,
              {description = "launch browser", group = "launcher"}),
    awful.key({ modkey }, "e", function () awful.spawn(visual) end,
    	      {description = "launch editor", group = "launcher"}),
    awful.key({ modkey }, "f", function () awful.spawn("pcmanfm") end,
    	      {description = "launch file manager", group = "launcher"}),
    awful.key({ modkey }, "v", function () awful.spawn("pavucontrol") end,
    	      {description = "launch volume mixer", group = "launcher"}),
    awful.key({ modkey }, "t", function () awful.spawn("teams") end,
    	      {description = "launch teams", group = "launcher"}),


    --    HOTKEYS
    awful.key({ "Control",           }, "space", function() naughty.destroy_all_notifications() end,
              {description = "destroy all notifications", group = "hotkeys"}),
    awful.key({ modkey, altkey }, "l", function () os.execute(scrlocker) end,
              {description = "lock screen", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
              {description = "-10%", group = "hotkeys"}),
    awful.key({ modkey, }, "s", 
    	      function ()
	    	  awful.spawn.with_shell("flameshot gui -c")
    	      end,
    	      {description = "take screenshot", group = "hotkeys"}),


    --    TAGS
    awful.key({ modkey }, "Left", function() 
	    for s in screen do 
		awful.tag.viewprev(s) 
	    end
	end,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey }, "Right", function() 
	    for s in screen do
		awful.tag.viewnext(s)
	    end
	end,
              {description = "view next", group = "tag"}),

	   
    --    CLIENT
    awful.key({ modkey }, "j", 
	          function()
            	      awful.client.focus.global_bydirection("down")
            	      if client.focus then client.focus:raise() end
        	  end,
              {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k", 
    		  function()
            	      awful.client.focus.global_bydirection("up")
            	      if client.focus then client.focus:raise() end
        	  end,
              {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h", 
    		  function()
            	      awful.client.focus.global_bydirection("left")
            	      if client.focus then client.focus:raise() end
        	  end,
              {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l", 
    	          function()
            	       awful.client.focus.global_bydirection("right")
            	       if client.focus then client.focus:raise() end
        	  end,
              {description = "focus right", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", 
	          function()
            	      awful.client.swap.global_bydirection("down")
        	  end,
              {description = "swap down", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", 
    		  function()
            	      awful.client.swap.global_bydirection("up")
        	  end,
              {description = "swap up", group = "client"}),
    awful.key({ modkey, "Shift" }, "h", 
    		  function()
            	      awful.client.swap.global_bydirection("left")
        	  end,
              {description = "swap left", group = "client"}),
    awful.key({ modkey, "Shift" }, "l", 
    	          function()
            	       awful.client.swap.global_bydirection("right")
        	  end,
              {description = "swap right", group = "client"}),
    awful.key({ modkey, "Control" }, "n", 
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end, 
	      {description = "restore minimized", group = "client"}),


    --    SCREEN
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"})


    --    LAYOUT


    --    WIDGETS
)

clientkeys = mytable.join(
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey }, "o", function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey }, "n", function (c) c.minimized = true end,
              {description = "minimize", group = "client"}),
    awful.key({ modkey }, "m",
                  function (c)
                      c.maximized = not c.maximized
                      c:raise()
                  end,
              {description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = mytable.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                      for s in screen do
		          local tag = s.tags[i]
                          if tag then
                              tag:view_only()
                          end
		      end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      for s in screen do
		          local tag = s.tags[i]
			  if tag then
			      awful.tag.viewtoggle(tag)
			  end
		      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = mytable.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.focused,
                     placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"
  	},
        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)
 
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}


