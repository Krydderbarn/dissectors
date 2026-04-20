-- sci-cc/init.lua
-- SCI-CC dissector
--
-- Source: Eu.Doc.50 v4.3 (0.A)
-- This dissector plugs into SCI-Generic and dispatches
-- SCI-CC telegrams by Message Type.
--

----------------------------------------------------------------
-- Imports
----------------------------------------------------------------
local F    = require("sci_cc.fields")
local ENUM = require("sci_cc.enums")
local E    = require("sci_generic.expert")



local status_dispatch =
    require("SCI_lib.sci_cc.messages.status.init")

----------------------------------------------------------------
-- Message decoder table
----------------------------------------------------------------
local decoders = {
    [0x0040] = status_dispatch,  -- Status / Report Message
}

----------------------------------------------------------------
-- Fields
----------------------------------------------------------------
p_sci_cc.fields = F

----------------------------------------------------------------
-- Dissector
----------------------------------------------------------------
function p_sci_cc.dissector(buf, pktinfo, root)
    local pktlen = buf:len()

    pktinfo.cols.protocol:set("SCI-CC")

    local tree = root:add(p_sci_cc, buf(), "SCI-CC")

    ------------------------------------------------------------
    -- Message Type (Bytes 01..02, little endian)
    ------------------------------------------------------------
    if pktlen < 3 then
        tree:add_proto_expert_info(E.packet_too_short)
        return
    end

    local msg_type = buf:range(1,2):le_uint()
    tree:add_le(F.message_type, buf:range(1,2))

    ------------------------------------------------------------
    -- Info column
    ------------------------------------------------------------
    local msg_name = ENUM.MSG_TYPE[msg_type]
    if msg_name then
        pktinfo.cols.info:set("[SCI-CC] " .. msg_name)
    else
        pktinfo.cols.info:set(
            string.format("[SCI-CC] Unknown Message Type 0x%04X", msg_type)
        )
        tree:add_proto_expert_info(E.unknown_message_type)
        return
    end

    ------------------------------------------------------------
    -- Dispatch to message-specific decoder (if implemented)
    ------------------------------------------------------------
    local decode = decoders[msg_type]
    if decode then
        decode(buf, tree)
    end
end

----------------------------------------------------------------
-- Registration with SCI-Generic
----------------------------------------------------------------
-- SCI-CC Protocol Type = 0x70
-- (Eu.Doc.50 v4.3, byte 0)
--
DissectorTable
    .get("sci.protocol_type")
    :add(ENUM.PROTOCOL_TYPE, p_sci_cc)

print("SCI-CC dissector loaded")