local Remove = Object:extend()

NewImage("remove")

function Remove:new(data)
    self.x = data.x
    self.y = data.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE
end

function Remove:draw()
    love.graphics.draw(Image.remove, self.x, self.y)
end

return Remove