
local cfg = {}

-- mysql credentials
cfg.db = {
  driver = "ghmattimysql",
  host = "127.0.0.1:3311",
  database = "vRP",
  user = "fivem",
  password = "macaco123"
}

cfg.framework = {
  name = "Zentry RolePlaye",
  server_name = "Zentry New Life",
  tag = "vRP",
}

cfg.home_dir = "C:/Zentry/Fivem/ZentryRP"
cfg.home_dir_inv = "C:\\Zentry\\Fivem\\ZentryRP"
cfg.save_interval = 60 -- seconds
cfg.whitelist = false -- enable/disable whitelist

-- delay the tunnel at loading (for weak connections)
cfg.load_duration = 30 -- seconds, player duration in loading mode at the first spawn
cfg.load_delay = 60 -- milliseconds, delay the tunnel communication when in loading mode
cfg.global_delay = 0 -- milliseconds, delay the tunnel communication when not in loading mode

cfg.ping_timeout = 5 -- number of minutes after a client should be kicked if not sending pings

-- identify users only with steam or ros identifiers (solve same ip issue, recommended)
-- if enabled, steam auth should be forced in the FiveM server config
cfg.ignore_ip_identifier = true

cfg.lang = "en"
cfg.permlang = "en"
cfg.serverlang = "en"

cfg.debug = true

-- time to wait before displaying async return warning (seconds)
cfg.debug_async_time = 2


return cfg
