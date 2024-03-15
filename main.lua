local download = require("./http.lua")

local files = {
  lua = {
    name = "lua.zip",
    url = "https://pilotfiber.dl.sourceforge.net/project/luabinaries/5.4.2/Tools%20Executables/lua-5.4.2_Win64_bin.zip",
    unzip = true,
    files = {
      {"lua54.exe","/home/justdie/lua/installer/files/lua54.exe"},
      {"lua54.dll", "/home/justdie/lua/installer/files/lua54.dll"}
    }
  },
  luarocks = {
    name = "luarocks.zip",
    url = "https://luarocks.github.io/luarocks/releases/luarocks-3.10.0-windows-64.zip",
    unzip = true,
    files = {
      {"luarocks-3.10.0-windows-64/luarocks.exe", "/home/justdie/lua/installer/files/luarocks.exe"},
      {"luarocks-3.10.0-windows-64/luarocks-admin.exe", "/home/justdie/lua/installer/files/luarocks-admin.exe"}
    }
  }
}

download.begin(files)
