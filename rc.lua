--[[--

    This is Pavan's AwesomeWM Configuration.

    It was originally started from copycatkiller's powerarrow-darker
    configuration and theme, but has been heavily modified.

    It uses:

        * lain - additional layouts and widgets
        * scratchdrop - dropdown ncmpcpp terminal
        * runonce - only start apps on awesome startup instead of also when
          restarting awesome.
        * tyrannical - dynamic tags

]]
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Dropdown Terminal
local drop = require("scratchdrop")
-- Layouts and Widgets
local lain = require("lain")
-- Autorun a Command On Your First Login
local r = require("runonce")
-- Tag Management
local tyrannical = require("tyrannical")

-- {{{ Error handling
-- Add a signal for runtime errors.
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Localization
os.setlocale(os.getenv("LANG"))

-- Load Custom Theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/molokai/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Applications
iftop       = terminal .. " -g 180x54-20+34 -e sudo iftop"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating,
}

-- Classes of Clients to Make Opaque
local ignore_transparency_classes = {
                              -- Media
                                'Smplayer'
                              , 'Mcomix'
                              , 'Mirage'
                              , 'Vlc'
                              , 'mpv'
                              -- Audio
                              , "Jack_mixer"
                              , "Jamin"
                              , "Logs.py"
                              , "Claudia.py"
                              , "Catia.py"
                              , "Cadence.py"
                              -- Drawing
                              , "Gimp"
                              , "Pencil"
                              , "Pinta"
                              -- Games
                              , 'Pcsx2'
                              , 'Dolphin-emu'
                              , 'Civ5XP'
                              , 'DefendersQuest'
                              , 'FrozenSynapse'
                              , 'Psychonauts'
                              , 'RogueCastle.bin.x86_64'
                              , 'Wine'
                              , 'X3TC_main'
                              , 'dota_linux'
                              , 'csgo_linux'
                              , 'ns2_linux32'
                              , 'superhexagon.x86_64'
                              , 'Torchlight2.bin.x86_64'
                              }
-- Names of Clients to Make Opaque
local ignore_transparency_names = {
                            -- Games
                              'Guild Wars 2'
                            , 'Minecraft 1.7.2'
                            , 'Binding of Isaac: Rebirth v1.0'
                            }
-- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tyrannical.settings.default_layout = awful.layout.suit.tile
tyrannical.settings.mwfact  = 0.66
tyrannical.settings.group_children = true
tyrannical.settings.block_children_focus_stealing = true
tyrannical.tags = {
    {
        name = "term",
        init = true,
        layout = awful.layout.tile,
        mwfact = 0.55,
        screen = {1,2},
    },
    {
        name = "www",
        init = true,
        exclusive = true,
        no_focus_stealing = true,
        screen = {1,2},
        class = {"Chromium", "Firefox"},
    },
    {
        name = "code",
        init = true,
        layout = awful.layout.tile,
        mwfact = 0.55,
        screen = {1, 2},
    },
    {
        name = "chat",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        no_focus_stealing = true,
        screen = {1, 2},
        class = {"Skype", "Mumble", "Pidgin"},
        volatile = true,
    },
    {
        name = "media",
        init = false,
        exclusive = true,
        screen = {1,2},
        class = {
            "Smplayer", "Vlc", "mpv", "Mirage", "Mcomix", "Zathura", "feh"
        },
        volatile = true,
    },
    {
        name = "draw",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        screen = {1},
        class = {"Gimp", "Pencil",},
        volatile = true,
    },
    {
        name = "game",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        screen = {1},
        class = {
              'Civ5XP'
            , 'DefendersQuest'
            , 'FrozenSynapse'
            , 'Psychonauts'
            , 'RogueCastle.bin.x86_64'
            , 'Wine'
            , 'X3TC_main'
            , 'csgo_linux'
            , 'dota_linux'
            , 'ns2_linux32'
            , 'superhexagon.x86_64'
            , 'Pcsx2'
            , 'Dolphin-emu'
            , 'Torchlight2.bin.x86_64'
        },
        volatile = true,
    },
    {
        name = "audio",
        init = false,
        layout = awful.layout.suit.floating,
        screen = {1, 2},
        class = {
              "Jack_mixer"
            , "Jamin"
            , "Logs.py"
            , "Claudia.py"
            , "Catia.py"
            , "Cadence.py"
        },
        volatile = true,
    },
    {
        name = "vm",
        init = false,
        layout = awful.layout.suit.floating,
        screen = {1,2},
        class = {"VirtualBox"},
        volatile = true,
    }
}
tyrannical.properties.intrusive = {
    "feh", "URxvt", "pinentry", "Keepassx", "Pavucontrol", "Gvim", "Steam"
}
tyrannical.properties.floating = {
    "Mumble", "Steam", "Guild Wars 2", "VirtualBox", "Skype", "Mumble", "gimp",
    "Wine", "pinentry", "Keepassx", "Pidgin", "Pavucontrol"
}
tyrannical.properties.size_hints_honor = {
    xterm = false, URxvt = false, mpv = false, Gvim = false
}
-- }}}


