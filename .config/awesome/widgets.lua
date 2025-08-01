local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local layout = {
  widget = wibox.widget {
    {
      text = '0 ',
      align = "center",
      widget = wibox.widget.textbox
    },
    {
      text = "tile",
      align = "center",
      widget = wibox.widget.textbox,
    },
    layout = wibox.layout.align.horizontal
  },
  update = function(w, out1, out2)
    w.widget.first.text = out1
    w.widget.second.text = ' ' .. out2
  end,
}

local volume = {
  widget = wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        valign = "center",
        font   = "JetBrainsMonoMedium Nerd Font 22",
        widget = wibox.widget.textbox
      },
      forced_width = 27,
      layout = wibox.layout.stack
    },
    {
      text = '',
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal
  },
  update = function(w, out)
    w.widget.second.text = out:match("%d+%%") or out:match("%a+")
    out = tonumber(out:match("%d+"))
    if out then
      if out < 15 then w.widget.first.icon.text = '奄'
      elseif out < 50 then w.widget.first.icon.text = '奔'
      else w.widget.first.icon.text = '墳'
      end
    end
  end
}

gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    awful.spawn.easy_async("pamixer --get-volume-human", function(out)
      volume:update(out)
    end)
  end
}

local battery = {
  widget = wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 15",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 30,
      layout = wibox.layout.stack
    },
    {
      text = '',
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal,
  },
  update = function(w, out)
    w.widget.second.text = out:match("%d+") .. '%'
    out = tonumber(out:match("%d+"))
    if out < 21 then
      w.widget.first.icon.text = ''
    elseif out < 41 then
      w.widget.first.icon.text = ''
    elseif out < 61 then
      w.widget.first.icon.text = ''
    elseif out < 81 then
      w.widget.first.icon.text = ''
    else
      w.widget.first.icon.text = ''
    end
  end
}

gears.timer {
  timeout   = 60,
  call_now  = true,
  autostart = true,
  callback  = function()
    awful.spawn.easy_async("cat /sys/class/power_supply/BAT0/capacity", function(out)
      battery:update(out)
    end)
  end
}

local wlan = {
  widget = wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 16",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 28,
      layout = wibox.layout.stack
    },
    {
      text = "disconnected",
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal,
  },
  update = function(w, out)
    out = out:gsub('\n', ' ')
    if out == ' ' then
      w.widget.second.text = "disconnected"
    else
      w.widget.second.text = out
    end
  end
}

local memory = {
  widget = wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 15",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 22,
      layout = wibox.layout.stack
    },
    {
      text = "",
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal,
  },
  update = function(w, out)
    w.widget.second.text = out:gsub('\n', '')
  end
}

gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    awful.spawn.easy_async_with_shell("nmcli | awk '/wlo1:/ {print $4}'",
      function(out)
        wlan:update(out)
      end)
    awful.spawn.easy_async_with_shell("free -h | awk '(NR==2) {print $3}'",
      function(out)
        memory:update(out)
      end)
  end
}

local clock = wibox.widget {
  {
    {
      text   = '  ',
      font   = "JetBrainsMonoMedium Nerd Font 16",
      valign = "center",
      widget = wibox.widget.textbox
    },
    forced_width = 50,
    layout = wibox.layout.stack
  },
  {
    format = "%H:%M",
    timezone = "Asia/Krasnoyarsk",
    refresh = 60,
    valign = "center",
    widget = wibox.widget.textclock
  },
  layout = wibox.layout.align.horizontal
}

local keyboardlayout = {
  widget = wibox.widget {
    {
      {
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 18",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 25,
      layout = wibox.layout.stack
    },
    {
      text = '',
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal
  },
  update = function(w)
    local text = awesome.xkb_get_layout_group()
    if text == 0 then
      text = "us"
    else
      text = "ru"
    end
    w.widget.second.text = text
  end
}
awesome.connect_signal("xkb::group_changed", function()
  keyboardlayout:update()
  end)
awesome.emit_signal("xkb::group_changed")

return {
  clock = clock,
  keyboardlayout = keyboardlayout,
  volume = volume,
  memory = memory,
  battery = battery,
  wlan = wlan,
  layout = layout
}

--[[ local battery = awful.widget.watch("cat /sys/class/power_supply/BAT0/capacity",
  60,
  function(w, out)
    w.second.text = out:gsub('\n', '%%')
    local capacity = tonumber(out)
    if capacity < 21 then
      w.first.icon.text = ''
    elseif capacity < 41 then
      w.first.icon.text = ''
    elseif capacity < 61 then
      w.first.icon.text = ''
    elseif capacity < 81 then
      w.first.icon.text = ''
    else
      w.first.icon.text = ''
    end
  end,
  wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 15",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 30,
      layout = wibox.layout.stack
    },
    {
      text = '',
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal,
  })

local wlan = awful.widget.watch("bash -c 'nmcli | grep wlo1:'", 5, function(w, out)
  out = out:gsub('\n', ' ')
  if out:sub(7, 26) == "подключено" then
    w.second.text = out:sub(31, #out)
  else
    w.second.text = "disconnected "
  end
end,
  wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 16",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 28,
      layout = wibox.layout.stack
    },
    {
      text = "disconnected",
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal,
  })

local memory = awful.widget.watch("bash -c \"free -h | awk '(NR==2){ print $3 }'\"",
  2,
  function(w, out)
    w.second.text = out:gsub('\n', '')
  end,
  wibox.widget {
    {
      {
        id     = "icon",
        text   = '',
        font   = "JetBrainsMonoMedium Nerd Font 15",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width = 22,
      layout = wibox.layout.stack
    },
    {
      text = "",
      valign = "center",
      widget = wibox.widget.textbox
    },
    layout = wibox.layout.align.horizontal,
  }) ]]
