-- MIT License
--
-- Copyright (c) 2021
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local my_info = {
    version = "1.0.0",
    description = "Dissector for SCI Generic (SCI-XX.PDI) protocol per EULYNX Eu.Doc.93 v3.3",
    repository = "https://github.com/Railway-CCS/dissectors"
}

set_plugin_info(my_info)

-----------------------------
---- SCI GENERIC PROTOCOL ---
-----------------------------


package.path = package.path .. ";../lua_lib/?.lua;../lua_lib/?/init.lua"
require("SCI")

local p_sci_generic = Proto("sci", "SCI Generic Protocol")


local SCI_HEADER_OFFSET   = 2   -- 2-byte packetization length prefix
local SCI_SENDER_OFFSET   = 5   -- prefix + protocol type + message type
local SCI_RECEIVER_OFFSET = 25  -- sender offset + 20 bytes
local SCI_PAYLOAD_OFFSET  = 45  -- receiver offset + 20 bytes
local SCI_MIN_LENGTH      = 45

-- Protocol Type value table
local vals_protocol_type = {
    [0x01] = "EI - Adjacent Interlocking",
    [0x20] = "EI - Train Detection System",
    [0x30] = "EI - Light Signal",
    [0x40] = "EI - Point",
    [0x50] = "EI - Radio Block Centre",
    [0x60] = "EI - Level Crossing",
    [0x70] = "EI - Traffic Control System",
    [0x90] = "EI - Generic IO",
    [0xC0] = "EI - External Level Crossing"
}

-- Generic message type value table (shared across all SCI-XX protocols)
local vals_message_type = {
    [0x0024] = "PDI-Version Check",
    [0x0025] = "PDI-Version Check Response",
    [0x0021] = "Initialisation Request",
    [0x0022] = "Start Initialisation",
    [0x0026] = "Status Report Completed",
    [0x0023] = "Initialisation Completed",
    [0x0027] = "Close PDI",
    [0x0028] = "Release PDI for Maintenance",
    [0x0029] = "PDI Available",
    [0x002A] = "PDI Not Available",
    [0x002B] = "Reset PDI"
}

-- Close reason value table (0x0027)
local vals_close_reason = {
    [0x01] = "Protocol error",
    [0x02] = "Formal telegram error",
    [0x03] = "Content telegram error",
    [0x04] = "Normal close",
    [0x05] = "Other version required",
    [0x06] = "Timeout",
    [0x07] = "Checksum mismatch"
}

-- Reset reason value table (0x002B)
local vals_reset_reason = {
    [0x01] = "Protocol error",
    [0x02] = "Formal telegram error",
    [0x03] = "Content telegram error"
}

local vals_has_reason = {
    [0x0027] = vals_close_reason,
    [0x002B] = vals_reset_reason,
}

-- PDI version check result value table (0x0025)
local vals_version_result = {
    [0x01] = "PDI-Versions do not match",
    [0x02] = "PDI-Versions match"
}

-- Header fields
local f_protocol_type   = ProtoField.uint8("sci.protocol_type",  "Protocol Type",       base.HEX, vals_protocol_type)
local f_message_type    = ProtoField.uint16("sci.message_type",  "Message Type",        base.HEX, vals_message_type)
local f_sender_id       = ProtoField.string("sci.sender_id",     "Sender Identifier",   base.UNICODE)
local f_receiver_id     = ProtoField.string("sci.receiver_id",   "Receiver Identifier", base.UNICODE)

-- PDI-Version Check (0x0024) fields
local f_pdi_version_sender   = ProtoField.uint8("sci.pdi_version_sender", "PDI-Version of Sender", base.HEX)

-- PDI-Version Check Response (0x0025) fields
local f_pdi_version_result   = ProtoField.uint8("sci.pdi_version_result",   "Result PDI-Version Check", base.HEX, vals_version_result)
local f_pdi_version_receiver = ProtoField.uint8("sci.pdi_version_receiver", "Receiver PDI-Version",       base.HEX)
local f_checksum_length      = ProtoField.uint8("sci.checksum_length",      "Checksum Length")
local f_checksum_data        = ProtoField.bytes("sci.checksum_data",        "Checksum Data")

-- Close PDI (0x0027) fields
local f_close_reason    = ProtoField.uint8("sci.close_reason",  "Close Reason",  base.HEX, vals_close_reason)

-- Reset PDI (0x002B) fields
local f_reset_reason    = ProtoField.uint8("sci.reset_reason",  "Reset Reason",  base.HEX, vals_reset_reason)

-- Expert info
local ef_unknown_protocol = ProtoExpert.new("sci.expert.unknown_protocol", "Unknown SCI protocol type",  expert.group.PROTOCOL,  expert.severity.WARN)
local ef_unknown_message  = ProtoExpert.new("sci.expert.unknown_message",  "Unknown SCI message type",   expert.group.PROTOCOL,  expert.severity.WARN)
local ef_too_short        = ProtoExpert.new("sci.expert.too_short",        "Packet too short",           expert.group.MALFORMED, expert.severity.ERROR)

