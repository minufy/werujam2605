local Img = Object:extend()

local filters = {
    img = {"img"}
}

function Img:new(data)
    self.type = data.type
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.draw_x = 0
    self.draw_y = 0
    -- self.dir = data.dir or 0
    -- self.r = self.dir*math.pi/2
    self.w = Image["img."..data.type]:getWidth()
    self.h = Image["img."..data.type]:getHeight()

    self.target_x = self.x
    self.target_y = self.y
    self.ok = false

    self.shuffled = false
    self.can_place = true

    self.cbs = {
        place = function (other)
            self.can_place = false
        end,
        shuffle = function (other)
            self:shuffle()
        end,
    }
end

function Img:shuffle()
    self.x = math.random(0, Res.w/TILE_SIZE-1)*TILE_SIZE
    self.y = math.random(0, Res.w/TILE_SIZE-1)*TILE_SIZE
    Physics.col(self, filters.img, self.cbs.shuffle)
end

function Img:update(dt)
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*0.2*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*0.2*dt
    if Game.shuffle and not self.shuffled then
        for _ = 1, 3 do
            Game:add(Particle, self.x+TILE_SIZE/2, self.y+TILE_SIZE/2, math.random(-10, 10), math.random(-10, 10), math.random(4, 10))
        end
        self:shuffle()
        self.shuffled = true
    end
    self.ok = self.target_x == self.x and self.target_y == self.y
end

function Img:draw()
    love.graphics.draw(Image["img."..self.type], self.smooth_x, self.smooth_y)
end

function Img:place(x, y)
    self.can_place = true
    self.x = math.round_s(self.x, TILE_SIZE)
    self.y = math.round_s(self.y, TILE_SIZE)
    Physics.col(self, filters.img, self.cbs.place)
    if self.can_place then
        Camera:shake(1)
        for _ = 1, 4 do
            Game:add(Particle, self.x+TILE_SIZE/2, self.y+TILE_SIZE/2, math.random(-10, 10), math.random(-10, 10), math.random(4, 10))
        end
    else
        self.x = x
        self.y = y
    end
end

return Img