-- {{{ Menu
require("freedesktop/freedesktop")

--- }}}


-- {{{ Widgets
markup = lain.util.markup

-- Colours
-- TODO: strip background colors from theme icons so we are not tied to these
-- colors inherited from powerarrow-darker.
bg = '#1a1a1a'
alt_bg = '#313131'

-- Textclock widget
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(
    markup.fg.color(theme.green, " %a %d %b %H:%M")
)

-- Calendar attached to the textclock, along with next Remind tasks
lain.widgets.calendar:attach(mytextclock, { font_size = 8
                                          , fg = theme.notify_fg
                                          , bg = theme.notify_bg
                                          , cal = "calrem"
                                          , position = "top_left" })

---- MPD
mpdicon = wibox.widget.imagebox(beautiful.widget_music)
mpdiconbg = wibox.widget.background(mpdicon, alt_bg)
mpdwidget = lain.widgets.mpd({
    music_dir = "~/Media/Music",
    settings = function()
        if mpd_now.state == "play" then
            widget:set_markup(
                " " ..
                markup.fg.color(theme.orange, mpd_now.title) ..
                markup.fg.color(theme.white, " - ") ..
                markup.fg.color(theme.cyan, mpd_now.artist) ..
                " "
            )
            mpdicon:set_image(beautiful.widget_music_on)
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.fg.color(theme.orange, " mpd paused "))
            mpdicon:set_image(beautiful.widget_music)
        else
            widget:set_markup(markup.fg.color(theme.magenta, " mpd stopped "))
            mpdicon:set_image(beautiful.widget_music)
        end
    end
})
-- Separate the two because we still want to call update on the lain widget.
mpdwidgetbg = wibox.widget.background(mpdwidget, alt_bg)

-- CPU widget
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = wibox.widget.background(lain.widgets.cpu({
    fg = theme.white,
    settings = function()
        widget:set_markup(markup.fg.color(theme.white,
             " " .. cpu_now.usage .. "% "))
    end
}), bg)

-- Net widget
neticon = wibox.widget.imagebox(beautiful.widget_net)
neticonbg = wibox.widget.background(neticon, alt_bg)
netwidget = wibox.widget.background(lain.widgets.net({
    iface = "eth0",
    settings = function()
        widget:set_markup(
            markup.bg.color(alt_bg,
                markup(theme.cyan, " " .. net_now.received)
                .. " " ..
                markup(theme.green, " " .. net_now.sent .. " ")
            )
        )
    end
}), alt_bg)


-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

-- }}}

