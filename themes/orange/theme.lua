---------------------------
-- orange awesome theme --
---------------------------

theme = {}

themes_dir          = os.getenv("HOME") .. "/.config/awesome/themes/orange"

theme.font          = "tewi 8"

theme.bg_normal     = "#1A1A1A"
theme.bg_focus      = "#FF7F00"
theme.bg_urgent     = "#FF0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#DCDCCC"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#FF7F00"
theme.border_marked = "#91231c"

theme.textbox_widget_margin_top = 1

theme.notify_fg = theme.fg_normal
theme.notify_bg = theme.bg_normal
theme.notify_border = theme.border_focus
theme.awful_widget_height = 14
theme.awful_widget_margin_top = 2
theme.menu_height = 15
theme.menu_width  = 100

theme.menu_submenu_icon = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = themes_dir .. "/icons/square_unsel.png"

theme.layout_tile = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv = themes_dir .. "/icons/fairv.png"
theme.layout_fairh = themes_dir .. "/icons/fairh.png"
theme.layout_spiral = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle = themes_dir .. "/icons/dwindle.png"
theme.layout_max = themes_dir .. "/icons/max.png"
theme.layout_fullscreen = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier = themes_dir .. "/icons/magnifier.png"
theme.layout_floating = themes_dir .. "/icons/floating.png"

theme.arrl = themes_dir .. "/icons/arrl.png"
theme.arrl_dl = themes_dir .. "/icons/arrl_dl.png"
theme.arrl_ld = themes_dir .. "/icons/arrl_ld.png"

theme.widget_ac = themes_dir .. "/icons/ac.png"
theme.widget_battery = themes_dir .. "/icons/battery.png"
theme.widget_battery_low = themes_dir .. "/icons/battery_low.png"
theme.widget_battery_empty = themes_dir .. "/icons/battery_empty.png"
theme.widget_mem = themes_dir .. "/icons/mem.png"
theme.widget_cpu = themes_dir .. "/icons/cpu.png"
theme.widget_temp = themes_dir .. "/icons/temp.png"
theme.widget_net = themes_dir .. "/icons/net.png"
theme.widget_hdd = themes_dir .. "/icons/hdd.png"
theme.widget_music = themes_dir .. "/icons/note.png"
theme.widget_music_on = themes_dir .. "/icons/note_on.png"
theme.widget_vol = themes_dir .. "/icons/vol.png"
theme.widget_vol_low = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute = themes_dir .. "/icons/vol_mute.png"
theme.widget_mail = themes_dir .. "/icons/mail.png"
theme.widget_mail_notify = themes_dir .. "/icons/mail_notify.png"

theme.tasklist_floating = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = "" 

theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
