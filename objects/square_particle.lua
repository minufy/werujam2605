local SquareParticle = Object:extend()

function SquareParticle:new(x, y, size, target_size, color)
    self.x = x
    self.y = y
    self.w = size
    self.h = size
    self.size = size
    self.target_size = target_size
    self.alpha = 1
    self.color = color or {1, 1, 1}
end

function SquareParticle:update(dt)
    self.alpha = self.alpha-self.alpha*0.1*dt
    if self.alpha < 0.1 then
        self.remove = true
    end
end

function SquareParticle:draw()
    love.graphics.setLineWidth(self.alpha*4)
    love.graphics.setColor(Color.alpha(self.color, self.alpha))
    local size = self.size-self.alpha*self.target_size+self.target_size
    love.graphics.rectangle("line", self.x-size/2, self.y-size/2, size, size, 2, 2)
    Color.reset()
end

return SquareParticle