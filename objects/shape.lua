local Shape = Object:extend()

Shape:implement(require("objects.shape.shape"))

function Shape:new(data)
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.draw_x = 0
    self.draw_y = 0
    self.type = Game:get_type()
    self.w = Image[self.type]:getWidth()
    self.h = Image[self.type]:getHeight()
    self:shape_init()
end

function Shape:update(dt)
    self:shape_update(dt)
end

function Shape:draw()
    love.graphics.draw(Image[self.type], self.smooth_x, self.smooth_y)
end

return Shape