p_sci_generic.fields = {
    f_protocol_type,
    f_message_type,
    f_sender_id,
    f_receiver_id,
    f_pdi_version_sender,
    f_pdi_version_result,
    f_pdi_version_receiver,
    f_checksum_length,
    f_checksum_data,
    f_close_reason,
    f_reset_reason
}

p_sci_generic.experts = {
    ef_unknown_protocol,
    ef_unknown_message,
    ef_too_short
}

-- Sub-dissector table for protocol-specific dissectors (sci-ls, sci-p etc.)
local sci_subdissector_table = DissectorTable.new("sci.protocol_type", "SCI Protocol Type", ftypes.UINT8, base.HEX)

function p_sci_generic.dissector(buf, pktinfo, root)
    
    local pktlen = buf:reported_length_remaining()

    if pktlen < SCI_MIN_LENGTH then
        local tree = root:add(p_sci_generic, buf())
        tree:add_proto_expert_info(ef_too_short, "Packet is " .. pktlen .. " bytes, minimum is " .. SCI_MIN_LENGTH)
        return
    end

    pktinfo.cols.protocol:set("SCI")

    local tree = root:add(p_sci_generic, buf(), "SCI Generic Protocol")

    -- Protocol Type
    local protocol_type = buf:range(SCI_HEADER_OFFSET, 1):uint()
    tree:add(f_protocol_type, buf:range(SCI_HEADER_OFFSET, 1))

    -- Message Type
    local message_type = buf:range(SCI_HEADER_OFFSET + 1, 2):le_uint()
    tree:add_le(f_message_type, buf:range(SCI_HEADER_OFFSET + 1, 2))

    -- Sender Identifier
    local sender_id = buf:range(SCI_SENDER_OFFSET, 20):string()
    tree:add(f_sender_id, buf:range(SCI_SENDER_OFFSET, 20))

    -- Receiver Identifier
    local receiver_id = buf:range(SCI_RECEIVER_OFFSET, 20):string()
    tree:add(f_receiver_id, buf:range(SCI_RECEIVER_OFFSET, 20))

    -- Expert info
    if not vals_protocol_type[protocol_type] then
        tree:add_proto_expert_info(ef_unknown_protocol,
            string.format("Unknown protocol type: 0x%02X", protocol_type))
    end

    if not vals_message_type[message_type] then
        tree:add_proto_expert_info(ef_unknown_message,
            string.format("Unknown message type: 0x%04X", message_type))
    end

    -- Per message type payload parsing
    if pktlen > SCI_PAYLOAD_OFFSET then
        if message_type == 0x0024 then
            tree:add(f_pdi_version_sender, buf:range(SCI_PAYLOAD_OFFSET, 1))

        elseif message_type == 0x0025 then
            tree:add(f_pdi_version_result,   buf:range(SCI_PAYLOAD_OFFSET, 1))
            tree:add(f_pdi_version_receiver, buf:range(SCI_PAYLOAD_OFFSET + 1, 1))
            tree:add(f_checksum_length,      buf:range(SCI_PAYLOAD_OFFSET + 2, 1))
            local checksum_len = buf:range(SCI_PAYLOAD_OFFSET + 2, 1):uint()
            if checksum_len > 0 then
                tree:add(f_checksum_data, buf:range(SCI_PAYLOAD_OFFSET + 3, checksum_len))
            end

        elseif message_type == 0x0027 then
            tree:add(f_close_reason, buf:range(SCI_PAYLOAD_OFFSET, 1))

        elseif message_type == 0x002B then
            tree:add(f_reset_reason, buf:range(SCI_PAYLOAD_OFFSET, 1))
        end
    end

    -- Info column
    local msg_str      = vals_message_type[message_type] or string.format("0x%04X", message_type)
    local sender_str   = sender_id:match("^%s*(.-)%s*$")
    local receiver_str = receiver_id:match("^%s*(.-)%s*$")

    local reason_table = vals_has_reason[message_type]
    if reason_table then
        local reason     = buf:range(SCI_PAYLOAD_OFFSET, 1):uint()
        local reason_str = reason_table[reason] or ("reason=0x" .. string.format("%02X", reason))
        pktinfo.cols.info:set(string.format("[%s] %s → %s  (%s)",
            msg_str, sender_str, receiver_str, reason_str))
    else
        pktinfo.cols.info:set(string.format("[%s] %s → %s",
            msg_str, sender_str, receiver_str))
    end

    -- Hand off to protocol-specific sub-dissector
    if pktlen > SCI_PAYLOAD_OFFSET then
        sci_subdissector_table:try(protocol_type, buf:range(SCI_PAYLOAD_OFFSET, pktlen - SCI_PAYLOAD_OFFSET):tvb(), pktinfo, root)
    end
end

print("SCI subdissectors:", DissectorTable.get("sci.protocol_type"))