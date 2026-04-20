-- sci-cc/messages/status/init.lua
-- SCI-CC Status / Report Message (0x0040)
--

local F    = require("sci_cc.fields")
local E    = require("sci_generic.expert")
local ENUM = require("sci_cc.enums")

----------------------------------------------------------------
-- Track Section summary (example)
----------------------------------------------------------------
local function summarize_track_section(buf, pinfo)
    local id = buf:range(44,20):string():gsub("%z+$", "")
    local status = buf:range(64,1):uint()

    local parts = {}

    if status == 0x02 then
        table.insert(parts, "Occupied")
    elseif status == 0x01 then
        table.insert(parts, "Free")
    end

    -- EC blocking presence (coarse)
    if buf:len() >= 72 then
        table.insert(parts, "EC")
    end

    pinfo.cols.info:set(
        string.format(
            "Track Section %s: %s",
            id,
            table.concat(parts, ", ")
        )
    )
end

----------------------------------------------------------------
-- Powered Moveable Element summary
----------------------------------------------------------------
local function summarize_pme(buf, pinfo)
    -- PME ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Detected position (byte 67)
    if buf:len() >= 68 then
        local pos = buf:range(67,1):uint()
        if pos == 0x01 then
            table.insert(parts, "Normal")
        elseif pos == 0x02 then
            table.insert(parts, "Reverse")
        end
    end

    -- Used / Locked (byte 71)
    if buf:len() >= 72 then
        local used_locked = buf:range(71,1):uint()
        if used_locked ~= 0x00 then
            table.insert(parts, "Locked")
        end
    end

    -- EC blocking presence (bytes 101..106)
    if buf:len() >= 107 then
        table.insert(parts, "EC")
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "PME %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("PME %s", id)
        )
    end
end

----------------------------------------------------------------
-- Signal Status summary
----------------------------------------------------------------
local function summarize_signal(buf, pinfo)
    -- Signal / Signalling Point ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Signal state (byte 65)
    if buf:len() >= 66 then
        local state = buf:range(65,1):uint()

        if state == 0x00 then
            table.insert(parts, "Stop")
        elseif state == 0x01 then
            table.insert(parts, "Proceed")
        elseif state == 0x02 then
            table.insert(parts, "Dark")
        end
    end

    -- Route information present (byte 73)
    if buf:len() >= 74 then
        local route_info = buf:range(73,1):uint()
        if route_info ~= 0x00 then
            table.insert(parts, "Route")
        end
    end

    -- EC blocking presence (coarse)
    if buf:len() >= 99 then
        table.insert(parts, "EC")
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "Signal %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("Signal %s", id)
        )
    end
end

----------------------------------------------------------------
-- TVP Section Status summary
----------------------------------------------------------------
local function summarize_tvp(buf, pinfo)
    -- TVP Section ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- TVP failed (byte 65)
    if buf:len() >= 66 then
        local failed = buf:range(65,1):uint()
        if failed ~= 0x00 then
            table.insert(parts, "Failed")
        end
    end

    -- Occupied (byte 66)
    if buf:len() >= 67 then
        local occupied = buf:range(66,1):uint()
        if occupied ~= 0x00 then
            table.insert(parts, "Occupied")
        else
            table.insert(parts, "Free")
        end
    end

    -- Locked (byte 71)
    if buf:len() >= 72 then
        local locked = buf:range(71,1):uint()
        if locked ~= 0x00 then
            table.insert(parts, "Locked")
        end
    end

    -- EC blocking presence (bytes 107..112)
    if buf:len() >= 113 then
        table.insert(parts, "EC")
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "TVP %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("TVP %s", id)
        )
    end
end

