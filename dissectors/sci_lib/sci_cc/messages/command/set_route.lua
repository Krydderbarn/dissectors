-- sci-cc/messages/command/set_route.lua
-- SCI-CC Command: Set a Route
--
-- Message Type:       0x0050 / 0x0055
-- Information Type:   0x05
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.3.1
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 71 must exist)
    ----------------------------------------------------------------
    if pktlen < 72 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- TAN (bytes 43..44)
    ----------------------------------------------------------------
    tree:add_le(F.tan, buf:range(43,2))

    ----------------------------------------------------------------
    -- Information Type (byte 45) already handled by dispatcher
    ----------------------------------------------------------------

    ----------------------------------------------------------------
    -- Route ID (bytes 46..65)
    ----------------------------------------------------------------
    ids.add(tree, F.route_id, buf:range(46,20))

    ----------------------------------------------------------------
    -- Route Type (byte 66)
    ----------------------------------------------------------------
    tree:add(F.route_type, buf:range(66,1))

    ----------------------------------------------------------------
    -- Commanded State (byte 67)
    ----------------------------------------------------------------
    tree:add(F.commanded_state, buf:range(67,1))

    ----------------------------------------------------------------
    -- Overlap (byte 68)
    ----------------------------------------------------------------
    tree:add(F.overlap, buf:range(68,1))

    ----------------------------------------------------------------
    -- Flank Protection (byte 69)
    ----------------------------------------------------------------
    tree:add(F.flank_protection, buf:range(69,1))

    ----------------------------------------------------------------
    -- Electrified Destination (byte 70)
    ----------------------------------------------------------------
    tree:add(F.electrified_destination, buf:range(70,1))

    ----------------------------------------------------------------
    -- Command User (byte 71)
    ----------------------------------------------------------------
    tree:add(F.command_user, buf:range(71,1))
end
