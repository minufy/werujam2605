local OutputArea = Object:extend()
OutputArea:implement(require("objects.area.area"))

NewImage("output_area")

function OutputArea:new(data)
    self:init_area()
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.old_x = self.x
    self.old_y = self.y
    self.w = TILE_SIZE*3
    self.h = TILE_SIZE*3
end

function OutputArea:draw()
    local mode = "line"
    if not Game.input_on then
        mode = "fill"
    end
    love.graphics.setColor(Color.alpha(Color.output_area, 0.2))
    love.graphics.rectangle(mode, self.smooth_x, self.smooth_y, TILE_SIZE*3, TILE_SIZE*3)
    Color.reset()
    love.graphics.draw(Image.output_area, self.smooth_x, self.smooth_y)
end

return OutputArea