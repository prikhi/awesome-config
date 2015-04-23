---------------------------
-- molokai awesome theme --
---------------------------

-- Forked from copycatkiller's powerarrow-darker.

theme = {}

--  Molokai colors
theme.molokai_bkgd  = "#1B1D1E"
theme.black         = "#232526"
theme.white         = "#F8F8F0"

theme.red           = "#FF0000"
theme.orange        = "#FD971F"
theme.magenta       = "#F92672"
theme.cyan          = "#66D9EF"
theme.green         = "#A6E22E"



theme.font                          = "Dina 8"

theme.bg_normal                     = theme.molokai_bkgd
theme.bg_focus                      = theme.orange
theme.bg_urgent                     = theme.cyan
theme.bg_minimize                   = theme.molokai_bkgd
theme.bg_systray                    = theme.bg_normal

theme.fg_normal                     = theme.magenta
theme.fg_focus                      = theme.molokai_bkgd
theme.fg_urgent                     = theme.black
theme.fg_minimize                   = theme.green

theme.border_width                  = 1
theme.border_normal                 = theme.black
theme.border_focus                  = theme.orange
theme.border_marked                 = theme.magenta

theme.taglist_fg_focus              = theme.molokai_bkgd
theme.taglist_bg_focus              = theme.magenta
theme.taglist_fg_urgent             = theme.fg_urgent
theme.taglist_bg_urgent             = theme.bg_urgent

theme.tasklist_fg_focus             = theme.fg_focus
theme.tasklist_bg_focus             = theme.bg_focus
theme.tasklist_fg_urgent            = theme.fg_urgent
theme.tasklist_bg_urgent            = theme.bg_urgent

theme.textbox_widget_margin_top = 1

theme.notify_fg = theme.green
theme.notify_bg = theme.bg_normal
theme.notify_border = theme.magenta

theme.awful_widget_height = 14
theme.awful_widget_margin_top = 2

theme.menu_height = 15
theme.menu_width  = 100

themes_dir                          = os.getenv("HOME") ..
                                      "/.config/awesome/themes/molokai"
theme.wallpaper_cmd                 = { "feh --bg-scale " .. themes_dir .. "/background.jpg" }
theme.menu_submenu_icon             = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"

theme.layout_tile                   = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/floating.png"

theme.arrl                          = themes_dir .. "/icons/arrl.png"
theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl.png"
theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld.png"

theme.widget_ac                     = themes_dir .. "/icons/ac.png"
theme.widget_battery                = themes_dir .. "/icons/battery.png"
theme.widget_battery_low            = themes_dir .. "/icons/battery_low.png"
theme.widget_battery_empty          = themes_dir .. "/icons/battery_empty.png"
theme.widget_mem                    = themes_dir .. "/icons/mem.png"
theme.widget_cpu                    = themes_dir .. "/icons/cpu.png"
theme.widget_temp                   = themes_dir .. "/icons/temp.png"
theme.widget_net                    = themes_dir .. "/icons/net_transparent.png"
theme.widget_hdd                    = themes_dir .. "/icons/hdd.png"
theme.widget_music                  = themes_dir .. "/icons/note_transparent.png"
theme.widget_music_on               = themes_dir .. "/icons/note_on_transparent.png"
theme.widget_vol                    = themes_dir .. "/icons/vol.png"
theme.widget_vol_low                = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no                 = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute               = themes_dir .. "/icons/vol_mute.png"
theme.widget_mail                   = themes_dir .. "/icons/mail.png"
theme.widget_mail_on                = themes_dir .. "/icons/mail_on.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = "▀ "
theme.tasklist_maximized_horizontal = "="
theme.tasklist_maximized_vertical   = "| "

-- Lain icons
theme.lain_icons                    = os.getenv("HOME") ..
                                      "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair               = theme.lain_icons .. "termfairw.png"
theme.layout_centerfair             = theme.lain_icons .. "centerfairw.png"
theme.layout_cascade                = theme.lain_icons .. "cascadew.png"
theme.layout_cascadetile            = theme.lain_icons .. "cascadetilew.png"
theme.layout_centerwork             = theme.lain_icons .. "centerworkw.png"

return theme
