End = {}

function End:init()
    
end

function End:update(dt)
    
end

function End:draw()
    love.graphics.setColor(Color.bbgg)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()
    love.graphics.setColor(Color.fg)
    love.graphics.setFont(Font)
    love.graphics.print("thanks for playing!!!", 10, 10)
    Color.reset()
end

return End