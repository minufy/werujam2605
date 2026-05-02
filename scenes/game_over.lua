GameOver = {}

function GameOver:init()
    
end

function GameOver:update(dt)
    if Input.space.pressed then
        SM:set_fade(function ()
            SM:load("game")
        end)
    end
end

function GameOver:draw()
    love.graphics.setColor(Color.bbgg)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()
    love.graphics.setColor(Color.fg)
    love.graphics.setFont(Font)
    love.graphics.print("game over...", 10, 10)
    Color.reset()
    love.graphics.setColor(Color.alpha(Color.fg, 0.5))
    love.graphics.print("press [space] to restart", 10, Res.h-Font:getHeight()-10)
    Color.reset()
end

return GameOver