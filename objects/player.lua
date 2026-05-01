local Player = Object:extend()

local Body = require("objects.body")
SetType(Body, "body")

NewImage("player")
local gap = 3

function Player:new(data)
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.old_x = self.x
    self.old_y = self.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE

    self.dx = TILE_SIZE
    self.dy = 0

    self.trails = {}
    for x = TILE_SIZE*3, TILE_SIZE, -TILE_SIZE do
        table.insert(self.trails, {x = self.x-x, y = self.y})
    end
    self.bodies = {}
    table.insert(self.bodies, Game:add(Body, self.x-TILE_SIZE, self.y, gap))
    self.cbs = {
        col = function (other)
            self.x = self.old_x
            self.y = self.old_y
        end,
        push = function (other)
            other:push(self.x-self.old_x, self.y-self.old_y)
        end,
        fruit = function (other)
            other.remove = true
            self:grow()
        end,
        body = function (other)
            self:die()
        end,
    }

    if not Edit.editing then
        Camera:set(0, 0)
        Camera:snap_back()
    end
end

function Player:update(dt)
    self.old_x = self.x
    self.old_y = self.y
    local dx = 0
    local dy = 0
    if Input.left.pressed then
        self.x = self.x-TILE_SIZE
    end
    if Input.right.pressed then
        self.x = self.x+TILE_SIZE
    end
    if Input.up.pressed then
        self.y = self.y-TILE_SIZE
    end
    if Input.down.pressed then
        self.y = self.y+TILE_SIZE
    end
    dx = self.x-self.old_x
    dy = self.y-self.old_y
    if dx ~= 0 or dy ~= 0 then
        if dx == -self.dx and dy == -self.dy then
            self.x = self.x-dx
            self.y = self.y-dy
        else
            self.dx = dx
            self.dy = dy
        end
    end
    
    Physics.col_tiles(self, self.cbs.col)
    Physics.col(self, FILTERS.box, self.cbs.push)
    Physics.col(self, FILTERS.body, self.cbs.body)
    Physics.col(self, FILTERS.fruit, self.cbs.fruit)

    if self.old_x ~= self.x or self.old_y ~= self.y then
        table.insert(self.trails, {x = self.old_x, y = self.old_y})
        local old_x = self.old_x
        local old_y = self.old_y
        for i = 1, #self.bodies do
            local temp_x = self.bodies[i].x
            local temp_y = self.bodies[i].y
            self.bodies[i].x = old_x
            self.bodies[i].y = old_y
            old_x = temp_x
            old_y = temp_y
        end
    end
    
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*MOVE_DAMP*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*MOVE_DAMP*dt

end

function Player:draw_trail()
    local m = #self.trails-#self.bodies
    for i = m, m-#self.bodies, -1 do
        if i < 1 then
            break
        end
        local trail = self.trails[i]
        local a = (i-(m-#self.bodies)+1)/(#self.bodies+1)/2
        love.graphics.setColor(Color.alpha(Color.player, a))
        love.graphics.rectangle("fill", trail.x+gap, trail.y+gap, TILE_SIZE-gap*2, TILE_SIZE-gap*2)
        Color.reset()
    end
end

function Player:draw()
    self:draw_trail()
    love.graphics.setColor(Color.player)
    Color.reset()

    love.graphics.draw(Image.player, self.smooth_x, self.smooth_y)
end

function Player:push()
    self.x = self.old_x
    self.y = self.old_y
end

function Player:grow()
    for i = #self.trails-#self.bodies, #self.trails-#self.bodies*2, -1 do
        if i < 1 then
            return
        end
        local trail = self.trails[i]
        table.insert(self.bodies, Game:add(Body, trail.x, trail.y, gap, self))
    end
end

function Player:die()
    self.remove = true
    for i, body in ipairs(self.bodies) do
        body:die()
    end
end

return Player