-- sci-cc/messages/command/cancel_route.lua
-- SCI-CC Command: Cancel a Route
--
-- Message Type:       0x0050 / 0x0055
-- Information Type:   0x0C
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.3.2
--
print("LOADED: CMD cancel_route.lua")
print("=== package.preload ===")
for name, _ in pairs(package.preload) do
    print("  preload:", name)
end
print("=== end package.preload ===")

print("=== package.path ===")
print(package.path)
print("=== end package.path ===")


local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 66 must exist)
    ----------------------------------------------------------------
    if pktlen < 67 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- TAN (bytes 43..44)
    ----------------------------------------------------------------
    tree:add_le(F.tan, buf:range(43,2))

    ----------------------------------------------------------------
    -- Route ID or Signal / Signalling Point ID (bytes 46..65)
    ----------------------------------------------------------------
    ids.add(tree, F.route_id, buf:range(46,20))

    ----------------------------------------------------------------
    -- Route Preparation Instruction (byte 66)
    ----------------------------------------------------------------
    tree:add(F.route_preparation_instruction, buf:range(66,1))
end
