local http = require("http")
local fs = require("fs")
local miniz = require("miniz")
local wrapper = {}


function wrapper.setEnv()

end

function wrapper.begin(content)
  local req
  for _,file in pairs(content) do
    print("downloading "..file.name.." ..")
    req = http.request(file.url, function(res)
        local data = {}
        res:on("data", function(chunk)
                 table.insert(data, chunk)
        end)
        res:on("end", function()
              if file.unzip then
                wrapper.unzip(data, file, number)
              else
                wrapper.writeFile(data, file, number)
              end
      end)
   end)
  req:done()
  end
end
function wrapper.unzip(data, content)
  print("unziping "..content.name.." ..")
  assert(fs.writeFileSync(content.name, table.concat(data)))
  local file = assert(miniz.new_reader(content.name))
  for k,v in pairs(content.files) do
    local newfile = file:extract(assert(file:locate_file(v[1])))
    fs.writeFileSync(v[2], newfile)
    print("extracted "..v[2])
  end
  fs.unlink(content.name)
end

function wrapper.writeFile(data, files)
  assert(fs.writeFileSync(files, table.concat(data)))
end

return wrapper
