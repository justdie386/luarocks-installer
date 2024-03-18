A work in progress luarocks installer (CLI only for now)

Dependencies

- lua5.1
- luazip
- luasocket
- luafilesystem
- luasec
- registry

How to acquire the registry library

```
cd registry
luarocks build
```
Why? because i haven't posted it as an actual rock on the luarocks website just yet


How to use

For now, i haven't make any build steps to bundle it into an executable, which could be done with luastatic, but I'm planning on doing it when i get general idea of which GUI library i'll be using, and how i'll do everything else
