-- SCI-Generic Expert Info
-- Eu.Doc.93 – Interface specification SCI Generic
--
-- This file defines reusable Expert Info objects
-- for all SCI protocols (ILS, LS, RBC, CC, ...).
--

local E = {}

----------------------------------------------------------------
-- Malformed / length related expert infos
----------------------------------------------------------------

E.packet_too_short = ProtoExpert.new(
    "sci.expert.packet_too_short",
    "SCI packet too short",
    expert.group.MALFORMED,
    expert.severity.ERROR
)

E.header_too_short = ProtoExpert.new(
    "sci.expert.header_too_short",
    "SCI header too short",
    expert.group.MALFORMED,
    expert.severity.ERROR
)

E.payload_too_short = ProtoExpert.new(
    "sci.expert.payload_too_short",
    "SCI payload shorter than expected for this message type",
    expert.group.MALFORMED,
    expert.severity.WARN
)

----------------------------------------------------------------
-- Unsupported / unknown values
----------------------------------------------------------------

E.unknown_protocol_type = ProtoExpert.new(
    "sci.expert.unknown_protocol_type",
    "Unknown SCI Protocol Type",
    expert.group.PROTOCOL,
    expert.severity.WARN
)

E.unknown_message_type = ProtoExpert.new(
    "sci.expert.unknown_message_type",
    "Unknown SCI Message Type",
    expert.group.PROTOCOL,
    expert.severity.WARN
)

----------------------------------------------------------------
-- Version handling / compatibility
----------------------------------------------------------------

E.unsupported_pdi_version = ProtoExpert.new(
    "sci.expert.unsupported_pdi_version",
    "Unsupported or unknown SCI PDI version",
    expert.group.PROTOCOL,
    expert.severity.WARN
)

----------------------------------------------------------------
-- Export
----------------------------------------------------------------
return E