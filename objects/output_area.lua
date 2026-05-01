local OutputArea = Object:extend()

NewImage("output_area")

function OutputArea:new(data)
    self.x = data.x
    self.y = data.y
    self.w = TILE_SIZE*3
    self.h = TILE_SIZE*3
end

function OutputArea:draw()
    local mode = "line"
    if not Game.input_on then
        mode = "fill"
    end
    love.graphics.setColor(Color.alpha(Color.output_area, 0.2))
    love.graphics.rectangle(mode, self.x, self.y, TILE_SIZE*3, TILE_SIZE*3)
    Color.reset()
    love.graphics.draw(Image.output_area, self.x, self.y)
end

return OutputArea