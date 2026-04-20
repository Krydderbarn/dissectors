-- sci-cc/messages/status/line_block_status.lua
-- SCI-CC Status: Line Block Status
--
-- Message Type:       0x0040
-- Information Type:   0x1F
-- Source: Eu.Doc.50 v4.3 (0.A), §3.5.6.19
--

local F   = require("sci_cc.fields")
local E   = require("sci_generic.expert")
local ids = require("common.ids")

return function (buf, tree)
    local pktlen = buf:len()

    ----------------------------------------------------------------
    -- Minimum length check (byte 74 must exist)
    ----------------------------------------------------------------
    if pktlen < 75 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    ----------------------------------------------------------------
    -- Line Block ID (bytes 44..63)
    ----------------------------------------------------------------
    ids.add(tree, F.line_block_id, buf:range(44,20))

    ----------------------------------------------------------------
    -- Core state
    ----------------------------------------------------------------
    tree:add(F.active_control,          buf:range(64,1))
    tree:add(F.line_block_failed,       buf:range(65,1))
    tree:add(F.line_block_direction,    buf:range(66,1))
    tree:add(F.line_block_locked,       buf:range(67,1))
    tree:add(F.line_block_basic,        buf:range(68,1))

    ----------------------------------------------------------------
    -- Operational modifiers
    ----------------------------------------------------------------
    tree:add(F.line_block_change_dir,   buf:range(69,1))
    tree:add(F.line_block_bypass,        buf:range(70,1))
    tree:add(F.line_block_blocked_route, buf:range(71,1))
    tree:add(F.line_block_blocked_direction, buf:range(72,1))
    tree:add(F.line_block_repetition,    buf:range(73,1))
    tree:add(F.line_block_stored,        buf:range(74,1))
end