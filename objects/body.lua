local Body = Object:extend()

local gap_damp = 0.4

function Body:new(x, y, gap, player)
    self.x = x
    self.y = y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE
    self.gap = gap
    self.player = player
end

function Body:update(dt)
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*MOVE_DAMP*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*MOVE_DAMP*dt
    self.gap = self.gap-self.gap*gap_damp*dt
end

function Body:draw()
    love.graphics.setColor(Color.player)
    love.graphics.rectangle("fill", self.smooth_x+self.gap, self.smooth_y+self.gap, TILE_SIZE-self.gap*2, TILE_SIZE-self.gap*2)
    Color.reset()
end

function Body:die()
    self.remove = true
end

function Body:push()
    self.player:push()
end

return Body