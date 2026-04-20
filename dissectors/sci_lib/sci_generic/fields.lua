-- SCI-Generic ProtoFields
-- Eu.Doc.93 – Interface specification SCI Generic
--
-- This file defines all generic SCI fields that are shared
-- across all SCI-X protocols (ILS, LS, RBC, CC, ...).
--
-- Fields defined here must be stable to preserve
-- Wireshark filter compatibility.
--

local F = {}

----------------------------------------------------------------
-- Generic SCI header fields
----------------------------------------------------------------

-- Byte 0
F.protocol_type = ProtoField.uint8(
    "sci.protocol_type",
    "Protocol Type",
    base.HEX
)

-- Bytes 1..2 (little endian)
F.message_type = ProtoField.uint16(
    "sci.message_type",
    "Message Type",
    base.HEX
)

-- Bytes 3..22
-- ISO IEC 8859-1:1998, left-aligned, space or NULL padded
F.sender_id = ProtoField.string(
    "sci.sender_id",
    "Sender Identifier"
)

-- Bytes 23..42
F.receiver_id = ProtoField.string(
    "sci.receiver_id",
    "Receiver Identifier"
)

----------------------------------------------------------------
-- Generic version handling (SCI-Generic concept)
----------------------------------------------------------------
-- Note:
-- The actual version handling logic is defined in SCI-Generic,
-- but the field is defined here to allow filtering and display.

F.pdi_version = ProtoField.uint8(
    "sci.pdi_version",
    "PDI Version",
    base.HEX
)

----------------------------------------------------------------
-- Generic flags / placeholders
----------------------------------------------------------------
-- These fields are intentionally generic and may be used
-- by multiple SCI-X protocols if required by Eu.Doc.93
-- or future extensions.

F.reserved = ProtoField.bytes(
    "sci.reserved",
    "Reserved / Padding"
)

----------------------------------------------------------------
-- Export
----------------------------------------------------------------
return F