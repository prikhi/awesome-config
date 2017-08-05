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
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Dropdown Terminal
local drop = require("scratchdrop")
-- Autorun a Command on Login
local r = require("runonce")
-- Layouts and Widgets
local lain = require("lain")
-- Dynamic Tag Management
local tyrannical = require("tyrannical")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Utility Functions
local function append_table(table1, table2)
    for _, v in pairs(table2) do
        table.insert(table1, v)
    end
    return table1
end

local function append_tables(table1, tables)
    for _, v in pairs(tables) do
        append_table(table1, v)
    end
    return table1
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_configuration_dir() .. "themes/molokai/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
-- TODO: Expand to include stuff like mpd host, network interface, etc.

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
}

--- The following Client class lists are used to reduce duplication between the
--- ignore_transparency, tyrannical.tags, & tyrannical.floating lists.

-- Audio Clients
local audio_classes = {
    -- General
      'Cadence.py'
    , 'Catia.py'
    , 'Claudia.py'
    , 'Logs.py'
    , 'Non-Mixer'
    -- Studio
    , 'Ardour'
    , 'Carla2'
    , 'Foxdot'
    , 'Hydrogen'
    , 'Jack-keyboard'
    , 'Jamin'
    , 'Lmms'
    , 'Non-Sequencer'
    , 'Non-Timeline'
    , 'Zynaddsubfx'
    , 'scide'
}
-- Game Clients
local game_classes = {
      'Civ5XP'
    , 'DefendersQuest'
    , 'Dolphin-emu'
    , 'FrozenSynapse'
    , 'KOTOR2'
    , 'Mainwindow.py' -- PlayOnLinux
    , 'Pcsx2'
    , 'Psychonauts'
    , 'RogueCastle.bin.x86_64'
    , 'Steam'
    , 'Torchlight2.bin.x86_64'
    , 'Wine'
    , 'X3TC_main'
    , 'csgo_linux'
    , 'dota_linux'
    , 'eu4'
    , 'hoi4'
    , 'ns2_linux32'
    , 'stellaris'
    , 'superhexagon.x86_64'
}
-- Media Clients
local media_classes = {
      'Mcomix'
    , 'Mirage'
    , 'Vlc'
    , 'Zathura'
    , 'feh'
    , 'mpv'
}
-- Graphics Clients
local graphics_classes = {
      'Gimp'
    , 'Inkscape'
    , 'Pencil'
}

-- Classes of Clients to Make Opaque
local ignore_transparency_classes = append_tables(
    { }, { audio_classes, game_classes, media_classes, graphics_classes })
-- Instance Names of Clients to Make Opaque
local ignore_transparency_names = {
    -- Apps
      'libreoffice'
    -- Games
    , 'PlayOnLinux'
    , 'Minecraft 1.7.2'
}

-- Commnds to Run on Shutdown
local shutdown_commands = function()
    --awful.spawn({"mpd", "--kill"})
    awful.spawn({"pkill", "keepassx"})
    awful.spawn({"rm", "-f", "pavans_passwords.kdb.lock"})
    awesome.quit()
end
-- }}}

-- {{{ Tags
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
        screen = {1,2,3},
        selected = true,
    },
    {
        name = "www",
        init = true,
        exclusive = true,
        no_focus_stealing = true,
        screen = {1,2,3},
        class = {"Chromium", "Firefox", "Pale moon"},
    },
    {
        name = "code",
        init = true,
        layout = awful.layout.tile,
        mwfact = 0.55,
        screen = {1, 2, 3},
    },
    {
        name = "chat",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        no_focus_stealing = true,
        screen = {1, 2, 3},
        class = {"Mumble", "Pidgin"},
        volatile = true,
    },
    {
        name = "media",
        init = false,
        exclusive = true,
        screen = {1,2,3},
        class = media_classes,
        volatile = true,
    },
    {
        name = "draw",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        screen = {1},
        class = graphics_classes,
        volatile = true,
    },
    {
        name = "office",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        screen = {1},
        class = {
            "libreoffice-calc", "libreoffice-draw", "libreoffice-writer",
            "libreoffice", "soffice", "libreoffice-startcenter"
        },
        volatile = true,
    },
    {
        name = "game",
        init = false,
        layout = awful.layout.suit.floating,
        exclusive = true,
        screen = {1},
        class = game_classes,
        volatile = true,
    },
    {
        name = "audio",
        init = false,
        layout = awful.layout.suit.floating,
        screen = {1, 2, 3},
        class = audio_classes,
        volatile = true,
    },
    {
        name = "vm",
        init = false,
        layout = awful.layout.suit.floating,
        screen = {1,2,3},
        class = { "VirtualBox", "virt-manager" },
        volatile = true,
    }
}
tyrannical.properties.intrusive = {
    "feh", "URxvt", "pinentry", "Keepassx", "Gvim", "Steam", "Bitcoin-Qt"
}
tyrannical.properties.floating = append_tables({
    "Mumble", "Steam", "VirtualBox", "Mumble", "gimp", "Wine", "pinentry",
    "keepassx", "pidgin", "Bitcon-Qt", "soffice", "Dialog"
}, { audio_classes, graphics_classes })
tyrannical.properties.size_hints_honor = {
    URxvt = false, mpv = false, Gvim = false
}
tyrannical.properties.placement = {
    keepassx = awful.placement.centered,
    pinentry = awful.placement.centered,
    virtualbox = awful.placement.centered,
}
-- }}}

