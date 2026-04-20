-- SCI-Generic dissector sci_generic/init.lua
-- Eu.Doc.93 – Interface specification SCI Generic
--
-- Responsibilities:
--  - Decode generic SCI header
--  - Dispatch to SCI-X protocols (ILS, LS, RBC, CC, ...)
--  - Register as RaSTA payload dissector
--

-- require("SCI")
-- local p_sci_generic = Proto("sci", "SCI Generic Protocol")

----------------------------------------------------------------
-- Imports
----------------------------------------------------------------
local F = require("SCI_lib.sci_generic.fields")
local E = require("SCI_lib.sci_generic.expert")

----------------------------------------------------------------
-- SCI-X dissector table (Protocol Type based)
----------------------------------------------------------------
-- SCI-X dissectors register here, e.g.:
--   DissectorTable.get("sci.protocol_type"):add(0x01, p_sci_ils)
--
local sci_proto_table = DissectorTable.new(
    "sci.protocol_type",
    "SCI Protocol Type",
    ftypes.UINT8,
    base.HEX
)

----------------------------------------------------------------
-- Fields & Expert Infos
----------------------------------------------------------------
p_sci.fields = F

p_sci.experts = {
    E.packet_too_short,
    E.header_too_short,
    E.payload_too_short,
    E.unknown_protocol_type,
    E.unknown_message_type,
    E.unsupported_pdi_version
}

----------------------------------------------------------------
-- Dissector
----------------------------------------------------------------
function p_sci.dissector(buf, pktinfo, root)
    local pktlen = buf:len()

    ------------------------------------------------------------
    -- Minimum sanity check
    ------------------------------------------------------------
    if pktlen < 3 then
        local tree = root:add(p_sci, buf(), "SCI Generic")
        tree:add_proto_expert_info(E.packet_too_short)
        return
    end

    pktinfo.cols.protocol:set("SCI")

    local tree = root:add(p_sci, buf(), "SCI Generic")

    ------------------------------------------------------------
    -- Byte 0: Protocol Type
    ------------------------------------------------------------
    local proto_type = buf:range(0,1):uint()
    tree:add(F.protocol_type, buf:range(0,1))

    ------------------------------------------------------------
    -- Bytes 1..2: Message Type (little endian)
    ------------------------------------------------------------
    local msg_type = buf:range(1,2):le_uint()
    tree:add_le(F.message_type, buf:range(1,2))

    ------------------------------------------------------------
    -- Bytes 3..42: Sender / Receiver Identifiers
    ------------------------------------------------------------
    if pktlen < 43 then
        tree:add_proto_expert_info(E.header_too_short)
        return
    end

    tree:add(F.sender_id,   buf:range(3,20))
    tree:add(F.receiver_id, buf:range(23,20))

    ------------------------------------------------------------
    -- Dispatch to SCI-X protocol
    ------------------------------------------------------------
    local sub = sci_proto_table:get_dissector(proto_type)

    if sub then
        -- SCI-X dissectors expect absolute offsets
        sub:call(buf, pktinfo, root)
    else
        tree:add_proto_expert_info(E.unknown_protocol_type)
        pktinfo.cols.info:set(
            string.format("Unknown SCI Protocol Type 0x%02X", proto_type)
        )
    end
end

----------------------------------------------------------------
-- Registration to RaSTA payload
----------------------------------------------------------------
-- RaSTA provides the SCI payload (Safety Layer Data)
-- SCI registers itself as a RaSTA payload dissector.
--
-- This avoids postdissectors and preserves protocol layering.
--

local rasta_payload_table = DissectorTable.get("rasta.payload")
if rasta_payload_table then
    rasta_payload_table:add("SCI", p_sci)
end

print("SCI-Generic dissector loaded and registered to RaSTA payload")