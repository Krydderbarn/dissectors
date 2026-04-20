-- sci-cc/messages/command/init.lua
-- SCI-CC Command Message (0x0050 / 0x0055)
--

local F    = require("sci_cc.fields")
local E    = require("sci_generic.expert")
local ENUM = require("sci_cc.enums")

----------------------------------------------------------------
-- Information Type decoder table
----------------------------------------------------------------
----------------------------------------------------------------
-- Command Information Type dispatch (Message Type 0x0050 / 0x0055)
----------------------------------------------------------------
local decoders = {
    [0x04] = require("sci_cc.messages.command.cancel_or_extend_overlap"),
    [0x05] = require("sci_cc.messages.command.set_route"),
    [0x0C] = require("sci_cc.messages.command.cancel_route"),
    [0x0D] = require("sci_cc.messages.command.cancel_route_cooperative_shortening"),
    [0x17] = require("sci_cc.messages.command.operate_powered_moveable_element"),
    [0x1A] = require("sci_cc.messages.command.manage_powered_moveable_element"),
    [0x21] = require("sci_cc.messages.command.manage_signal"),
    [0x28] = require("sci_cc.messages.command.manage_field_element_pdi_connection"),
    [0x2A] = require("sci_cc.messages.command.manage_tvp_section"),
    [0x2B] = require("sci_cc.messages.command.manage_track_section"),
    [0x3D] = require("sci_cc.messages.command.manage_level_crossing"),
    [0x3E] = require("sci_cc.messages.command.operate_level_crossing"),
    [0x3F] = require("sci_cc.messages.command.manage_static_lockable_device"),
    [0x44] = require("sci_cc.messages.command.operate_moveable_lockable_device"),
    [0x4C] = require("sci_cc.messages.command.manage_auxiliary_object"),
    [0x58] = require("sci_cc.messages.command.manage_overrun_detection"),
    [0x67] = require("sci_cc.messages.command.manage_point_heater"),
    [0x68] = require("sci_cc.messages.command.manage_line_block"),
    [0x7B] = require("sci_cc.messages.command.display_reminders_and_blocking"),
    [0x7F] = require("sci_cc.messages.command.acknowledge_alarm_or_alert"),
    [0x87] = require("sci_cc.messages.command.cancel_residual_route"),
    [0x88] = require("sci_cc.messages.command.apply_tws_protection"),
    [0x94] = require("sci_cc.messages.command.apply_ec_route_blocking"),
    [0x95] = require("sci_cc.messages.command.remove_ec_route_blocking"),
    [0x96] = require("sci_cc.messages.command.set_predefined_obstruction"),
    [0x99] = require("sci_cc.messages.command.generic_latches"),
}
----------------------------------------------------------------
-- Decoder
----------------------------------------------------------------
return function (buf, tree)
    local pktlen = buf:len()

    ------------------------------------------------------------
    -- Information Type is at byte 45 (SCI-CC command)
    ------------------------------------------------------------
    if pktlen < 46 then
        tree:add_proto_expert_info(E.payload_too_short)
        return
    end

    local info_type = buf:range(45,1):uint()
    local info_name = ENUM.COMMAND_INFO_TYPE[info_type]

    ------------------------------------------------------------
    -- Information Type field (human-readable)
    ------------------------------------------------------------
    local info_item = tree:add(F.information_type, buf:range(45,1))

    if info_name then
        info_item:set_text("Command: " .. info_name)
    else
        info_item:set_text(
            string.format("Command: Unknown (0x%02X)", info_type)
        )
        tree:add_proto_expert_info(E.unknown_message_type)
        return
    end

    ------------------------------------------------------------
    -- Dispatch to command-specific decoder
    ------------------------------------------------------------
    local decode = decoders[info_type]
    if decode then
        decode(buf, tree)
    end
end