package.path = "./?.lua;"..package.path
local installer = require("install")
local AppData = os.getenv("APPDATA")
local files = {
  lua_exec = {
    name = "lua_exec.zip",
    url = "https://pilotfiber.dl.sourceforge.net/project/luabinaries/5.4.2/Tools%20Executables/lua-5.4.2_Win64_bin.zip",
    unzip = true,
    files = {
      { "lua54.exe", AppData..[[\lua\bin2\lua54.exe]] },
      { "lua54.dll", AppData..[[\lua\bin2\lua54.dll]] },
    },
    directories = {
      AppData..[[\lua]],
      AppData..[[\lua\bin2]]
    },
    path = {
      [[C:\Users\justi\AppData\lua\bin]]
    },
    registry = {
      { "LUA_LIBDIR",  AppData..[[\lua\bin]] }
    },
  },
  lua_inc = {
    name = "lua_inc.zip",
    url = "https://master.dl.sourceforge.net/project/luabinaries/5.1.4/Docs%20and%20Sources/lua5_1_4_Sources.zip?viasf=1",
    unzip = true,
    directories = {
      AppData..[[\lua]],
      AppData..[[\lua\inc]]
    },
    files = {
      { "lua5.1/include/lualib.h",  AppData..[[\lua\inc\lualib.h]] },
      { "lua5.1/include/lua.h",  AppData..[[\lua\inc\lua.h]] },
      { "lua5.1/include/lua.hpp",   AppData..[[\lua\inc\lua.hpp]] },
      { "lua5.1/include/lauxlib.h",   AppData..[[\lua\inc\luaxlib.h]] },
      { "lua5.1/include/luaconf.h",   AppData..[[\lua\inc\luaconf.h]] },

    },
    path = {
      AppData..[[\lua\bin]],
    },
    registry = {
      { "LUA_INCDIR",  AppData..[[\lua\inc]] }
    }
  },
  luarocks = {
    name = "luarocks.zip",
    url = "https://luarocks.github.io/luarocks/releases/luarocks-3.10.0-windows-64.zip",
    unzip = true,
    files = {
      { "luarocks-3.10.0-windows-64/luarocks.exe",        AppData..[[\luarocks\luarocks.exe]],       false },
      { "luarocks-3.10.0-windows-64/luarocks-admin.exe", AppData..[[\luarocks\luarocks-admin.exe]], false }
    },
    registry = {
      { "LUAROCKS_CONFIG",AppData..[[\luarocks\config.lua]] }
    },
    directories = {
      AppData..[[\luarocks\]],
    }
  }
}
installer:install(files, nil)
