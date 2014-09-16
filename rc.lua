-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
require("html")
-- Copycat
local scratch = require("scratch")
local menubar = require("menubar")
-- Autorun a Command On Your First Login
local r = require("runonce")
-- Tag Management
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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/home/prikhi/.config/awesome/themes/orange/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
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
        screen = {1,2},
        exec_once = {"urxvtc -name shell -e screen -p Zsh -x split"},
    },
    {
        name = "www",
        init = true,
        exclusive = true,
        no_focus_stealing = true,
        screen = {1,2},
        class = {
            "Chromium", "Firefox"
        },
    },
    {
        name = "code",
        init = true,
        layout = awful.layout.suit.tile.bottom,
        mwfact = 0.70,
        screen = {1},
        exec_once = {"urxvtc -name work_vim -e screen -x work -p vim"}
    },
    {
        name = "work",
        init = true,
        screen = {2},
        exec_once = {"urxvtc -name work -e screen -x work -p 2"}
    },
    {
        name = "irc",
        init = true,
        exclusive = true,
        screen = {2},
        instance = {"irc"},
        exec_once = {"urxvtc -name irc -e screen -x irc"}
    },
    {
        name = "chat",
        init = true,
        screen = {1},
        exclusive = true,
        no_focus_stealing = true,
        class = {"Skype", "Mumble", "Pidgin"},
        volatile = true,
    },
    {
        name = "media",
        screen = {1,2},
        init = false,
        exclusive = true,
        class = {
            "Smplayer", "Vlc", "mpv", "Mirage", "Mcomix", "Zathura", "feh"
        },
        volatile = true,
    },
    {
        name = "vm",
        screen = {1,2},
        init = false,
        class = {"VirtualBox"},
        volatile = true,
    }
}
tyrannical.properties.intrusive = {"feh", "URxvt", "pinentry"}
tyrannical.properties.floating = {
    "Mumble", "Steam", "Guild Wars 2", "VirtualBox", "Skype", "Mumble", "gimp",
    "Wine", "pinentry", "Pidgin"
}
tyrannical.properties.size_hints_honor = {
    xterm = false, URxvt = false, mpv = false
}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Vicious Widgets

-- Colours
coldef = "</span>"
colwhi = "<span color='#b2b2b2'>"
red = "<span color='#e54c62'>"

-- Textclock widget
clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.widget_clock)
mytextclock = awful.widget.textclock("<span font=\"tewi 12\"><span font=\"tewi 9\" color=\"#DDDDFF\"> %a %d %b %H:%M</span></span>")

-- Calendar attached to the textclock
local os = os
local string = string
local table = table
local util = awful.util

char_width = nil
text_color = theme.fg_normal or "#FFFFFF"
today_color = theme.tasklist_fg_focus or "#FF7100"
calendar_width = 21

local calendar = nil
local offset = 0

local data = nil

local function pop_spaces(s1, s2, maxsize)
   local sps = ""
   for i = 1, maxsize - string.len(s1) - string.len(s2) do
      sps = sps .. " "
   end
   return s1 .. sps .. s2
end

local function create_calendar()
   offset = offset or 0

   local now = os.date("*t")
   local cal_month = now.month + offset
   local cal_year = now.year
   if cal_month > 12 then
      cal_month = (cal_month % 12)
      cal_year = cal_year + 1
   elseif cal_month < 1 then
      cal_month = (cal_month + 12)
      cal_year = cal_year - 1
   end

   local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
                                            month = cal_month + 1}) - 86400)
   local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
   local first_day_in_week =
      os.date("%w", first_day)
   local result = "su mo tu we th fr sa\n"
   for i = 1, first_day_in_week do
      result = result .. " "
   end

   local this_month = false
   for day = 1, last_day do
      local last_in_week = (day + first_day_in_week) % 7 == 0
      local day_str = pop_spaces("", day, 2) .. (last_in_week and "" or " ")
      if cal_month == now.month and cal_year == now.year and day == now.day then
         this_month = true
         result = result ..
            string.format('<span weight="bold" foreground = "%s">%s</span>',
                          today_color, day_str)
      else
         result = result .. day_str
      end
      if last_in_week and day ~= last_day then
         result = result .. "\n"
      end
   end

   local header
   if this_month then
      header = os.date("%a, %d %b %Y")
   else
      header = os.date("%B %Y", first_day)
   end
   return header, string.format('<span font="%s" foreground="%s">%s</span>',
                                theme.font, text_color, result)
end

local function calculate_char_width()
   return beautiful.get_font_height(theme.font) * 0.555
end

function hide()
   if calendar ~= nil then
      naughty.destroy(calendar)
      calendar = nil
      offset = 0
   end
end

function show(inc_offset)
   inc_offset = inc_offset or 0

   local save_offset = offset
   hide()
   offset = save_offset + inc_offset

   local char_width = char_width or calculate_char_width()
   local header, cal_text = create_calendar()
   calendar = naughty.notify({ title = header,
                               text = cal_text,
                               timeout = 0, hover_timeout = 0.5,
                            })
