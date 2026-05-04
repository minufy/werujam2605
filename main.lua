Object = require("modules.classic")
Particle = require("objects.particle")

-- stuff 
require("stuff.audio")
require("stuff.camera")
require("stuff.edit")
require("stuff.image")
require("stuff.input")
require("stuff.level")
require("stuff.log")
require("stuff.mouse")
require("stuff.physics")
require("stuff.res")
require("stuff.selection")
require("stuff.shader")
require("stuff.timer")
require("stuff.utils")

require("scenes.sm")
require("settings")

SetType(Particle, "particle")

function love.load()
    LogFont = love.graphics.newFont(20)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    love.mouse.setVisible(false)
    Font = love.graphics.newFont("assets/fonts/Galmuri7.ttf", 8)

    NewAudio("fade")
    NewAudio("bad")
    NewAudio("ok")
    NewAudio("volume")
    NewAudio("place")
    NewAudio("swap")
    NewAudio("beam")
    NewAudio("mirror")
    NewAudio("grab")

    Color.bbgg = rgb(33, 35, 57)
    Color.bg = rgb(48, 58, 95)
    Color.heart = rgb(230, 103, 74)
    Color.fg = rgb(238, 238, 238)

    Shader:init("assets/shader/shadow.glsl")
    Res:init()
    SM:load("game")
    UpdateTargetFPS()

    math.randomseed(love.timer.getTime())
end

function love.update(dt)
    dt = math.min(dt*60, 4)
    UpdateInputs()
    Camera:update(dt)
    SM:update(dt)
    ResetWheelInput()
    Log:update(dt)
end

local prev = 0
function love.draw()
    Res:before()
    SM:draw()
    Res:after()
    Log:draw()
    if CONSOLE then
        love.graphics.print(tostring(love.timer.getFPS()))
        local mem = collectgarbage("count")
        local delta = mem-prev
        prev = mem
        love.graphics.print(string.format("Mem: %.1f KB | d %.1f", mem, delta), 0, LogFont:getHeight())
    end
end