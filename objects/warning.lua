local Warning = Object:extend()

NewImage("warning")

local r = TILE_SIZE*2

function Warning:new(data)
    self.x = data.x
    self.y = data.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE
    self.r = 0

    self.explosion_timer = Timer(100)
    self.cbs = {
        player = function (other)
            other:die()
        end,
        body = function (other)
            other:cut()
        end,
    }
    
    if not Edit.editing then
        for _ = 1, 3 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-5, 5), math.random(-5, 5), math.random(6, 8), Color.player)
        end
    end
end

function Warning:update(dt)
    if self.explosion_timer:run(dt) then
        self.remove = true
        Physics.dist(self, FILTERS.player, self.cbs.player, r)
        Physics.dist(self, FILTERS.body, self.cbs.body, r)
        Camera:shake(3)
        for _ = 1, 7 do
            Game:add(Particle, self.x+self.w/2+math.random(-r, r), self.y+self.h/2+math.random(-r, r), math.random(-6, 6), math.random(-6, 6), math.random(6, 12), Color.player)
        end
        Game:add(CircleParticle, self.x+self.w/2, self.y+self.h/2, TILE_SIZE, r, Color.white)
    end
    self.r = self.r+(r-self.r)*0.04*dt
end

function Warning:draw()
    if self.explosion_timer.timer < self.explosion_timer.time-2 then
        love.graphics.setColor(Color.alpha(Color.player, 0.2))
    else
        love.graphics.setColor(Color.white)
    end
    love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.r)
    Color.reset()
    love.graphics.draw(Image.warning, self.x, self.y)
end

return Warning