-- {{{ Callback Functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- Set a Client to Opaque if Listed in Ignore Tables
local function ignore_transparency(c)
    for _, ignore_class in ipairs(ignore_transparency_classes) do
        if c.class == ignore_class then
            c.opacity = 1
            return
        end
    end
    for _, ignore_name in ipairs(ignore_transparency_names) do
        if c.name == ignore_name then
            c.opacity = 1
            return
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Colors
local markup = lain.util.markup
bg = "#1a1a1a"
alt_bg = "#313131"

-- Clock
clockicon = wibox.widget.imagebox(theme.widget_clock)
clockwidget = wibox.widget.textclock(
    markup.fg.color(theme.green, " %a %d %b %H:%M")
)

-- MPD
mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdiconbg = wibox.container.background(mpdicon, alt_bg)
mpdwidget = lain.widgets.mpd({
    music_dir = "~/Media/Music",
    host = "127.0.0.1",
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
mpdwidgetbg = wibox.container.background(mpdwidget, alt_bg)

-- CPU
cpuicon = wibox.widget.imagebox(theme.widget_cpu)
cpuwidget = wibox.container.background(lain.widgets.cpu({
    fg = theme.white,
    settings = function()
        widget:set_markup(markup.fg.color(theme.white,
            " " .. cpu_now.usage .. "% "))
    end
}), bg)

-- Network
neticon = wibox.widget.imagebox(theme.widget_net)
neticonbg = wibox.container.background(neticon, alt_bg)
netwidget = wibox.container.background(lain.widgets.net({
    iface = "enp3s0",
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
arrl = wibox.widget.imagebox(beautiful.arrl)
arrl_dl = wibox.widget.imagebox(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox(beautiful.arrl_ld)


-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, client_menu_toggle_fn()),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            arrl,
            arrl_ld,
            mpdiconbg,
            mpdwidgetbg,
            arrl_dl,
            cpuicon,
            cpuwidget,
            arrl_ld,
            neticonbg,
            netwidget,
            arrl_dl,
            spr,
            wibox.widget.systray(),
            clockwidget,
            spr,
            arrl,
            spr,
            s.mylayoutbox,
        },
    }
end)
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
    awful.key({ modkey, "Control" }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, ";", awful.tag.history.restore,
              {description = "go back", group = "tag"}),


    -- Client Selection
    awful.key({ modkey,           }, "j",
        function()
            awful.client.focus.bydirection("down")
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function()
            awful.client.focus.bydirection("up")
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key({ modkey,           }, "h",
        function()
            awful.client.focus.bydirection("left")
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key({ modkey,           }, "l",
        function()
            awful.client.focus.bydirection("right")
        end,
        {description = "focus right", group = "client"}
    ),
    awful.key({ modkey,           }, "s",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "d",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", shutdown_commands,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "u",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "i",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",
        function ()
            awful.screen.focused().mypromptbox:run({ text = theme.white })
        end,
        {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "w", function() mymainmenu:show() end,
              {description = "show the menu", group = "launcher"}),


    -- Toggle ncmpcpp dropdown
    awful.key({ modkey,	          }, "z", function () drop(terminal .. " -e ncmpcpp") end,
              {description = "open/close browser", group = "mpd"}),
    -- MPD Controls
    awful.key({ modkey, "Shift"   }, ",",
              function () awful.spawn.with_shell("mpc prev"); mpdwidget.update() end,
              {description = "previous track", group = "mpd"}),
    awful.key({ modkey, "Shift"   }, ".",
              function () awful.spawn.with_shell("mpc next"); mpdwidget.update() end,
              {description = "next track", group = "mpd"}),
    awful.key({ modkey, "Shift"   }, "p",
              function () awful.spawn.with_shell("mpc toggle"); mpdwidget.update() end,
              {description = "toggle playback", group = "mpd"}),

    -- Toggle Workrave
    awful.key({ modkey,           }, "F11",
              function () awful.spawn.with_shell("pkill workrave || workrave &") end,
              {description = "toggle RSI prevention", group = "apps"}),
    -- Toggle Compositing
    awful.key({ modkey,           }, "F12",
              function () awful.spawn.with_shell("pkill compton || compton -b") end,
              {description = "toggle compositing", group = "apps"}),

    -- Remove Notifications
    awful.key({ modkey, "Shift"   }, "w", function () destroy_one_notification() end,
              {description = "clear a notification", group = "awesome"}),
    awful.key({ modkey, "Control" }, "w", function () destroy_all_notifications() end,
              {description = "clear all notifications", group = "awesome"}),

    -- Tag Management
    awful.key({ modkey, "Shift"   }, "d",
              function ()
                  local tag = awful.screen.focused().selected_tag
                  if not tag then return end
                  tag:delete()
              end,
              {description = "delete tag", group = "tag"}),
    awful.key({ modkey,           }, "a",
              function ()
                awful.prompt.run {
                    prompt = "New tag name: ",
                    textbox = awful.screen.focused().mypromptbox.widget,
                    exe_callback = function(new_tag)
                        if not new_tag or #new_tag == 0 then
                            return
                        else
                            awful.tag.add(new_tag,{screen= awful.screen.focused() }):view_only()
                        end
                    end,
                }
              end,
              {description = "add tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "a",
              function ()
                awful.prompt.run {
                    prompt = "New tag name: ",
                    textbox = awful.screen.focused().mypromptbox.widget,
                    exe_callback = function(new_name)
                        if not new_name or #new_name == 0 then
                            return
                        else
                            local tag = awful.screen.focused().selected_tag
                            if tag then
                                tag.name = new_name
                            end
                        end
                    end,
                }
              end,
              {description = "rename tag", group = "tag"})

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "BackSpace", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "i",      function (c) c:move_to_screen()               end,
              {description = "move to next screen", group = "client"}),
    awful.key({ modkey,           }, "o",
              function (c)
                  c:move_to_screen((awful.screen.focused().index - 1) % 3)
              end,
              {description = "move to previous screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n", function (c) c.minimized = true end,
              {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

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
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    if not awesome.startup then
        awful.client.setslave(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- No border for maximized clients, opaque focus window
client.connect_signal("focus",
    function(c)
        if c.maximized then
            c.border_color = theme.border_normal
        else
            c.border_color = theme.border_focus
        end
        c.opacity = .98
        ignore_transparency(c)
    end)
client.connect_signal("unfocus",
    function(c)
        c.border_color = theme.border_normal
        c.opacity = .96
        ignore_transparency(c)
    end)
-- }}}

-- {{{ Notifications
-- Notifications should pop up in the upper left.
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
    for s in screen do
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

-- Remove old mounted folders
r.run("udevil clean")

-- Terminal Daemon
r.run("urxvtd -f -o -q")
-- Jackd Audio Server
r.run("cadence-session-start --system-start")
-- Music Player Daemon
--r.run("mpd") -- commented out for systemctl --user enable mpd
-- Hide the Mouse
r.run("unclutter -idle 2 -noevents")
-- Transparency/Composting
r.run("compton -b")

-- Email Notifications
r.run("~/.bin/mailcheck.sh")
-- RSI Prevention
r.run("workrave")
-- Eye Strain Prevention
r.run("systemctl --user start redshift")
-- KeePassX Password Manager
r.run("keepassx -min -lock")
-- Email Screen Session
r.run("bash /home/prikhi/.bin/start_split")

-- LAN Chat
r.run("mumble")
-- WAN Chat
r.run("pidgin")
-- Jack Studio GUI
r.run("claudia")
-- Web Browser
r.run("palemoon")

-- }}}
