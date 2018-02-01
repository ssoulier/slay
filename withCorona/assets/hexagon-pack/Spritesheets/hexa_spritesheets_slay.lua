--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b3c95a5c66e183ee58a0413a6e3528fa:5b39fa4e646cec208492caeab3cd5a7a:5e4a4121d1397fb1ffa5a926dd8e69ce$
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
            -- hexagonTerrain_sheet
            x=1,
            y=1,
            width=854,
            height=1988,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 1024,
            sourceHeight = 2048
        },
    },
    
    sheetContentWidth = 856,
    sheetContentHeight = 1990
}

SheetInfo.frameIndex =
{

    ["hexagonTerrain_sheet"] = 1,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