end

mytextclock:connect_signal("mouse::enter", function() show(0) end)
mytextclock:connect_signal("mouse::leave", hide)
mytextclock:buttons(util.table.join( awful.button({ }, 1, function() show(-1) end),
                                     awful.button({ }, 3, function() show(1) end)))


-- Music widget
mpdwidget = wibox.widget.textbox()
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautiful.widget_music)
mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))

vicious.register(mpdwidget, vicious.widgets.mpd,
function(widget, args)
-- play
if (args["{state}"] == "Play") then
    mpdicon:set_image(beautiful.widget_music_on)
return "<span background='#313131' font='tewi 13' rise='2000'> <span font='tewi 9'>" .. red .. args["{Title}"] .. coldef .. colwhi .. " - " .. coldef .. colwhi .. args["{Artist}"] .. coldef .. " </span></span>"
-- pause
elseif (args["{state}"] == "Pause") then
    mpdicon:set_image(beautiful.widget_music)
return "<span background='#313131' font='tewi 13' rise='2000'> <span font='tewi 9'>" .. colwhi .. "mpd paused" .. coldef .. " </span></span>"
else
    mpdicon:set_image(beautiful.widget_music)
return ""
end
end, 1)


-- CPU widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, '<span font="tewi 13" rise="2000"> <span font="tewi 9">$1% </span></span>', 3)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))

-- Net widget
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, '<span background="#313131" font="tewi 13" rise="2000"> <span font="tewi 9" color="#7AC82E">${wlan0 down_kb}</span> <span font="tewi 7" color="#EEDDDD">↓↑</span> <span font="tewi 9" color="#46A8C3">${wlan0 up_kb} </span></span>', 3)
neticon = wibox.widget.imagebox()
neticon:set_image(beautiful.widget_net)
netwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))


-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
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
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spr)
    right_layout:add(arrl)
    right_layout:add(arrl_ld)
    right_layout:add(mpdicon)
    right_layout:add(mpdwidget)
    right_layout:add(arrl_dl)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(arrl_ld)
    right_layout:add(neticon)
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Esc", awful.tag.history.restore),
    awful.key({ modkey,           }, ";", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
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

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- CUSTOM KEYS
    --
    -- MPD Controls prev/next/toggle
    awful.key({ modkey, "Shift"   }, ",", function () awful.util.spawn_with_shell("mpc prev") end),
    awful.key({ modkey, "Shift"   }, ".", function () awful.util.spawn_with_shell("mpc next") end),
    awful.key({ modkey, "Shift"   }, "p", function () awful.util.spawn_with_shell("mpc toggle") end),

    -- Add a tag
    awful.key({ modkey,           }, "a",
            function ()
                      awful.prompt.run({ prompt = "New tag name: " },
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
    awful.key({ modkey, }, "d", function () awful.tag.delete() end),
    -- Rename the Current Tab
    awful.key({ modkey, "Shift"   }, "a",
                 function ()
                    awful.prompt.run({ prompt = "New tag name: " },
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
                                     end)
                 end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
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
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
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

-- {{{ Rules
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

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
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

-- Ignore Transparency
-- Classes of Clients to Make Opaque
ignore_transparency_classes = { 'Smplayer'
                              , 'Vlc'
                              , 'Mirage'
                              , 'Mcomix'
                              , 'X3TC_main'
                              , 'dota_linux'
                              , 'Wine'
                              , 'mpv'
                              , 'ns2_linux32'
                              }
-- Names of Clients to Make Opaque
ignore_transparency_names = { 'Guild Wars 2'
                            , 'Minecraft 1.7.2'
                            }

-- Set a Client to Opaque if Listed
local function ignore_transparency(c)
    for i, ignore_class in ipairs(ignore_transparency_classes) do
        if c.class == ignore_class then
            c.opacity = 1
        end
    end
    for i, ignore_name in ipairs(ignore_transparency_names) do
        if c.name == ignore_name then
            c.opacity = 1
        end
    end

end

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = .92
    ignore_transparency(c)
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = .82
    ignore_transparency(c)
end)
-- }}}

-- {{{ Strip HTML from notifications
naughty.config.notify_callback = function(args)
    args.text = HTML_ToText(args.text)
    return args
end
-- }}}


-- {{{ Autostart
--

-- Remove old mounted folders
r.run("udevil clean")
-- Terminal Daemon
r.run("urxvtd -f -o -q")
-- Enable Transparency/Composting
r.run("compton -b")
-- Start RSI Prevention Program
r.run("workrave")
-- Start the PulseAudio SysTray
r.run("pasystray")
-- Start Screens
r.run("bash /home/prikhi/.bin/start_split")
--r.run("bash /home/prikhi/.bin/start_work")
r.run("bash /home/prikhi/.bin/start_irc")
--r.run("bash /home/prikhi/.bin/start_torrent")

r.run("firefox")
r.run("mumble")
--r.run("skype")
-- }}}
