Player = Class{}

require 'Animation'

local MOVE_SPEED = 100
local JUMP_VELOCITY = 400
local GRAVITY = 40

function Player:init(map)
    self.width = 57
    self.height = 57
    self.direction = 'left'
    self.map = map
    self.x = map.tileHeight * (map.mapHeight/ 4) - self.height
    self.y = map.tileHeight * (map.mapHeight / 2) - self.height
    self.dx = 0
    self.dy = 0
    self.texture = love.graphics.newImage('character.png')
    self.frames = generateQuads(self.texture, 57, 57)
    self.state = 'idle'
    self.xOffset = 28
    self.yOffset = 28
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[19]
            },
            interval = 1
        },
        ['walking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[28],self.frames[29],self.frames[30],self.frames[31],self.frames[32],self.frames[33],self.frames[34],self.frames[35],self.frames[36],self.frames[37], 
            },
            interval = 0.15
        },
        ['jumping'] = Animation {
            texture = self.texture,
            frames = { self.frames[32] },
            interval = 1
        }
    }

    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = function(dt)
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('a') then
                self.dx = -MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'left'
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'right'
            else
                self.dx = 0
                self.animation = self.animations['idle']
              
            end
            

        end,
        ['walking'] = function(dt)
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('a') then
                self.dx = -MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'left'
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED
                self.animation = self.animations['walking']
                self.direction = 'right'
            else
                self.animation = self.animations['idle']
            end

            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()

            -- check if there's a tile directly beneath us
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                -- if so, reset velocity and position and change state
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            end

        end,
        ['jumping'] = function(dt)
            -- break if we go below the surface
            

            if love.keyboard.isDown('a') then
                self.direction = 'left'
                self.dx = -MOVE_SPEED
            elseif love.keyboard.isDown('d') then
                self.direction = 'right'
                self.dx = MOVE_SPEED
            end

            self.dy = self.dy + GRAVITY

            -- check if there's a tile directly beneath us
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
            
            -- if so, reset velocity and position and change state
            self.dy = 0
            self.state = 'idle'
            self.animation = self.animations['idle']
            self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
            end

            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()
        end
        }
end

-- jumping and block hitting logic
function Player:calculateJumps()
    
    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        if self.map:tileAt(self.x, self.y).id ~= TILE_EMPTY or
            self.map:tileAt(self.x + self.width - 1, self.y).id ~= TILE_EMPTY then
            -- reset y velocity
            self.dy = 0
        end
    end
end

function Player:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.x = self.x + self.dx * dt
    self:calculateJumps()
    self.y = self.y + self.dy * dt

    
end

-- checks two tiles to our left to see if a collision occurred
function Player:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

-- checks two tiles to our right to see if a collision occurred
function Player:checkRightCollision()
    if self.dx > 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

function Player:render()
    --[[local scaleX
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), self.x, self.y)
     -- set negative x scale factor if facing left, which will flip the sprite]]
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), math.floor(self.x + self.width /2),
    math.floor(self.y +self.height/2), 0, scaleX, 1, self.width/2, self.height/2)

    -- draw sprite with scale factor and offsets

    
        
    
end