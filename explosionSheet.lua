--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:3547c1538e04c6a29b80ef4a178b5a92:1dca5e4ec75d5ee8bd2b95b6d79877f6:c1737f3ce17ec52eb1d96ff9a66ce11f$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 0000
            x=341,
            y=321,
            width=46,
            height=46,

            sourceX = 147,
            sourceY = 147,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0001
            x=425,
            y=311,
            width=56,
            height=56,

            sourceX = 141,
            sourceY = 141,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0002
            x=425,
            y=237,
            width=76,
            height=72,

            sourceX = 132,
            sourceY = 134,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0003
            x=341,
            y=237,
            width=82,
            height=82,

            sourceX = 129,
            sourceY = 129,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0004
            x=341,
            y=1,
            width=160,
            height=234,

            sourceX = 89,
            sourceY = 45,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0005
            x=285,
            y=369,
            width=202,
            height=294,

            sourceX = 68,
            sourceY = 16,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0006
            x=1,
            y=625,
            width=214,
            height=234,

            sourceX = 62,
            sourceY = 45,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0007
            x=1,
            y=341,
            width=282,
            height=282,

            sourceX = 29,
            sourceY = 29,
            sourceWidth = 340,
            sourceHeight = 340
        },
        {
            -- 0008
            x=1,
            y=1,
            width=338,
            height=338,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 340,
            sourceHeight = 340
        },
    },
    
    sheetContentWidth = 502,
    sheetContentHeight = 860
}

SheetInfo.frameIndex =
{

    ["0000"] = 1,
    ["0001"] = 2,
    ["0002"] = 3,
    ["0003"] = 4,
    ["0004"] = 5,
    ["0005"] = 6,
    ["0006"] = 7,
    ["0007"] = 8,
    ["0008"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
