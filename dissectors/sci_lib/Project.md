
SCI Wireshark Dissector – Skeleton Repository
This page provides:

A skeleton repository layout for all SCI dissectors (LS, ILS, RBC, CC, …)
A project README.md that defines the architectural rules and coding conventions
The structure and rules are designed for very large SCI protocols, long‑term maintenance, and direct traceability to EULYNX specifications.


1. Repository Skeleton
wireshark-sci-dissectors/
│
├── README.md                     # Architecture & contribution rules
│
├── sci-generic/
│   ├── init.lua                  # SCI-Generic (Eu.Doc.93)
│   ├── fields.lua                # Generic SCI fields
│   ├── enums.lua                 # Generic enums (msg types, errors)
│   └── expert.lua                # Shared expert info helpers
│
├── sci-ls/
│   ├── init.lua                  # Protocol Type 0x30
│   ├── fields.lua                # SCI-LS ProtoFields
│   ├── enums.lua                 # SCI-LS enums
│   └── messages/
│       ├── indicate_signal_aspect.lua
│       ├── indicated_signal_aspect.lua
│       ├── set_luminosity.lua
│       └── set_luminosity_status.lua
│
├── sci-ils/
│   ├── init.lua                  # Protocol Type 0x01
│   ├── fields.lua                # SCI-ILS ProtoFields
│   ├── enums.lua                 # SCI-ILS enums
│   └── messages/
│       ├── activation_zone_status.lua
│       ├── approach_zone_status.lua
│       ├── route_status.lua
│       ├── route_monitoring_status.lua
│       ├── signal_status.lua
│       └── ...
│
├── sci-rbc/
│   ├── init.lua                  # Protocol Type 0x50
│   ├── fields.lua                # SCI-RBC ProtoFields
│   ├── enums.lua                 # SCI-RBC enums
│   └── messages/
│       ├── signal_control.lua
│       ├── route_status.lua
│       ├── signal_status.lua
│       ├── train_data.lua
│       └── ...
│
├── sci-cc/
│   ├── init.lua
│   ├── fields.lua
│   ├── enums.lua
│   └── messages/
│       └── ...
│
└── common/
    ├── ids.lua                   # 20-byte ID decoding helpers
    ├── signal_aspects.lua        # Eu.Doc.37 shared signal aspect decoding
    ├── speeds.lua                # Speed decoding helpers
    └── utils.lua                 # Small shared utilities


Key ideas

One directory per SCI protocol
One Lua file per telegram
Shared logic lives in common/
No SCI protocol ever decodes transport or version handling


2. README.md – Architectural Rules
The following text is intended to be used verbatim as your project’s README.md.


SCI Wireshark Dissectors
This repository contains Wireshark Lua dissectors for EULYNX SCI protocols (SCI‑Generic, SCI‑LS, SCI‑ILS, SCI‑RBC, SCI‑CC, …).
The project is designed for large, message‑rich protocols and long‑term alignment with evolving EULYNX specifications.


1. Architectural Principles
1.1 SCI‑Generic is the foundation
SCI‑Generic (Eu.Doc.93) owns:

Protocol Type dispatch
Version handling
Sender / Receiver identifiers
Generic telegram structure
All SCI‑X dissectors must assume that:
Byte 0      Protocol Type
Byte 1..2   Message Type (little endian)
Byte 3..42  Identifiers
Byte 43..   Payload


No SCI‑X dissector may re‑implement SCI‑Generic logic.


1.2 One root dissector per SCI protocol
Each SCI protocol has exactly one entry point:
sci-ils/init.lua
sci-rbc/init.lua
sci-ls/init.lua


Responsibilities of init.lua:

Register the protocol type
Decode the message type
Dispatch to a payload decoder
No payload decoding logic belongs in init.lua.


1.3 One file per telegram
Each SCI telegram is implemented in its own Lua file:
messages/route_status.lua
messages/signal_status.lua


Benefits:

Direct 1:1 mapping to EULYNX sections (§3.5.x)
Easy verification against the standard
Minimal merge conflicts
Clear ownership
Each file must decode only the fields defined for that telegram.


1.4 Fields and enums are centralized

fields.lua defines all ProtoFields for a protocol
enums.lua defines all value tables
Rules:

Fields must never be created dynamically
Field names must remain stable for Wireshark filters
Example filter stability:
sci.ils.route_id
sci.rbc.signal_id




1.5 Decode structure, not behaviour
Wireshark dissectors:

✅ Decode bytes and enums
✅ Validate length and format
❌ Do NOT enforce state machines
❌ Do NOT implement national rules
❌ Do NOT simulate interlocking behaviour
This aligns with §1.3 of all SCI interface specifications.


2. Message Decoder Rules
2.1 Byte accuracy
All offsets must match the specification exactly.
Each decoder should guard against short packets:
if buf:len() < REQUIRED_LENGTH then return end




2.2 Subtrees for large messages
Large messages (e.g. SCI‑RBC Signal Status, SCI‑ILS Route Monitoring Status) must use subtrees to keep the UI readable.


2.3 Traceability to the standard
Every decoder file must reference the relevant PDI ID(s):
-- Eu.SCI-ILS.PDI.294


This is mandatory for audits and reviews.


3. Versioning Strategy
SCI specifications evolve.
Rules:

Never branch on version inside a decoder
Use versioned directories if layouts change
Example:
sci-ils/v4_3/messages/...
sci-ils/v4_4/messages/...


Version selection happens only in init.lua.


4. Performance Guidelines
Wireshark Lua performance rules:

Avoid loops over payload
Avoid string concatenation in hot paths
Avoid speculative parsing
Keep decoders shallow and deterministic
This repository follows these rules by design.


5. Contribution Checklist
Before committing:

Decoder matches spec byte‑for‑byte
PDI ID referenced in comments
Fields defined in fields.lua
Enums defined in enums.lua
No SCI‑Generic duplication


6. Supported SCI Protocols

SCI‑Generic (Eu.Doc.93)
SCI‑LS (Eu.Doc.33)
SCI‑ILS (Eu.Doc.42)
SCI‑RBC (Eu.Doc.48)
SCI‑CC


This architecture is intentionally conservative, explicit, and audit‑friendly. It is designed to survive years of EULYNX evolution with minimal refactoring.


If you want, next we can:

Turn this into a real Git repo (gitignore, plugin loader)
Refactor one existing dissector into this layout
Add a CONTRIBUTING.md with review rules
