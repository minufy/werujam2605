local Fruit = Object:extend()

NewImage("fruit")

function Fruit:new(data)
    self.x = data.x
    self.y = data.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE
    
    if not Edit.editing then
        for _ = 1, 3 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-5, 5), math.random(-5, 5), math.random(6, 8), Color.player)
        end
    end
end

function Fruit:draw()
    love.graphics.draw(Image.fruit, self.x, self.y+SinEffect())
end

return Fruit