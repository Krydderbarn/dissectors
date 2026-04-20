-- sci-cc/fields.lua
-- ProtoFields for SCI-CC
--

local F = {}

----------------------------------------------------------------
-- SCI-CC header fields
----------------------------------------------------------------

F.message_type = ProtoField.uint16(
    "sci.cc.message_type",
    "Message Type",
    base.HEX
)

-- Byte 43
F.information_type = ProtoField.uint8(
    "sci.cc.information_type",
    "Information Type",
    base.HEX
)


----------------------------------------------------------------
-- SCI-CC Command Information Types
-- Source: Eu.Doc.50 v4.3 (0.A)
----------------------------------------------------------------

-- Message Type 0x0050 – Command
ENUM.COMMAND_INFO_TYPE = {
    -- TODO: populate from SCI-CC specification
}

-- Message Type 0x0055 – Command Confirmation
ENUM.COMMAND_CONFIRM_INFO_TYPE = {
    -- TODO: populate from SCI-CC specification
}

-- Message Type 0x0065 – Abort Command
ENUM.ABORT_COMMAND_INFO_TYPE = {
    -- TODO: populate from SCI-CC specification
}

----------------------------------------------------------------
-- SCI-CC Status: Route Status (Information Type 0x01)
----------------------------------------------------------------

F.route_state = ProtoField.uint8(
    "sci.cc.route_state",
    "Route State",
    base.HEX,
    {
        [0x01] = "Released",
        [0x02] = "Initiated / Set",
        [0x03] = "Locked",
        [0x04] = "Cancelled and locked",
    }
)

F.route_state_message = ProtoField.uint8(
    "sci.cc.route_state_message",
    "Route State Message",
    base.HEX,
    {
        [0x01] = "Monitoring conditions failed",
        [0x05] = "No message",
        [0xFF] = "Not applicable",
    }
)

F.route_state_description = ProtoField.uint8(
    "sci.cc.route_state_description",
    "Route State Description",
    base.HEX
)

F.overlap_state = ProtoField.uint8(
    "sci.cc.overlap_state",
    "Overlap State",
    base.HEX
)

F.overlap_state_message = ProtoField.uint8(
    "sci.cc.overlap_state_message",
    "Overlap State Message",
    base.HEX
)

F.overlap_release_timer = ProtoField.uint8(
    "sci.cc.overlap_release_timer",
    "Overlap Release Timer",
    base.HEX
)

F.residual_route_timer = ProtoField.uint8(
    "sci.cc.residual_route_timer",
    "Residual Route Cancellation Timer",
    base.HEX
)

F.approach_zone = ProtoField.uint8(
    "sci.cc.approach_zone",
    "Approach Zone",
    base.HEX
)

