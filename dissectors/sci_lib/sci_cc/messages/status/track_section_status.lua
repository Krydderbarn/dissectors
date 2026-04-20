-- sci-cc/messages/status/track_section_status.lua
-- SCI-CC Track Section Status
--
-- Message Type:       0x0040 (Status / Report)
-- Information Type:   0x09
-- Source: Eu.Doc.50 v4.3 (0.A)
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")
local decode_ec_blocking = require("sci_cc.messages.common.ec_blocking")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check
    -- Byte 64 must exist (track section status)
    ----------------------------------------------------------------
    if pktlen < 65 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Track Section ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.track_section_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Track Section Status (byte 64)
    ----------------------------------------------------------------
    tree:add(F.track_section_status, buf:range(64,1))

    ----------------------------------------------------------------
    -- Disturbance / Fault Status (byte 65)
    ----------------------------------------------------------------
    if pktlen >= 66 then
        tree:add(F.disturbance_status, buf:range(65,1))
    end

    ----------------------------------------------------------------
    -- EC Route Blocking (bytes 66..71)
    ----------------------------------------------------------------
    if pktlen >= 72 then
        decode_ec_blocking(buf, tree, 66)
    end
end