-- {{{ Taskbars
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4,
                        function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5,
                        function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                        if c == client.focus then
                            c.minimized = true
                        else
                            -- Without this, the following :isvisible() makes
                            -- no sense
                            c.minimized = false
                            if not c:isvisible() then
                                awful.tag.viewonly(c:tags()[1])
                            end
                            -- This will also un-minimize the client, if needed
                            client.focus = c
                            c:raise()
                        end
                     end),
                     awful.button({ }, 3, function ()
                         if instance then
                             instance:hide()
                             instance = nil
                         else
                             instance = awful.menu.clients({ width=250 })
                         end
                     end),
                     awful.button({ }, 4, function ()
                         awful.client.focus.byidx(1)
                         if client.focus then client.focus:raise() end
                     end),
                     awful.button({ }, 5, function ()
                         awful.client.focus.byidx(-1)
                         if client.focus then client.focus:raise() end
                     end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spr)
    right_layout:add(arrl)
    right_layout:add(arrl_ld)
    right_layout:add(mpdiconbg)
    right_layout:add(mpdwidgetbg)
    right_layout:add(arrl_dl)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(arrl_ld)
    right_layout:add(neticonbg)
    right_layout:add(netwidget)
    right_layout:add(arrl_dl)
    if s == 1 then
        right_layout:add(wibox.widget.systray())
    end
    right_layout:add(mytextclock)
    right_layout:add(spr)
    right_layout:add(arrl_ld)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev           ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext           ),

    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run({ text = theme.white }) end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- {{{ Custom Keybindings
    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Rebind default client focus
    awful.key({ modkey }, "s",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "d",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Hibernate
    awful.key({ modkey, "Shift", "Control" }, "Escape",
            function () awful.util.spawn_with_shell("systemctl hibernate") end),

    -- Tag Quick Switch
    awful.key({ modkey,         }, ";", awful.tag.history.restore),

    -- Change Master Window Count
    awful.key({ modkey, "Shift" }, "u", function () awful.tag.incnmaster( 1) end),
    awful.key({ modkey, "Shift" }, "i", function () awful.tag.incnmaster(-1) end),

    -- Dropdown ncmpcpp
    awful.key({ modkey,	        }, "z", function () drop(terminal .. " -e ncmpcpp") end),

    -- Widgets popups
    awful.key({ modkey,         }, "c", function () lain.widgets.calendar:show(15) end),

    -- MPD Controls prev/next/toggle
    awful.key({ modkey, "Shift" }, ",",
            function () awful.util.spawn_with_shell("mpc -h /tmp/mpd.sock prev"); mpdwidget.update() end),
    awful.key({ modkey, "Shift" }, ".",
            function () awful.util.spawn_with_shell("mpc -h /tmp/mpd.sock next"); mpdwidget.update() end),
    awful.key({ modkey, "Shift" }, "p",
            function () awful.util.spawn_with_shell("mpc -h /tmp/mpd.sock toggle"); mpdwidget.update() end),

    -- Remove one notification
    awful.key({ modkey, "Shift" }, "w", function () destroy_one_notification() end),
    -- Remove all notifications
    awful.key({ modkey, "Control" }, "w", function () destroy_all_notifications() end),

    -- Add a tag
    awful.key({ modkey,           }, "a",
        function ()
            awful.prompt.run(
              { prompt = "New tag name: " },
              mypromptbox[mouse.screen].widget,
              function(new_name)
                  if not new_name or #new_name == 0 then
                      return
                  else
                      props = {selected = true}
                      if tyrannical.tags_by_name[new_name] then
                         props = tyrannical.tags_by_name[new_name]
                      end
                      t = awful.tag.add(new_name, props)
                      awful.tag.viewonly(t)
                  end
              end
              )
        end),

    -- Delete the Current Tab
    awful.key({ modkey, "Shift"   }, "d", function () awful.tag.delete() end),

    -- Rename the Current Tab
    awful.key({ modkey, "Shift"   }, "a",
        function ()
            awful.prompt.run(
                { prompt = "New tag name: " },
                mypromptbox[mouse.screen].widget,
                function(new_name)
                    if not new_name or #new_name == 0 then
                        return
                    else
                        local screen = mouse.screen
                        local tag = awful.tag.selected(screen)
                        if tag then
                            tag.name = new_name
                        end
                    end
                end
            )
        end
    )
    --- Custom Keys }}}
)


clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey,           }, "BackSpace", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "f", function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey,           }, "o", awful.client.movetoscreen),
    awful.key({ modkey,           }, "t", function (c) c.ontop = not c.ontop end),
    awful.key({ modkey,           }, "n", function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Tyrannical-specific Tag Selection
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                        if client.focus then
                            local tag = awful.tag.gettags(client.focus.screen)[i]
                            if tag then
                                awful.client.movetotag(tag)
                            end
                        end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                        if client.focus then
                            local tag = awful.tag.gettags(client.focus.screen)[i]
                            if tag then
                                awful.client.toggletag(tag)
                            end
                        end
                  end))
