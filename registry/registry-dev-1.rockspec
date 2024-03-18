package = "installer"
version = "1.0-1"
source = {
   url = "..."
}
description = {
   summary = "very simple bindings to the win32 registry API",
   detailed = [[

   ]],
   license = "BSD+3" 
}
dependencies = {
   "lua 5.1",
}
build = {
   type = "builtin",
   modules = {
      registry = {
         source = {"registry.c"},
         libraries = {"user32"}
   }
}
