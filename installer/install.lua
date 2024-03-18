local socket = require("socket.http")
local lanes = require("lanes.core")
local registry = require("registry")
local zip = require("zip")
local lfs = require("lfs")
local utils = {}

function utils:install(files, progress)
    self.progress = progress
    lfs.mkdir("tmp")
    for names,content in pairs(files) do
            utils:newdir(content.directories)
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
    end
end

function utils:download(file_url, name)
    local body, code = socket.request(file_url)
    if not body then
        error(code)
    else
        utils:write(body, name)
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
    assert(file:write(text))
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
    end
end

function utils:progressBar()
    --TODO with the UI
    end

return utils



