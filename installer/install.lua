local socket = require("socket.http")
local registry = require("registry")
local zip = require("zip")
local lfs = require("lfs")
local utils = {
    amount = 0,
    step = "["
}

function utils:install(files, progress)
    print("Welcome to the lua/luarocks installer")
    self.progress = progress
    lfs.mkdir("tmp")
    --utils:initProgress(files)
    for names,content in pairs(files) do
            print(content.name)
            if content.directories then
            utils:newdir(content.directories)
            end
            utils:download(content.url, content.name)
            if content.unzip then
                utils:unzip(content.name, content.files)
            end
            if content.registry then
                utils:registry(content.registry)
            end
            if content.path then
            utils:path(content.path)
            end
            print(content.name)
    end
    print("Seems like we're done here, enjoy!")
end

function utils:download(file_url, name)
    local body, code = socket.request(file_url)
    if not body then
        error(code)
    else
        utils:write(body, name)
        utils:progressBar()
    end
end

function utils:newdir(directories)
    for k,v in pairs(directories) do
        lfs.mkdir(v)
        print("created "..v)
    end
end

function utils:write(content, name)
    print("downloading ".. name)
    local file = assert(io.open("tmp/" .. name, "wb"))
    assert(file:write(content))
    file:close()
end

function utils:unzip(name, files)
    local content = zip.open("tmp/"..name)
    for k,v in pairs(files) do
    local text, err = content:open(v[1])
    local text = text:read("*a")
    if err then
     print(err)
    end
    lfs.touch(v[2]) 
    local file = io.open(v[2], "wb")
    if file then
    file:write(text)
        end
    end
    print("extracted: ".. name)
end

function utils:registry(value)
    for k,v in pairs(value) do
        registry.registry_key(v[1], v[2])
    end
end

function utils:path(value)
    for k,v in pairs(value) do
        registry.registry_path(v)
        print("registed " .. v)
    end
end
--this function is here to get the amount of steps it has to go throught
--this is a bit of a funky method, and it really doesn't work out that much
--but i spent too long writing it to just delete it, like come on man...

--[[function utils:initProgress(everything)
    for k,v in pairs(everything) do
        if v.files then
        for e,b in pairs(v.files) do
            --self.amount = self.amount + 
        end
    end
        if v.registry then
        for t, c in pairs(v.registry) do
            for n,l in pairs(c) do
            self.amount = self.amount + #l
            end
        end
    end
        if v.directories then
        for z, m in pairs(v.directories) do
            self.amount = self.amount + #m
        end
    end
        if v.path then
        for t,y in pairs(v.path) do
            self.amount = self.amount + #y
        end
    end
    end
end
]]
function utils:progressBar()
   --[[ for i=1, self.amount/100 do
    self.step = self.step .. "="
    end
    io.write("\r".. self.step .. "]")
   ]] 
end
return utils



