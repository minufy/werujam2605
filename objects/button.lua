local Button = Object:extend()

NewImage("button")

function Button:new(data)
    self.x = data.x
    self.y = data.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE
end

function Button:draw()
    love.graphics.draw(Image.button, self.x, self.y)
end

return Button