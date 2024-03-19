package.path = "./src/?.lua;./?.lua;"..package.path
local installer = require("install")
local AppData = os.getenv("APPDATA")
local files = {
  lua_exec = {
    name = "lua_exec.zip",
    url = "https://netactuate.dl.sourceforge.net/project/luabinaries/5.1.5/Tools%20Executables/lua-5.1.5_Win64_bin.zip",
    unzip = true,
    files = {
      { "lua5.1.exe", AppData..[[\lua\bin\lua51.exe]] },
      { "lua5.1.dll", AppData..[[\lua\bin\lua51.dll]] },
    },
    directories = {
      AppData..[[\lua]],
      AppData..[[\lua\bin]]
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
    url = "https://master.dl.sourceforge.net/project/luabinaries/5.1.5/Docs%20and%20Sources/lua-5.1.5_Sources.zip?viasf=1",
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
    directories = {
      AppData..[[\luarocks\]],
      AppData..[[\luarocks\bin]]
    },
    registry = {
      { "LUAROCKS_CONFIG",AppData..[[\luarocks\config.lua]] },
      { "LUA_CPATH", AppData..[[\luarocks\share\lua\5.1\?.lua]]}
    },
    path = {
      AppData..[[\luarocks\bin]]
    }
  }
}
installer:install(files, nil)
