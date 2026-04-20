
-- sci-cc/enums.lua
--
-- Enumerations for SCI-CC
-- Source: Eu.Doc.50 v4.3 (0.A), Section 3.4.1
--

local ENUM = {}

----------------------------------------------------------------
-- SCI-CC Protocol Type
----------------------------------------------------------------
-- Byte 0
ENUM.PROTOCOL_TYPE = 0x70

----------------------------------------------------------------
-- SCI-CC Message Types (Bytes 01..02, little endian)
----------------------------------------------------------------
-- These define the telegram class.
--
-- Commands, confirmations, and status messages are
-- distinguished primarily by Message Type.
--

ENUM.MSG_TYPE = {
    [0x0030] = "Request Confirmation of Command",
    [0x0035] = "Command Rejected",
    [0x0040] = "Status / Report Message",
    [0x0044] = "Command Accepted",
    [0x0045] = "Request Confirmation with Safety Codes",
    [0x0050] = "Command",
    [0x0055] = "Command Confirmation",
    [0x0060] = "Confirmation of Command with Safety Codes",
    [0x0065] = "Abort Command",
    [0x0070] = "Set Signal or Area to Stop",
    [0x0075] = "Unconditional Emergency Stop",
    [0x0080] = "Barrier Stop",
}

----------------------------------------------------------------
-- SCI-CC Command Information Types
-- Source: Eu.Doc.50 v4.3 (0.A)
-- Applies to Message Types:
--   0x0050 (Command)
--   0x0055 (Command Confirmation)
----------------------------------------------------------------

ENUM.COMMAND_INFO_TYPE = {
    [0x04] = "Cancel or Extend an Overlap",
    [0x05] = "Set a Route",
    [0x0C] = "Cancel a Route",
    [0x0D] = "Cancel Route with Co-operative Shortening",
    [0x17] = "Operate a Powered Moveable Element",
    [0x1A] = "Manage a Powered Moveable Element",
    [0x21] = "Manage a Signal / Signalling Point / Area",
    [0x28] = "Manage Field Element PDI Connection",
    [0x2A] = "Manage a TVP Section",
    [0x2B] = "Manage a Track Section",
    [0x3D] = "Manage a Level Crossing",
    [0x3E] = "Operate a Level Crossing",
    [0x3F] = "Manage a Static Lockable Device",
    [0x44] = "Operate a Moveable Lockable Device",
    [0x4C] = "Manage an Auxiliary Object",
    [0x58] = "Manage Overrun Detection",
    [0x67] = "Manage a Point Heater",
    [0x68] = "Manage a Line Block Between Signalling Areas",
    [0x7B] = "Display All Reminders and Blocking",
    [0x7F] = "Acknowledge Alarm or Alert",
    [0x87] = "Cancel Residual Route",
    [0x88] = "Apply Trackworker Safety System Protection",
    [0x94] = "Apply EC Route Blocking",
    [0x95] = "Remove EC Route Blocking",
    [0x96] = "Set Predefined Obstruction",
    [0x99] = "Generic Latches / Bit States",
}

----------------------------------------------------------------
-- Reverse lookup (optional, useful for tests/tools)
----------------------------------------------------------------
ENUM.MSG_TYPE_BY_NAME = {
    ["Request Confirmation of Command"]      = 0x0030,
    ["Command Rejected"]                     = 0x0035,
    ["Status / Report Message"]              = 0x0040,
    ["Command Accepted"]                     = 0x0044,
    ["Request Confirmation with Safety Codes"]= 0x0045,
    ["Command"]                              = 0x0050,
    ["Command Confirmation"]                 = 0x0055,
    ["Confirmation of Command with Safety Codes"] = 0x0060,
    ["Abort Command"]                        = 0x0065,
    ["Set Signal or Area to Stop"]            = 0x0070,
    ["Unconditional Emergency Stop"]          = 0x0075,
    ["Barrier Stop"]                         = 0x0080,
}


-- Information Types for Message Type 0x0040 (Status / Report)
ENUM.STATUS_INFO_TYPE = {
    [0x01] = "Route Status",
    [0x02] = "Sub-Route Status",
    [0x03] = "Local Shunting Area Status",
    [0x04] = "Powered Moveable Element Status",
    [0x05] = "Signal Status",
    [0x06] = "Indicator Status",
    [0x07] = "TVP Section Status",
    [0x08] = "Diamond Crossing Status",
    [0x09] = "Track Section Status",
    [0x0A] = "Level Crossing Status",
    [0x0C] = "Static Lockable Device Status",
    [0x0D] = "Auxiliary Object Status",
    [0x0E] = "Point Heater Status",
    [0x0F] = "Request Luminosity Change",
    [0x10] = "Automatic Route Setting Area Status",
    [0x12] = "TSR Status Report",
    [0x13] = "Request to Activate TSR",
    [0x14] = "Train Data Report",
    [0x16] = "Train Request",
    [0x17] = "Train Definition Deleted",
    [0x19] = "Local or Remote Control Status",
    [0x1A] = "Signal Luminosity Group Status",
    [0x1B] = "Emergency Stop Area Status",
    [0x1C] = "Emergency Stop Message Response",
    [0x1D] = "Working Area Status",
    [0x1E] = "Co-operative Shortening Status",
    [0x1F] = "Line Block Status",
    [0x20] = "Generic Latches / Bit States",
    [0x21] = "Raise Alarm or Alert or Event",
    [0x22] = "Moveable Lockable Device Status",
    [0x23] = "Overrun Alarm",
    [0x25] = "Train Position, Speed and Status Report",
    [0x26] = "EC Blocking Text",
    [0x27] = "Predefined Obstruction Status",
    [0x29] = "Field Element PDI Connection Status",
    [0x2D] = "By-pass Area Status",
    [0x7E] = "Signal Area Status",
    [0x8A] = "Update of All Statuses Started",
    [0x8B] = "Update of All Statuses Completed",
    [0x8E] = "Update of Disturbance and Fault Reports Started",
    [0x8F] = "Update of Disturbance and Fault Reports Completed",
}

----------------------------------------------------------------
-- Export
----------------------------------------------------------------
return ENUM
