-- sci-cc/messages/status/route_status.lua
-- SCI-CC Status: Route Status
--
-- Message Type:       0x0040
-- Information Type:   0x01
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.3.6
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 73 must exist)
    ----------------------------------------------------------------
    if pktlen < 74 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Route ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.route_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Route core state
    ----------------------------------------------------------------
    tree:add(F.route_type,  buf:range(64,1))
    tree:add(F.route_state, buf:range(65,1))

    ----------------------------------------------------------------
    -- Route state diagnostics
    ----------------------------------------------------------------
    tree:add(F.route_state_message,     buf:range(66,1))
    tree:add(F.route_state_description, buf:range(67,1))

    ----------------------------------------------------------------
    -- Overlap related
    ----------------------------------------------------------------
    tree:add(F.overlap_state,         buf:range(68,1))
    tree:add(F.overlap_state_message, buf:range(69,1))
    tree:add(F.overlap_release_timer, buf:range(70,1))

    ----------------------------------------------------------------
    -- Residual / approach handling
    ----------------------------------------------------------------
    tree:add(F.residual_route_timer, buf:range(71,1))
    tree:add(F.approach_zone,        buf:range(72,1))
    tree:add(F.route_delay,          buf:range(73,1))
end