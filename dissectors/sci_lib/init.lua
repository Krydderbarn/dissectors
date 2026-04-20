-- SCI_lib/init.lua
-- Root initializer for SCI library

local sep = package.config:sub(1,1)
local src = debug.getinfo(1, "S").source:sub(2)
local base = src:match("(.*" .. sep .. ")")

if not base then
    error("SCI_lib/init.lua: cannot determine base directory")
end

-- Add SCI_lib as the module root
package.path =
      base .. "?.lua;"
    .. base .. "?/init.lua;"
    .. package.path

print("SCI_lib initialized, base =", base)
