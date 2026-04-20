-- sci-cc/messages/status/indicator_status.lua
-- SCI-CC Status: Indicator Status
--
-- Message Type:       0x0040
-- Information Type:   0x06
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.6.25
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")
local decode_ec_blocking = require("sci_cc.messages.common.ec_blocking")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 96 must exist)
    ----------------------------------------------------------------
    if pktlen < 97 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Indicator ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.indicator_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Core state
    ----------------------------------------------------------------
    tree:add(F.active_control,  buf:range(64,1))
    tree:add(F.indicator_state, buf:range(65,1))

    ----------------------------------------------------------------
    -- Route interaction
    ----------------------------------------------------------------
    tree:add(F.route_type,   buf:range(66,1))
    tree:add(F.overlap_type, buf:range(67,1))

    ----------------------------------------------------------------
    -- Track interaction
    ----------------------------------------------------------------
    tree:add(F.occupied,   buf:range(68,1))
    tree:add(F.fragmented, buf:range(69,1))

    ----------------------------------------------------------------
    -- OHL groupset
    ----------------------------------------------------------------
    tree:add(F.ohl_groupset_applicability, buf:range(70,1))
    ids.add(tree, F.ohl_groupset_id, buf:range(71,20))

    
    ----------------------------------------------------------------
    -- EC Route Blocking (bytes 91..96)
    ----------------------------------------------------------------
    if pktlen >= 97 then
        decode_ec_blocking(buf, tree, 91)
    end

end