end
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Client Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     floating = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true, opacity = 1 } },
    { rule = { name = "Minecraft 1.7.2" },
      properties = { opacity = 1 } },
    { rule = { class = "Smplayer" },
      properties = { opacity = 1 }},
    { rule = { class = "Vlc" },
      properties = { opacity = 1 }},
    { rule = { class = "mpv" },
      properties = { opacity = 1 }},
    { rule = { class = "Mcomix" },
      properties = { opacity = 1 } },
    { rule = { class = "X3TC_main" },
      properties = { opacity = 1 } },
    { rule = { class = "ns2_linux32" },
      properties = { opacity = 1 } },
    { rule = { class = "dota_linux" },
      properties = { floating = true,
                     opacity = 1 } },
    { rule = { class = "Wine" },
      properties = { opacity = 1 } },
    { rule = { class = "Plugin-container" },
      properties = { opacity = 1 } },
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they do not set an initial position.
        if not c.size_hints.user_position and
           not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- Set a Client to Opaque if Listed
local function ignore_transparency(c)
    for _, ignore_class in ipairs(ignore_transparency_classes) do
        if c.class == ignore_class then
            c.opacity = 1
        end
    end
    for _, ignore_name in ipairs(ignore_transparency_names) do
        if c.name == ignore_name then
            c.opacity = 1
        end
    end

end

-- No border for maximized clients, opaque focus window
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
        c.opacity = .92
        ignore_transparency(c)
    end
)
client.connect_signal("unfocus",
    function(c)
        c.border_color = beautiful.border_normal
        c.opacity = .82
        ignore_transparency(c)
    end
)
-- }}}


-- {{{ Notifications
-- Notifications should pop up in the upper right, my primary screen is on the
-- right.
naughty.config.defaults.position = "top_left"

-- Notifications should require manual closing, who knows how long I am afk.
naughty.config.defaults.timeout = 0

-- Set a nice default icon, pidgin required.
naughty.config.defaults.icon = "pidgin/buttons/info"

-- Use the theme's notification colors
naughty.config.defaults.fg = theme.notify_fg
naughty.config.defaults.bg = theme.notify_bg
naughty.config.defaults.border_color = theme.notify_border

--- Remove all notifications
function destroy_all_notifications()
    result = destroy_one_notification()
    while result do
        result = destroy_one_notification()
    end
end

--- Remove one notification
function destroy_one_notification()
    for s = 1, screen.count() do
        for p, _ in pairs(naughty.notifications[s]) do
            for _, n in ipairs(naughty.notifications[s][p]) do
                naughty.destroy(n)
                return true
            end
        end
    end
    return false
end

-- }}}


-- {{{ Autostart Applications
r.run("firefox")

-- Terminal Daemon
r.run("urxvtd -f -o -q")
-- Start the PulseAudio SysTray
r.run("pasystray")
-- Remove old mounted folders
r.run("udevil clean")
-- Hide the Mouse
r.run("unclutter -idle 2")
-- Start RSI Prevention Program
r.run("workrave")
-- Autostart Email Screen Session
r.run("bash /home/prikhi/.bin/start_split")

-- LAN Chat
r.run("mumble")
-- WAN Chat
r.run("pidgin")
-- KeePassX Password Manager
r.run("keepassx -min -lock")

-- Enable Transparency/Composting
r.run("compton -b")
-- }}}
