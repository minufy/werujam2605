local Mirror = Object:extend()

Mirror:implement(require("objects.shape.shape"))

NewImage("mirror")

function Mirror:new(data)
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.draw_x = 0
    self.draw_y = 0
    self.w = Image.mirror:getWidth()
    self.h = Image.mirror:getHeight()
    self.dir = data.dir or 0
    self.r = self.dir*math.pi/2
    self:shape_init()
end

function Mirror:update(dt)
    self:shape_update(dt)
end

function Mirror:draw()
    if Game.shuffle or Edit.editing then
        love.graphics.draw(Image.mirror, self.smooth_x+self.draw_x, self.smooth_y+self.draw_y, self.r)
    end
end

return Mirror