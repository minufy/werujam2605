local InputArea = Object:extend()
InputArea:implement(require("objects.area.area"))

NewImage("input_area")

function InputArea:new(data)
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

function InputArea:draw()
    local mode = "line"
    if Game.input_on then
        mode = "fill"
    end
    love.graphics.setColor(Color.alpha(Color.input_area, 0.2))
    love.graphics.rectangle(mode, self.smooth_x, self.smooth_y, TILE_SIZE*3, TILE_SIZE*3)
    Color.reset()
    love.graphics.draw(Image.input_area, self.smooth_x, self.smooth_y)
end

return InputArea