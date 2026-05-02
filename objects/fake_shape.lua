local FakeShape = Object:extend()

FakeShape:implement(require("objects.shape.shape"))

function FakeShape:new(data)
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

function FakeShape:update(dt)
    self:shape_update(dt)
end

function FakeShape:draw()
    if Edit.editing then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.draw(Image[self.type], self.smooth_x, self.smooth_y)
        Color.reset()
    elseif Game.shuffle then
        love.graphics.draw(Image[self.type], self.smooth_x, self.smooth_y)
    end
end

return FakeShape