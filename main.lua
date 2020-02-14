--"C:\Program Files\LOVE\love.exe" "C:\Users\mickey\Documents\projects\lua_games\platformer"
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720 

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

Class = require 'class'
push = require 'push'
require 'mapLevel'
require 'Map'

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    map = Map()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true
    })

    love.window.setTitle('Platformer')
    love.keyboard.keysPressed = {}
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    map:update(dt)
     -- reset all keys pressed and released this frame
     love.keyboard.keysPressed = {}
end

function love.draw()
    push:apply('start')
    

    -- clear screen using Mario background blue
   

    love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
    map:render()

    push:apply('end')
end