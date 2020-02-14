require 'Util'
require 'mapLevel'
require 'Player'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = 2
local SCROLL_SPEED = 60
function Map:init()
    self.spritesheet = love.graphics.newImage('brick_tiles_1.png')
    self.tileWidth = 32
    self.tileHeight = 32
    self.mapWidth = 32
    self.mapHeight= 12
    self.tiles = {}
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)
    self.camX = 0
    self.camY = 0
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight
    self.player = Player(self) -- player is passed in reference to map for use in Player class

    -- create map
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if mapLevel[(y - 1) * self.mapWidth + x] == 0 then
                self:setTile(x, y, TILE_EMPTY)
            else
                self:setTile(x, y, TILE_BRICK )
            end

            --[[if mapLevel[(y - 1) * self.mapWidth + x] == 1 then
                self:setTile(x, y, TILE_BRICK )
            end--]]

        end
    end
 
end

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- return whether a given tile is collidable
function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        TILE_BRICK
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:update(dt)
   --[[ if love.keyboard.isDown('w') then
        self.camY = math.max(0,self.camY + (-SCROLL_SPEED * dt))
    elseif love.keyboard.isDown('a') then
        self.camX = math.max(0, self.camX + (-SCROLL_SPEED * dt))
    elseif love.keyboard.isDown('s') then
        self.camY = math.min(self.mapHeightPixels - VIRTUAL_HEIGHT, self.camY + (SCROLL_SPEED * dt))
    elseif love.keyboard.isDown('d') then
        self.camX = math.min(self.mapWidthPixels -VIRTUAL_WIDTH, self.camX + (SCROLL_SPEED * dt))
    end ]]

    self.player:update(dt)

    self.camX = math.max(0, math.min(self.player.x - VIRTUAL_WIDTH/2,
                            math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.player.x))
    
    )

   

end

function Map:render()
    for y = 1, self.mapHeight do
     for x = 1, self.mapWidth do
        love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
        (x - 1) * self.tileWidth, (y - 1) * self.tileHeight) -- add 12 to offset empty 
        end
    end

    self.player:render()
end

