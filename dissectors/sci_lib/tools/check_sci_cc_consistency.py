#!/usr/bin/env python3
"""
SCI-CC consistency checker

Checks consistency between:
- enums.lua
- dispatcher tables
- filesystem (.lua decoders)

For both:
- Status (Message Type 0x0040)
- Command (Message Type 0x0050 / 0x0055)

This script is read-only and CI-safe.
"""

import re
import sys
from pathlib import Path

# Resolve repo root relative to this script's location
ROOT = Path(__file__).resolve().parents[2] / "SCI"

STATUS_DIR = ROOT / "sci-cc/messages/status"
COMMAND_DIR = ROOT / "sci-cc/messages/command"
ENUMS_FILE = ROOT / "sci-cc/enums.lua"

STATUS_INIT = STATUS_DIR / "init.lua"
COMMAND_INIT = COMMAND_DIR / "init.lua"


DISPATCH_RE = re.compile(
    r"\[\s*0x([0-9A-Fa-f]+)\s*\]\s*=\s*require\(\"([^\"]+)\"\)"
)

ENUM_RE = re.compile(
    r"\[\s*0x([0-9A-Fa-f]+)\s*\]\s*=\s*\"([^\"]+)\""
)


def parse_dispatcher(path):
    mapping = {}
    text = path.read_text(encoding="utf-8")

    for m in DISPATCH_RE.finditer(text):
        info_type = int(m.group(1), 16)
        module = m.group(2)
        mapping[info_type] = module

    return mapping


def parse_enum_table(enum_name):
    text = ENUMS_FILE.read_text(encoding="utf-8")

    # Extract only the requested enum table
    start = text.find(enum_name)
    if start == -1:
        return {}

    block = text[start:]
    block = block.split("}", 1)[0]

    enums = {}
    for m in ENUM_RE.finditer(block):
        info_type = int(m.group(1), 16)
        enums[info_type] = m.group(2)

    return enums


def lua_files_in(dir_path):
    return {
        p.stem for p in dir_path.glob("*.lua")
        if p.name != "init.lua"
    }


def check(name, dispatcher, enum_table, lua_files, base_module):
    ok = True
    print(f"\n=== Checking {name} ===")

    # Dispatcher -> file
    for info_type, module in dispatcher.items():
        file_name = module.split(".")[-1]
        if file_name not in lua_files:
            print(
                f"❌ Missing file for dispatcher entry "
                f"0x{info_type:02X}: {file_name}.lua"
            )
            ok = False

    # File -> dispatcher
    dispatcher_files = {
        module.split(".")[-1] for module in dispatcher.values()
    }

    for file in lua_files:
        if file not in dispatcher_files:
            print(f"⚠️  Orphan file (not in dispatcher): {file}.lua")

    # Enum -> dispatcher
    for info_type in enum_table:
        if info_type not in dispatcher:
            print(
                f"❌ Enum value 0x{info_type:02X} "
                f"missing in dispatcher"
            )
            ok = False

    # Dispatcher -> enum
    for info_type in dispatcher:
        if info_type not in enum_table:
            print(
                f"⚠️  Dispatcher entry 0x{info_type:02X} "
                f"missing in enums.lua"
            )

    if ok:
        print(f"✅ {name} OK")
    else:
        print(f"❌ {name} FAILED")

    return ok


def main():
    status_dispatch = parse_dispatcher(STATUS_INIT)
    command_dispatch = parse_dispatcher(COMMAND_INIT)

    status_enums = parse_enum_table("STATUS_INFO_TYPE")
    command_enums = parse_enum_table("COMMAND_INFO_TYPE")

    status_files = lua_files_in(STATUS_DIR)
    command_files = lua_files_in(COMMAND_DIR)

    ok_status = check(
        "SCI-CC Status",
        status_dispatch,
        status_enums,
        status_files,
        "sci-cc.messages.status",
    )

    ok_command = check(
        "SCI-CC Command",
        command_dispatch,
        command_enums,
        command_files,
        "sci-cc.messages.command",
    )

    if not (ok_status and ok_command):
        sys.exit(1)

    print("\n✅ SCI-CC consistency check passed")


if __name__ == "__main__":
    main()