-- sci-cc/messages/status/overrun_alarm.lua
-- SCI-CC Status: Overrun Alarm
--
-- Message Type:       0x0040
-- Information Type:   0x23
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.5.4
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 83 must exist)
    ----------------------------------------------------------------
    if pktlen < 84 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Affected Signal / Signalling Point ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.overrun_signal_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Affected TVP Section ID (bytes 64..83)
    ----------------------------------------------------------------
    ids.add(tree, F.overrun_tvp_section_id, buf:range(64,20))
end