F.route_delay = ProtoField.uint8(
    "sci.cc.route_delay",
    "Route Delay",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Powered Moveable Element Status (0x04)
----------------------------------------------------------------

F.pme_id = ProtoField.string(
    "sci.cc.pme_id",
    "Powered Moveable Element ID"
)

F.tcs_commanded = ProtoField.uint8(
    "sci.cc.pme.tcs_commanded",
    "TCS Commanded",
    base.HEX
)

F.ils_commanded = ProtoField.uint8(
    "sci.cc.pme.ils_commanded",
    "ILS Commanded",
    base.HEX
)

F.detected_position = ProtoField.uint8(
    "sci.cc.pme.detected_position",
    "Detected Position",
    base.HEX
)

F.blocked_moving = ProtoField.uint8(
    "sci.cc.pme.blocked_moving",
    "Blocked Against Moving",
    base.HEX
)

F.blocked_route_setting = ProtoField.uint8(
    "sci.cc.pme.blocked_route_setting",
    "Blocked Against Route Setting",
    base.HEX
)

F.maintainer_blocked = ProtoField.uint8(
    "sci.cc.pme.maintainer_blocked",
    "Maintainer Blocked",
    base.HEX
)

F.used_locked = ProtoField.uint8(
    "sci.cc.pme.used_locked",
    "Used / Locked",
    base.HEX
)

F.flank_protection = ProtoField.uint8(
    "sci.cc.pme.flank_protection",
    "Flank Protection",
    base.HEX
)

F.flank_receive = ProtoField.uint8(
    "sci.cc.pme.flank_receive",
    "Flank Receive",
    base.HEX
)

F.fouled = ProtoField.uint8(
    "sci.cc.pme.fouled",
    "Fouled",
    base.HEX
)

F.reminder_default = ProtoField.uint8(
    "sci.cc.pme.reminder_default",
    "Reminder to Default Position",
    base.HEX
)

F.ohl_groupset_applicability = ProtoField.uint8(
    "sci.cc.pme.ohl_groupset_applicability",
    "OHL Groupset Applicability",
    base.HEX
)

F.prepared_route_type_position = ProtoField.uint8(
    "sci.cc.pme.prepared_route_type_position",
    "Prepared Route Type and Position",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Signal Status (Information Type 0x05)
----------------------------------------------------------------

F.signal_id = ProtoField.string(
    "sci.cc.signal_id",
    "Signal / Signalling Point ID"
)

F.active_control = ProtoField.uint8(
    "sci.cc.active_control",
    "Active Control",
    base.HEX,
    {
        [0x01] = "Not in active control",
        [0x02] = "In active control",
    }
)

F.signal_state = ProtoField.uint8(
    "sci.cc.signal_state",
    "Signal State",
    base.HEX,
    {
        [0x01] = "Dark due to failure",
        [0xFF] = "Not applicable",
    }
)

F.basic_aspect = ProtoField.uint8(
    "sci.cc.basic_aspect",
    "Basic Aspect Types",
    base.HEX
)

F.extended_aspect = ProtoField.uint8(
    "sci.cc.extended_aspect",
    "Extension of Basic Aspect Types",
    base.HEX
)

F.route_info = ProtoField.uint8(
    "sci.cc.route_information",
    "Route Information",
    base.HEX
)

F.reason_stop = ProtoField.uint8(
    "sci.cc.reason_for_stop",
    "Reason for Signal going to Stop",
    base.HEX
)

F.aspect_control = ProtoField.uint8(
    "sci.cc.aspect_control",
    "Aspect Control",
    base.HEX
)

F.automatic_mode = ProtoField.uint8(
    "sci.cc.automatic_mode",
    "Automatic Mode",
    base.HEX
)

F.lamp_state = ProtoField.uint8(
    "sci.cc.lamp_state",
    "Lamp State",
    base.HEX
)

F.failed_lamp_position = ProtoField.uint8(
    "sci.cc.failed_lamp_position",
    "Failed Lamp Position",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Indicator Status (0x06)
----------------------------------------------------------------

F.indicator_id = ProtoField.string(
    "sci.cc.indicator_id",
    "Indicator ID"
)

F.indicator_state = ProtoField.uint8(
    "sci.cc.indicator.state",
    "State",
    base.HEX
)


----------------------------------------------------------------
-- SCI-CC Status: TVP Section Status (Information Type 0x07)
----------------------------------------------------------------

F.tvp_section_id = ProtoField.string(
    "sci.cc.tvp_section_id",
    "TVP Section ID"
)

F.tvp_failed = ProtoField.uint8(
    "sci.cc.tvp.failed",
    "TVP Section Failed",
    base.HEX
)

F.tvp_occupied = ProtoField.uint8(
    "sci.cc.tvp.occupied",
    "Occupied",
    base.HEX
)

F.tvp_restriction_fc = ProtoField.uint8(
    "sci.cc.tvp.restriction_fc",
    "Restriction to Force Clear",
    base.HEX
)

F.tvp_fc_failed = ProtoField.uint8(
    "sci.cc.tvp.fc_failed",
    "Force Clear Process Failed",
    base.HEX
)

F.tvp_fc_counter = ProtoField.uint8(
    "sci.cc.tvp.fc_counter",
    "Force Clear Operation Counter",
    base.DEC
)

F.tvp_filling_level = ProtoField.int16(
    "sci.cc.tvp.filling_level",
    "Filling Level",
    base.DEC
)

----------------------------------------------------------------
-- SCI-CC Status: Diamond Crossing Status (0x08)
----------------------------------------------------------------

F.diamond_crossing_id = ProtoField.string(
    "sci.cc.diamond_crossing_id",
    "Diamond Crossing ID"
)

F.diamond_direction = ProtoField.uint8(
    "sci.cc.diamond.direction",
    "Direction",
    base.HEX
)

F.diamond_used_locked = ProtoField.uint8(
    "sci.cc.diamond.used_locked",
    "Used / Locked",
    base.HEX
)

F.diamond_flank_protection = ProtoField.uint8(
    "sci.cc.diamond.flank_protection",
    "Flank Protection",
    base.HEX
)

----------------------------------------------------------------
-- Track Section Status (Information Type 0x09)
----------------------------------------------------------------

F.track_section_id = ProtoField.string(
    "sci.cc.track_section_id",
    "Track Section ID"
)

F.track_section_status = ProtoField.uint8(
    "sci.cc.track_section_status",
    "Track Section Status",
    base.HEX,
    {
        [0x01] = "Vacant",
        [0x02] = "Occupied",
        [0x03] = "Disturbed",
    }
)

F.disturbance_status = ProtoField.uint8(
    "sci.cc.disturbance_status",
    "Disturbance / Fault Status",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Level Crossing Status (Information Type 0x0A)
----------------------------------------------------------------

F.level_crossing_id = ProtoField.string(
    "sci.cc.level_crossing_id",
    "Level Crossing ID"
)

F.lc_active_control = ProtoField.uint8(
    "sci.cc.lc.active_control",
    "Active Control",
    base.HEX
)

F.lc_mode = ProtoField.uint8(
    "sci.cc.lc.mode",
    "Mode",
    base.HEX
)

F.lc_barriers = ProtoField.uint8(
    "sci.cc.lc.barriers",
    "Barriers",
    base.HEX
)

F.lc_activation = ProtoField.uint8(
    "sci.cc.lc.activation",
    "Activation",
    base.HEX
)

F.lc_obstruction = ProtoField.uint8(
    "sci.cc.lc.obstruction",
    "Obstruction",
    base.HEX
)

F.lc_road_lights = ProtoField.uint8(
    "sci.cc.lc.road_lights",
    "Road Lights",
    base.HEX
)

F.lc_failure = ProtoField.uint8(
    "sci.cc.lc.failure",
    "Failure",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Line Block Status (Information Type 0x1F)
----------------------------------------------------------------

F.line_block_id = ProtoField.string(
    "sci.cc.line_block_id",
    "Line Block ID"
)

F.line_block_failed = ProtoField.uint8(
    "sci.cc.line_block.failed",
    "Line Block Failed",
    base.HEX
)

F.line_block_direction = ProtoField.uint8(
    "sci.cc.line_block.direction",
    "Direction",
    base.HEX
)

F.line_block_locked = ProtoField.uint8(
    "sci.cc.line_block.locked",
    "Locked",
    base.HEX
)

F.line_block_basic = ProtoField.uint8(
    "sci.cc.line_block.basic",
    "Basic",
    base.HEX
)

F.line_block_change_dir = ProtoField.uint8(
    "sci.cc.line_block.change_direction",
    "Change of Direction",
    base.HEX
)

F.line_block_bypass = ProtoField.uint8(
    "sci.cc.line_block.bypass",
    "Bypass",
    base.HEX
)

F.line_block_blocked_route = ProtoField.uint8(
    "sci.cc.line_block.blocked_route_setting",
    "Blocked for Route Setting",
    base.HEX
)

F.line_block_blocked_direction = ProtoField.uint8(
    "sci.cc.line_block.blocked_direction_change",
    "Blocked for Changing Direction",
    base.HEX
)

F.line_block_repetition = ProtoField.uint8(
    "sci.cc.line_block.repetition_blocked",
    "Repetition Blocked",
    base.HEX
)

F.line_block_stored = ProtoField.uint8(
    "sci.cc.line_block.stored",
    "Stored",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Raise Alarm / Alert / Event (0x21)
----------------------------------------------------------------

F.alarm_element_id = ProtoField.string(
    "sci.cc.alarm.element_id",
    "Element ID"
)

F.alarm_acknowledgement = ProtoField.uint8(
    "sci.cc.alarm.acknowledgement",
    "Acknowledgement",
    base.HEX,
    {
        [0x01] = "No acknowledgement required",
        [0x02] = "Acknowledgement required",
        [0x03] = "Alarm / alert cleared",
        [0xFF] = "Not applicable",
    }
)

F.alarm_fault_code = ProtoField.uint8(
    "sci.cc.alarm.fault_code",
    "Fault Code",
    base.HEX
)

F.alarm_description = ProtoField.string(
    "sci.cc.alarm.description",
    "Description"
)

----------------------------------------------------------------
-- SCI-CC Status: Moveable Lockable Device Status (0x22)
----------------------------------------------------------------

F.mld_id = ProtoField.string(
    "sci.cc.mld_id",
    "Moveable Lockable Device ID"
)

F.mld_direction = ProtoField.uint8(
    "sci.cc.mld.direction",
    "Direction",
    base.HEX
)

F.mld_used_locked = ProtoField.uint8(
    "sci.cc.mld.used_locked",
    "Used / Locked",
    base.HEX
)

F.mld_flank_protection = ProtoField.uint8(
    "sci.cc.mld.flank_protection",
    "Flank Protection",
    base.HEX
)

----------------------------------------------------------------
-- SCI-CC Status: Overrun Alarm (0x23)
----------------------------------------------------------------

F.overrun_signal_id = ProtoField.string(
    "sci.cc.overrun.signal_id",
    "Affected Signal / Signalling Point ID"
)

F.overrun_tvp_section_id = ProtoField.string(
    "sci.cc.overrun.tvp_section_id",
    "Affected TVP Section ID"
)

----------------------------------------------------------------
-- SCI-CC EC Route Blocking (shared)
----------------------------------------------------------------

F.ec_blocking = ProtoField.none(
    "sci.cc.ec_blocking",
    "EC Route Blocking"
)

F.ec01 = ProtoField.bool("sci.cc.ec01", "EC01: No access")
F.ec02 = ProtoField.bool("sci.cc.ec02", "EC02: Work track")
F.ec03 = ProtoField.bool("sci.cc.ec03", "EC03: Track out of service")
F.ec04 = ProtoField.bool("sci.cc.ec04", "EC04: Emergency train")
F.ec05 = ProtoField.bool("sci.cc.ec05", "EC05: Secondary vehicle")
F.ec06 = ProtoField.bool("sci.cc.ec06", "EC06: Team")
F.ec07 = ProtoField.bool("sci.cc.ec07", "EC07: Level crossing")
F.ec08 = ProtoField.bool("sci.cc.ec08", "EC08: Vacancy check")
F.ec09 = ProtoField.bool("sci.cc.ec09", "EC09: Route check")
F.ec10 = ProtoField.bool("sci.cc.ec10", "EC10: No electric trains")
F.ec11 = ProtoField.bool("sci.cc.ec11", "EC11: Extraordinary transport")
F.ec12 = ProtoField.bool("sci.cc.ec12", "EC12: Protection of catenary section")
F.ec13 = ProtoField.bool("sci.cc.ec13", "EC13: Written order")


----------------------------------------------------------------
-- SCI-CC Command: Set a Route (Information Type 0x05)
----------------------------------------------------------------

F.tan = ProtoField.uint16(
    "sci.cc.tan",
    "Transaction Number (TAN)",
    base.DEC
)

F.route_id = ProtoField.string(
    "sci.cc.route_id",
    "Route ID"
)

F.route_type = ProtoField.uint8(
    "sci.cc.route_type",
    "Route Type",
    base.HEX,
    {
        [0x01] = "Main route",
        [0x02] = "Shunting route",
        [0x03] = "Warning route",
        [0x04] = "On-Sight / Call-on route",
        [0x05] = "Staff-Responsible route",
    }
)

F.commanded_state = ProtoField.uint8(
    "sci.cc.commanded_state",
    "Commanded State",
    base.HEX,
    {
        [0x02] = "Set route",
        [0x03] = "Set route overriding restrictions",
    }
)

F.overlap = ProtoField.uint8(
    "sci.cc.overlap",
    "Overlap",
    base.HEX
)

F.flank_protection = ProtoField.uint8(
    "sci.cc.flank_protection",
    "Flank Protection",
    base.HEX
)

F.electrified_destination = ProtoField.uint8(
    "sci.cc.electrified_destination",
    "Electrified Destination",
    base.HEX
)

F.command_user = ProtoField.uint8(
    "sci.cc.command_user",
    "Command User",
    base.HEX,
    {
        [0x01] = "Automatic Route Setting (ARS)",
        [0x02] = "Other (e.g. Signaller)",
    }
)

----------------------------------------------------------------
-- SCI-CC Status: TVP Section Status (Information Type 0x07)
----------------------------------------------------------------

F.tvp_section_id = ProtoField.string(
    "sci.cc.tvp_section_id",
    "TVP Section ID"
)

F.tvp_failed = ProtoField.uint8(
    "sci.cc.tvp.failed",
    "TVP Section Failed",
    base.HEX
)

F.tvp_occupied = ProtoField.uint8(
    "sci.cc.tvp.occupied",
    "Occupied",
    base.HEX
)

F.tvp_restriction_fc = ProtoField.uint8(
    "sci.cc.tvp.restriction_fc",
    "Restriction to Force Clear",
    base.HEX
)

F.tvp_fc_failed = ProtoField.uint8(
    "sci.cc.tvp.fc_failed",
    "Force Clear Process Failed",
    base.HEX
)

F.tvp_fc_counter = ProtoField.uint8(
    "sci.cc.tvp.fc_counter",
    "Force Clear Operation Counter",
    base.DEC
)

F.tvp_filling_level = ProtoField.int16(
    "sci.cc.tvp.filling_level",
    "Filling Level",
    base.DEC
)

----------------------------------------------------------------
-- SCI-CC Command: Cancel a Route (Information Type 0x0C)
----------------------------------------------------------------

F.route_preparation_instruction = ProtoField.uint8(
    "sci.cc.route_preparation_instruction",
    "Route Preparation Instruction",
    base.HEX,
    {
        [0x01] = "Cancel normal route",
        [0x02] = "Cancel prepared route",
        [0xFF] = "Not applicable",
    }
)



----------------------------------------------------------------
-- Export
----------------------------------------------------------------
return F
