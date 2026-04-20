-- sci-cc/messages/status/signal_status.lua
-- SCI-CC Status: Signal Status
--
-- Message Type:       0x0040
-- Information Type:   0x05
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.5.3
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 104 must exist)
    ----------------------------------------------------------------
    if pktlen < 105 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Signal ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.signal_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Core signal state
    ----------------------------------------------------------------
    tree:add(F.active_control, buf:range(64,1))
    tree:add(F.signal_state,  buf:range(65,1))

    ----------------------------------------------------------------
    -- Aspect information
    ----------------------------------------------------------------
    tree:add(F.basic_aspect,    buf:range(66,1))
    tree:add(F.extended_aspect, buf:range(67,1))

    ----------------------------------------------------------------
    -- Route / indication related
    ----------------------------------------------------------------
    tree:add(F.route_info, buf:range(73,1))

    ----------------------------------------------------------------
    -- Stop / control related
    ----------------------------------------------------------------
    tree:add(F.reason_stop,    buf:range(84,1))
    tree:add(F.aspect_control, buf:range(85,1))
    tree:add(F.automatic_mode, buf:range(87,1))

    ----------------------------------------------------------------
    -- Lamp and indication state
    ----------------------------------------------------------------
    tree:add(F.lamp_state,          buf:range(92,1))
    tree:add(F.failed_lamp_position,buf:range(93,1))
end