----------------------------------------------------------------
-- Alarm / Alert / Event summary
----------------------------------------------------------------
local function summarize_alarm(buf, pinfo)
    -- Element ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Acknowledgement (byte 64)
    if buf:len() >= 65 then
        local ack = buf:range(64,1):uint()
        if ack == 0x02 then
            table.insert(parts, "Ack required")
        elseif ack == 0x03 then
            table.insert(parts, "Cleared")
        end
    end

    -- Fault code (byte 65)
    if buf:len() >= 66 then
        local fault = buf:range(65,1):uint()
        if fault ~= 0x00 and fault ~= 0xFF then
            table.insert(parts, string.format("Fault 0x%02X", fault))
        end
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "Alarm: %s – %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("Alarm: %s", id)
        )
    end
end

----------------------------------------------------------------
-- Line Block Status summary
----------------------------------------------------------------
local function summarize_line_block(buf, pinfo)
    -- Line Block ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Line Block failed (byte 65)
    if buf:len() >= 66 then
        local failed = buf:range(65,1):uint()
        if failed ~= 0x00 then
            table.insert(parts, "Failed")
        end
    end

    -- Direction (byte 66)
    if buf:len() >= 67 then
        local dir = buf:range(66,1):uint()
        if dir == 0x01 then
            table.insert(parts, "Dir A→B")
        elseif dir == 0x02 then
            table.insert(parts, "Dir B→A")
        end
    end

    -- Locked (byte 67)
    if buf:len() >= 68 then
        local locked = buf:range(67,1):uint()
        if locked ~= 0x00 then
            table.insert(parts, "Locked")
        end
    end

    -- Basic (byte 68)
    if buf:len() >= 69 then
        local basic = buf:range(68,1):uint()
        if basic ~= 0x00 then
            table.insert(parts, "Basic")
        end
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "Line Block %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("Line Block %s", id)
        )
    end
end

----------------------------------------------------------------
-- Diamond Crossing Status summary
----------------------------------------------------------------
local function summarize_diamond(buf, pinfo)
    -- Diamond Crossing ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Used / Locked (byte 66)
    if buf:len() >= 67 then
        local locked = buf:range(66,1):uint()
        if locked ~= 0x00 then
            table.insert(parts, "Locked")
        end
    end

    -- Occupied (byte 70)
    if buf:len() >= 71 then
        local occ = buf:range(70,1):uint()
        if occ ~= 0x00 then
            table.insert(parts, "Occupied")
        else
            table.insert(parts, "Free")
        end
    end

    -- EC blocking presence (bytes 93..98)
    if buf:len() >= 99 then
        table.insert(parts, "EC")
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "Diamond %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("Diamond %s", id)
        )
    end
end

----------------------------------------------------------------
-- Moveable Lockable Device Status summary
----------------------------------------------------------------
local function summarize_mld(buf, pinfo)
    -- Moveable Lockable Device ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Used / Locked (byte 66)
    if buf:len() >= 67 then
        local locked = buf:range(66,1):uint()
        if locked ~= 0x00 then
            table.insert(parts, "Locked")
        end
    end

    -- Occupied (byte 70)
    if buf:len() >= 71 then
        local occ = buf:range(70,1):uint()
        if occ ~= 0x00 then
            table.insert(parts, "Occupied")
        else
            table.insert(parts, "Free")
        end
    end

    -- EC blocking presence (bytes 93..98)
    if buf:len() >= 99 then
        table.insert(parts, "EC")
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "MLD %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("MLD %s", id)
        )
    end
end

----------------------------------------------------------------
-- Indicator Status summary
----------------------------------------------------------------
local function summarize_indicator(buf, pinfo)
    -- Indicator ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Indicator state (byte 65)
    if buf:len() >= 66 then
        local state = buf:range(65,1):uint()
        if state ~= 0x00 then
            table.insert(parts, "On")
        else
            table.insert(parts, "Off")
        end
    end

    -- EC blocking presence (bytes 91..96)
    if buf:len() >= 97 then
        table.insert(parts, "EC")
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "Indicator %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("Indicator %s", id)
        )
    end
end

