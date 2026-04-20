-- sci-cc/messages/status/powered_moveable_element_status.lua
-- SCI-CC Status: Powered Moveable Element Status
--
-- Message Type:       0x0040
-- Information Type:   0x04
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.6.14
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")
local decode_ec_blocking = require("sci_cc.messages.common.ec_blocking")

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
    -- Powered Moveable Element ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.pme_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Core command and detection state
    ----------------------------------------------------------------
    tree:add(F.active_control,   buf:range(64,1))
    tree:add(F.tcs_commanded,    buf:range(65,1))
    tree:add(F.ils_commanded,    buf:range(66,1))
    tree:add(F.detected_position,buf:range(67,1))

    ----------------------------------------------------------------
    -- Blocking and locking
    ----------------------------------------------------------------
    tree:add(F.blocked_moving,        buf:range(68,1))
    tree:add(F.blocked_route_setting, buf:range(69,1))
    tree:add(F.maintainer_blocked,    buf:range(70,1))
    tree:add(F.used_locked,            buf:range(71,1))

    ----------------------------------------------------------------
    -- Protection and route interaction
    ----------------------------------------------------------------
    tree:add(F.flank_protection, buf:range(72,1))
    tree:add(F.flank_receive,    buf:range(73,1))
    tree:add(F.route_type,       buf:range(74,1))
    tree:add(F.overlap_type,     buf:range(75,1))

    ----------------------------------------------------------------
    -- Track interaction
    ----------------------------------------------------------------
    tree:add(F.occupied,   buf:range(76,1))
    tree:add(F.fragmented, buf:range(77,1))
    tree:add(F.fouled,     buf:range(78,1))

    ----------------------------------------------------------------
    -- Maintenance / defaults
    ----------------------------------------------------------------
    tree:add(F.reminder_default, buf:range(79,1))

    ----------------------------------------------------------------
    -- OHL groupset
    ----------------------------------------------------------------
    tree:add(F.ohl_groupset_applicability, buf:range(80,1))
    ids.add(tree, F.ohl_groupset_id, buf:range(81,20))
    
    ----------------------------------------------------------------
    -- EC Route Blocking (bytes 101..106)
    ----------------------------------------------------------------
    if pktlen >= 107 then
        decode_ec_blocking(buf, tree, 101)
    end

    ----------------------------------------------------------------
    -- Prepared route
    ----------------------------------------------------------------
    tree:add(F.prepared_route_type_position, buf:range(107,1))
end