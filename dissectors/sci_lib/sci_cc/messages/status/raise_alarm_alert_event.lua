-- sci-cc/messages/status/raise_alarm_alert_event.lua
-- SCI-CC Status: Raise Alarm / Alert / Event
--
-- Message Type:       0x0040
-- Information Type:   0x21
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.4.7
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 107 must exist)
    ----------------------------------------------------------------
    if pktlen < 108 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Element ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.alarm_element_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Alarm meta data
    ----------------------------------------------------------------
    tree:add(F.alarm_acknowledgement, buf:range(64,1))
    tree:add(F.alarm_fault_code,      buf:range(65,1))

    ----------------------------------------------------------------
    -- Description (bytes 66..107)
    ----------------------------------------------------------------
    tree:add(F.alarm_description, buf:range(66,42))
end
