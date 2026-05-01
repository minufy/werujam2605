local Fruit = Object:extend()

NewImage("fruit")

function Fruit:new(data)
    self.x = data.x
    self.y = data.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE
end


function Fruit:draw()
    love.graphics.draw(Image.fruit, self.x, self.y+SinEffect())
end

return Fruit