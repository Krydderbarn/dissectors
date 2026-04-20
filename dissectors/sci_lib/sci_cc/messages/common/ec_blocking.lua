-- sci-cc/messages/common/ec_blocking.lua
-- Shared decoder for EC Route Blocking

local F = require("sci_cc.fields")

-- Byte layout:
-- byte 0: EC01..EC04
-- byte 1: EC05(1)..EC05(4)
-- byte 2: EC07(1)..EC07(4)
-- byte 3: EC07(5)..EC07(6), EC06, EC05(5)
-- byte 4: EC08..EC11
-- byte 5: EC12..EC13

return function (buf, tree, offset)
    local ec_tree = tree:add(F.ec_blocking)

    local b0 = buf(offset + 0, 1):uint()
    local b1 = buf(offset + 1, 1):uint()
    local b2 = buf(offset + 2, 1):uint()
    local b3 = buf(offset + 3, 1):uint()
    local b4 = buf(offset + 4, 1):uint()
    local b5 = buf(offset + 5, 1):uint()

    ec_tree:add(F.ec01, bit.band(b0, 0x01) ~= 0)
    ec_tree:add(F.ec02, bit.band(b0, 0x04) ~= 0)
    ec_tree:add(F.ec03, bit.band(b0, 0x10) ~= 0)
    ec_tree:add(F.ec04, bit.band(b0, 0x40) ~= 0)

    ec_tree:add(F.ec05,
        bit.band(b1, 0xFF) ~= 0 or bit.band(b3, 0x03) ~= 0)

    ec_tree:add(F.ec07,
        bit.band(b2, 0xFF) ~= 0 or bit.band(b3, 0xFC) ~= 0)

    ec_tree:add(F.ec06, bit.band(b3, 0x04) ~= 0)

    ec_tree:add(F.ec08, bit.band(b4, 0x01) ~= 0)
    ec_tree:add(F.ec09, bit.band(b4, 0x04) ~= 0)
    ec_tree:add(F.ec10, bit.band(b4, 0x10) ~= 0)
    ec_tree:add(F.ec11, bit.band(b4, 0x40) ~= 0)

    ec_tree:add(F.ec12, bit.band(b5, 0x01) ~= 0)
    ec_tree:add(F.ec13, bit.band(b5, 0x04) ~= 0)
end
