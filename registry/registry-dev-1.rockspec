package = "installer"
version = "1.0-1"
source = {
   url = "..."
}
description = {
   summary = "A luarocks and lua installer",
   detailed = [[

   ]],
   license = "BSD+3" 
}
dependencies = {
   "lua 5.1",
   "luasocket",
   "luazip",
   "lanes",
   "luasec"
}
build = {
   type = "builtin",
   modules = {
      files = {"install.lua"},
      registry = {
         source = {"registry.c"},
         libraries = {"user32"}
      },
   }
}