----------------------------------------------------------------
-- Level Crossing Status summary
----------------------------------------------------------------
local function summarize_level_crossing(buf, pinfo)
    -- Level Crossing ID (bytes 44..63)
    local id = buf:range(44,20):string():gsub("%z+$", "")

    local parts = {}

    -- Activation (byte 67)
    if buf:len() >= 68 then
        local activation = buf:range(67,1):uint()
        if activation ~= 0x00 then
            table.insert(parts, "Active")
        else
            table.insert(parts, "Inactive")
        end
    end

    -- Barriers (byte 66)
    if buf:len() >= 67 then
        local barriers = buf:range(66,1):uint()
        if barriers ~= 0x00 then
            table.insert(parts, "Barriers Down")
        end
    end

    -- Obstruction (byte 79)
    if buf:len() >= 80 then
        local obstruction = buf:range(79,1):uint()
        if obstruction ~= 0x00 then
            table.insert(parts, "Obstruction")
        end
    end

    -- Failure (byte 89)
    if buf:len() >= 90 then
        local failure = buf:range(89,1):uint()
        if failure ~= 0x00 then
            table.insert(parts, "Failure")
        end
    end

    if #parts > 0 then
        pinfo.cols.info:set(
            string.format(
                "LC %s: %s",
                id,
                table.concat(parts, ", ")
            )
        )
    else
        pinfo.cols.info:set(
            string.format("LC %s", id)
        )
    end
end

----------------------------------------------------------------
-- Administrative summaries
----------------------------------------------------------------
local function summarize_status_update_started(_, pinfo)
    pinfo.cols.info:set("Status Update: Started")
end

local function summarize_status_update_completed(_, pinfo)
    pinfo.cols.info:set("Status Update: Completed")
end

local function summarize_fault_update_started(_, pinfo)
    pinfo.cols.info:set("Fault Report Update: Started")
end

local function summarize_fault_update_completed(_, pinfo)
    pinfo.cols.info:set("Fault Report Update: Completed")
end

----------------------------------------------------------------
-- Information Type decoder table
----------------------------------------------------------------
local decoders = {
    [0x01] = require("sci_cc.messages.status.route_status"),
    [0x02] = require("sci_cc.messages.status.sub_route_status"),
    [0x03] = require("sci_cc.messages.status.local_shunting_area_status"),
    [0x04] = require("sci_cc.messages.status.powered_moveable_element_status"),
    [0x05] = require("sci_cc.messages.status.signal_status"),
    [0x06] = require("sci_cc.messages.status.indicator_status"),
    [0x07] = require("sci_cc.messages.status.tvp_section_status"),
    [0x08] = require("sci_cc.messages.status.diamond_crossing_status"),
    [0x09] = require("sci_cc.messages.status.track_section_status"),
    -- rest unchanged
}

----------------------------------------------------------------
-- Summary dispatch table
----------------------------------------------------------------
local summaries = {
    [0x04] = summarize_pme,
    [0x05] = summarize_signal,
    [0x06] = summarize_indicator,
    [0x07] = summarize_tvp,
    [0x08] = summarize_diamond,
    [0x09] = summarize_track_section,
    [0x0A] = summarize_level_crossing,
    [0x1F] = summarize_line_block,
    [0x21] = summarize_alarm,
    [0x22] = summarize_mld,

-- Administrative
    [0x8A] = summarize_status_update_started,
    [0x8B] = summarize_status_update_completed,
    [0x8E] = summarize_fault_update_started,
    [0x8F] = summarize_fault_update_completed,
}


----------------------------------------------------------------
-- Decoder
----------------------------------------------------------------
return function (buf, pinfo, tree)
    local pktlen = buf:len()

    if pktlen < 44 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    local info_type = buf:range(43,1):uint()
    local info_name = ENUM.STATUS_INFO_TYPE[info_type]

    local info_item = tree:add(F.information_type, buf:range(43,1))

    if info_name then
        info_item:set_text("Status: " .. info_name)
    else
        info_item:set_text(
            string.format("Status: Unknown (0x%02X)", info_type)
        )
        tree:add_proto_expert_info(E.unknown_message_type)
        return
    end

    local decode = decoders[info_type]
    if decode then
        decode(buf, tree)
    end

    local summarize = summaries[info_type]
    if summarize then
        summarize(buf, pinfo)
    end
end