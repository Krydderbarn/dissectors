-- sci-cc/messages/status/tvp_section_status.lua
-- SCI-CC Status: TVP Section Status
--
-- Message Type:       0x0040
-- Information Type:   0x07
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.6.15
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")
local decode_ec_blocking = require("sci_cc.messages.common.ec_blocking")

    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 112 must exist)
    ----------------------------------------------------------------
    if pktlen < 113 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- TVP Section ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.tvp_section_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Core TVP state
    ----------------------------------------------------------------
    tree:add(F.active_control, buf:range(64,1))
    tree:add(F.tvp_failed,     buf:range(65,1))
    tree:add(F.tvp_occupied,   buf:range(66,1))
    tree:add(F.tvp_restriction_fc, buf:range(68,1))

    ----------------------------------------------------------------
    -- Force Clear diagnostics
    ----------------------------------------------------------------
    tree:add(F.tvp_fc_failed,  buf:range(72,1))
    tree:add(F.tvp_fc_counter, buf:range(83,1))

    ----------------------------------------------------------------
    -- Filling level (bytes 81..82, signed)
    ----------------------------------------------------------------
    tree:add_le(F.tvp_filling_level, buf:range(81,2))

        
    ----------------------------------------------------------------
    -- EC Route Blocking (bytes 107..112)
    ----------------------------------------------------------------
    if pktlen >= 113 then
        decode_ec_blocking(buf, tree, 107)
    end

    return function (buf, tree)
end
