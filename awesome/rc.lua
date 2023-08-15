--{{{ require + init
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local has_fdo, freedesktop = pcall(require, "freedesktop")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
--}}}

-- {{{ error handling
if awesome.startup_errors then
  naughty.notify {
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  }
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
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

local terminal = "st"
local editor = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor

menubar.utils.terminal = terminal

local altkey = "Mod1"
local winkey = "Mod4"

awful.layout.layouts = { awful.layout.suit.floating }

-- {{{ menu
local menu_awesome = {
  "awesome",
  {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
  },
  beautiful.awesome_icon,
}
local menu_terminal = { "open terminal", terminal }

if has_fdo then
  mymainmenu = freedesktop.menu.build {
    before = { menu_awesome },
    after =  { menu_terminal },
  }
else
  mymainmenu = awful.menu {
    items = {
      menu_awesome,
      menu_terminal,
    }
  }
end
-- }}}

root.buttons(gears.table.join(
awful.button({ }, 1, function() mymainmenu:hide() end),
awful.button({ }, 3, function () mymainmenu:toggle() end)
--awful.button({ }, 4, awful.tag.viewnext),
--awful.button({ }, 5, awful.tag.viewprev)
))


--local image = [[
--<?xml version="1.0" encoding="UTF-8" standalone="no"?>
--<svg width="2in" height="1in">
--<rect height="0.1in" width="0.1in" style="fill:red;"
--<text x="10" y="32" width="150" style="font-size: 0.1in;">Hello world!</text>
--</svg>
--]]

--local mylauncher = awful.widget.launcher({ label = "Menu",image = image, menu = mymainmenu })


local clock = wibox.widget.textclock()

local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t)
  if not t.selected then
    t:view_only()
  else
    awful.tag.viewtoggle(t)
  end
end),
awful.button({ winkey }, 1, function(t)
  if client.focus then
    client.focus:move_to_tag(t)
  end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ winkey }, 3, function(t)
  if client.focus then
    client.focus:toggle_tag(t)
  end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
awful.button({ }, 1, function (c)
  if c == client.focus then
    c.minimized = true
  else
    c:emit_signal(
    "request::activate",
    "tasklist",
    {raise = true}
    )
  end
end),
awful.button({ }, 3, function()
  awful.menu.client_list({ theme = { width = 250 } })
end),
awful.button({ }, 4, function ()
  awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
  awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  awful.tag({"1", "2", "3", "4"}, s, awful.layout.suit.floating)

  s.mypromptbox = awful.widget.prompt()
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      layout = wibox.layout.fixed.vertical,
      spacing = 1,
    },
    widget_template = {
      {
        {
          {
            id     = "text_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left  = 10,
        right = 10,
        widget = wibox.container.margin
      },
      id     = "background_role",
      widget = wibox.container.background,
    },

  }

  local xresources = require("beautiful.xresources")
  local dpi = xresources.apply_dpi

  s.mywibox = awful.wibar({ position = "left", screen = s, width = dpi(128)})

  s.mywibox:setup {
    layout = wibox.layout.align.vertical,
    {
      layout = wibox.layout.fixed.vertical,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist,
    {
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      clock,
      --s.mylayoutbox,
    },
  }
end)


local unpack = unpack or table.unpack

local function join(t)
  return gears.table.join(unpack(t))
end

local keys, desc, group = {}
do
  keys = setmetatable(keys, {
    __newindex = function(keys, key, fn)
      local modstr = key:match"^([^_]+)_" or ""
      local keystr = key:match"([^_]+)$"
      local mods = {}
      for mod in modstr:gmatch"." do
        mods[#mods+1] = ({C="Control",W="Mod4",S="Shift",A="Mod1"})[mod]
      end
      for _, v in ipairs(awful.key(mods, keystr, fn, {description=desc,group=group})) do
        rawset(keys, #keys+1, v)
      end
    end
  })
end

group = "awesome"

desc = "show help"
keys.W_s = hotkeys_popup.show_help

desc = "restart awesome"
keys.CW_r = awesome.restart

group = "launcher"
desc = "spawn terminal"
keys.CA_t = function() awful.spawn(terminal) end

local showdesktop = true
keys.CA_d = function()
  awful.tag.viewtoggle(awful.screen.focused().selected_tag)
  --if showdesktop then
  --else
  --end
  --showdesktop = not showdesktop
end


--local globalkeys = join {
--  awful.key({ winkey,           }, "s",      hotkeys_popup.show_help,
--  {description="show help", group="awesome"}),
--
--  awful.key({ winkey,           }, "Left",   awful.tag.viewprev,
--  {description = "view previous", group = "tag"}),
--
--  awful.key({ winkey,           }, "Right",  awful.tag.viewnext,
--  {description = "view next", group = "tag"}),
--
--  awful.key({ winkey, }, "Escape", awful.tag.history.restore,
--  {description = "go back", group = "tag"}),
--
--  awful.key({ winkey,           }, "j",
--  function ()
--    awful.client.focus.byidx( 1)
--  end,
--  {description = "focus next by index", group = "client"}
--  ),
--  awful.key({ winkey,           }, "k",
--  function ()
--    awful.client.focus.byidx(-1)
--  end,
--  {description = "focus previous by index", group = "client"}
--  ),
--  awful.key({ winkey,           }, "w", function () mymainmenu:show() end,
--  {description = "show main menu", group = "awesome"}),
--
--  awful.key({ winkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
--  {description = "swap with next client by index", group = "client"}),
--  awful.key({ winkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
--  {description = "swap with previous client by index", group = "client"}),
--  awful.key({ winkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
--  {description = "focus the next screen", group = "screen"}),
--  awful.key({ winkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
--  {description = "focus the previous screen", group = "screen"}),
--  awful.key({ winkey,           }, "u", awful.client.urgent.jumpto,
--  {description = "jump to urgent client", group = "client"}),
--  awful.key({ winkey,           }, "Tab",
--  function ()
--    awful.client.focus.history.previous()
--    if client.focus then
--      client.focus:raise()
--    end
--  end,
--  {description = "go back", group = "client"}),
--
--  awful.key({"Control", altkey}, "t", function () awful.spawn(terminal) end,
--  {description = "open a terminal", group = "launcher"}),
--  awful.key({ winkey, "Control" }, "r", awesome.restart,
--  {description = "reload awesome", group = "awesome"}),
--  awful.key({ winkey, "Shift"   }, "q", awesome.quit,
--  {description = "quit awesome", group = "awesome"}),
--
--  awful.key({ winkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
--  {description = "increase master width factor", group = "layout"}),
--  awful.key({ winkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
--  {description = "decrease master width factor", group = "layout"}),
--  awful.key({ winkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
--  {description = "increase the number of master clients", group = "layout"}),
--  awful.key({ winkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
--  {description = "decrease the number of master clients", group = "layout"}),
--  awful.key({ winkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--  {description = "increase the number of columns", group = "layout"}),
--  awful.key({ winkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
--  {description = "decrease the number of columns", group = "layout"}),
--  awful.key({ winkey,           }, "space", function () awful.layout.inc( 1)                end,
--  {description = "select next", group = "layout"}),
--  awful.key({ winkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
--  {description = "select previous", group = "layout"}),
--
--  awful.key({ winkey, "Control" }, "n",
--  function ()
--    local c = awful.client.restore()
--    if c then
--      c:emit_signal(
--      "request::activate", "key.unminimize", {raise = true}
--      )
--    end
--  end,
--  {description = "restore minimized", group = "client"}),
--
--  awful.key({ winkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
--  {description = "run prompt", group = "launcher"}),
--
--  awful.key({ winkey }, "x",
--  function ()
--    awful.prompt.run {
--      prompt       = "Run Lua code: ",
--      textbox      = awful.screen.focused().mypromptbox.widget,
--      exe_callback = awful.util.eval,
--      history_path = awful.util.get_cache_dir() .. "/history_eval"
--    }
--  end,
--  {description = "lua execute prompt", group = "awesome"}),
--  awful.key({ winkey }, "p", function() menubar.show() end,
--  {description = "show the menubar", group = "launcher"})
--}
--
--clientkeys = gears.table.join(
--awful.key({ winkey,           }, "f",
--function (c)
--  c.fullscreen = not c.fullscreen
--  c:raise()
--end,
--{description = "toggle fullscreen", group = "client"}),
--awful.key({ winkey, "Shift"   }, "c",      function (c) c:kill()                         end,
--{description = "close", group = "client"}),
--awful.key({ winkey, "Control" }, "space",  awful.client.floating.toggle                     ,
--{description = "toggle floating", group = "client"}),
--awful.key({ winkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
--{description = "move to master", group = "client"}),
--awful.key({ winkey,           }, "o",      function (c) c:move_to_screen()               end,
--{description = "move to screen", group = "client"}),
--awful.key({ winkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
--{description = "toggle keep on top", group = "client"}),
--awful.key({ winkey,           }, "n",
--function (c)
--  c.minimized = true
--end ,
--{description = "minimize", group = "client"}),
--awful.key({ winkey,           }, "m",
--function (c)
--  c.maximized = not c.maximized
--  c:raise()
--end ,
--{description = "(un)maximize", group = "client"}),
--awful.key({ winkey, "Control" }, "m",
--function (c)
--  c.maximized_vertical = not c.maximized_vertical
--  c:raise()
--end ,
--{description = "(un)maximize vertically", group = "client"}),
--awful.key({ winkey, "Shift"   }, "m",
--function (c)
--  c.maximized_horizontal = not c.maximized_horizontal
--  c:raise()
--end ,
--{description = "(un)maximize horizontally", group = "client"})
--)

for i = 1, 9 do
  --globalkeys = gears.table.join(globalkeys,
  --awful.key({ winkey }, "#" .. i + 9,
  --function ()
  --  local screen = awful.screen.focused()
  --  local tag = screen.tags[i]
  --  if tag then
  --    tag:view_only()
  --  end
  --end,
  --{description = "view tag #"..i, group = "tag"}),
  --awful.key({ winkey, "Control" }, "#" .. i + 9,
  --function ()
  --  local screen = awful.screen.focused()
  --  local tag = screen.tags[i]
  --  if tag then
  --    awful.tag.viewtoggle(tag)
  --  end
  --end,
  --{description = "toggle tag #" .. i, group = "tag"}),
  --awful.key({ winkey, "Shift" }, "#" .. i + 9,
  --function ()
  --  if client.focus then
  --    local tag = client.focus.screen.tags[i]
  --    if tag then
  --      client.focus:move_to_tag(tag)
  --    end
  --  end
  --end,
  --{description = "move focused client to tag #"..i, group = "tag"}),
  --awful.key({ winkey, "Control", "Shift" }, "#" .. i + 9,
  --function ()
  --  if client.focus then
  --    local tag = client.focus.screen.tags[i]
  --    if tag then
  --      client.focus:toggle_tag(tag)
  --    end
  --  end
  --end,
  --{description = "toggle focused client on tag #" .. i, group = "tag"})
  --)
end

clientbuttons = gears.table.join(
awful.button({ }, 1, function (c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
end),
awful.button({ winkey }, 1, function (c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  awful.mouse.client.move(c)
end),
awful.button({ winkey }, 3, function (c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  awful.mouse.client.resize(c)
end)
)

root.keys(keys)

awful.rules.rules = {
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  {
    rule_any = {
      instance = {
        "DTA",
        "copyq",
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",
        "Sxiv",
        "Tor Browser",
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"},

        name = {
          "Event Tester",
        },
        role = {
          "AlarmWindow",
          "ConfigManager",
          "pop-up",
        }
      },
      properties = { floating = true }
    },

    {
      rule_any = {type = { "normal", "dialog" }
    },
    properties = { titlebars_enabled = true }
  },
}

client.connect_signal("manage", function (c)
  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("request::titlebars", function(c)
  local buttons = gears.table.join(
  awful.button({ }, 1, function()
    c:emit_signal("request::activate", "titlebar", {raise = true})
    awful.mouse.client.move(c)
  end),
  awful.button({ }, 3, function()
    c:emit_signal("request::activate", "titlebar", {raise = true})
    awful.mouse.client.resize(c)
  end))

  awful.titlebar(c):setup {
    {
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    {
      {
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    {
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
