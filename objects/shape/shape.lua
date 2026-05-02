local Shape = Object:extend()

local move_damp = 0.3

function Shape:shape_init()
    self.target_x = self.x
    self.target_y = self.y
    self.ok = false

    self.shuffled = false
    self.other = true

    self.cbs = {
        place = function (other)
            self.other = other
        end,
        shuffle = function (other)
            self:shuffle()
        end,
        remove = function (other)
            self:die()
        end
    }
end

function Shape:shuffle()
    self.x = math.random(2, Res.w/TILE_SIZE-3)*TILE_SIZE
    self.y = math.random(2, Res.w/TILE_SIZE-3)*TILE_SIZE
    Physics.col(self, FILTERS.shape, self.cbs.shuffle)
    if self.target_x == self.x and self.target_y == self.y then
        self:shuffle()
    end
end

function Shape:shape_update(dt)
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*move_damp*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*move_damp*dt
    if Game.shuffle and not self.shuffled then
        for _ = 1, 3 do
            Game:add(Particle, self.x+TILE_SIZE/2, self.y+TILE_SIZE/2, math.random(-10, 10), math.random(-10, 10), math.random(4, 10))
        end
        self:shuffle()
        self.shuffled = true
    end
    self.ok = self.target_x == self.x and self.target_y == self.y
end

function Shape:place(x, y)
    self.other = nil
    self.x = math.round_s(self.x, TILE_SIZE)
    self.y = math.round_s(self.y, TILE_SIZE)
    Physics.col(self, FILTERS.shape, self.cbs.place)
    Camera:shake(1)
    for _ = 1, 4 do
        Game:add(Particle, self.x+TILE_SIZE/2, self.y+TILE_SIZE/2, math.random(-10, 10), math.random(-10, 10), math.random(4, 10))
    end
    if self.other then
        self.other.x = x
        self.other.y = y
    end
    Physics.col(self, FILTERS.remove, self.cbs.remove)
end

function Shape:die()
    self.remove = true
    for _ = 1, 4 do
        Game:add(Particle, self.x+TILE_SIZE/2, self.y+TILE_SIZE/2, math.random(-10, 10), math.random(-10, 10), math.random(4, 10))
    end
end

return Shape