-- common/ids.lua
--
-- Shared helpers for SCI identifier handling.
-- Applies to all SCI protocols (Generic, LS, ILS, RBC, CC, ...).
--
-- SCI identifiers:
--  - fixed length (usually 20 bytes)
--  - ISO IEC 8859-1:1998 encoding
--  - left-aligned, padded with NULL (0x00) or spaces
--

local ids = {}

----------------------------------------------------------------
-- Trim padding from SCI identifiers
----------------------------------------------------------------
-- Removes:
--  - trailing NULL bytes (0x00)
--  - trailing spaces (0x20)
--
-- Does NOT modify internal content.
--
local function rtrim(str)
    -- Remove trailing NULLs
    str = str:gsub("\0+$", "")
    -- Remove trailing spaces
    str = str:gsub("%s+$", "")
    return str
end

----------------------------------------------------------------
-- Decode an SCI identifier from a TvbRange
----------------------------------------------------------------
-- Parameters:
--   range : TvbRange (e.g. buf:range(43,20))
--
-- Returns:
--   Clean Lua string suitable for display
--
function ids.decode(range)
    if not range or range:len() == 0 then
        return ""
    end

    -- TvbRange:string() preserves ISO-8859-1 bytes
    local raw = range:string()
    return rtrim(raw)
end

----------------------------------------------------------------
-- Add a decoded SCI identifier to a tree
----------------------------------------------------------------
-- Parameters:
--   tree  : TreeItem
--   field : ProtoField (string)
--   range : TvbRange
--
-- This helper ensures consistent trimming everywhere.
--
function ids.add(tree, field, range)
    if not (tree and field and range) then return end
    tree:add(field, ids.decode(range))
end

----------------------------------------------------------------
-- Export
----------------------------------------------------------------
return ids