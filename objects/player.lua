local Player = Object:extend()

local Body = require("objects.body")
SetType(Body, "body")

NewImage("player")

local gap = 3
local move_time = 6
local health_time = 55

local function clamp(x)
    return math.min(math.max(1, x), Res.w/TILE_SIZE-2)
end

function Player:new(data)
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.old_x = self.x
    self.old_y = self.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE

    self.current_x = 1
    self.current_y = 0
    self.next_x = 0
    self.next_y = 0

    self.dx = TILE_SIZE
    self.dy = 0

    self.trails = {}
    for x = TILE_SIZE*3, TILE_SIZE, -TILE_SIZE do
        table.insert(self.trails, {x = self.x-x, y = self.y})
    end
    self.bodies = {}
    table.insert(self.bodies, Game:add(Body, self.x-TILE_SIZE, self.y, gap, self, #self.bodies))

    self.move_timer = Timer(move_time)
    self.health_timer = Timer(health_time)

    self.input_queue = {}

    self.cbs = {
        col = function (other)
            self:die()
        end,
        fruit = function (other)
            other.remove = true
            self:grow()
            self:new_fruit()
        end,
        body = function (other)
            self:cut(other)
        end,
    }

    if not Edit.editing then
        Camera:set(0, 0)
        Camera:snap_back()
    end
end

function Player:update(dt)
    local ix = 0
    local iy = 0
    if Input.left.pressed then
        ix = ix-1
    end
    if Input.right.pressed then
        ix = ix+1
    end
    if Input.up.pressed then
        iy = iy-1
    end
    if Input.down.pressed then
        iy = iy+1
    end
    if #self.input_queue < 4 then
        if ix ~= 0 then
            table.insert(self.input_queue, {x = ix, y = 0})
        elseif iy ~= 0 then
            table.insert(self.input_queue, {x = 0, y = iy})
        end
    end
    
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*MOVE_DAMP*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*MOVE_DAMP*dt
    
    Game.health_timer = self.health_timer.timer
    Game.health_time = self.health_timer.time
    if self.health_timer:run(dt) then
        if #self.bodies > 0 then
            table.remove(self.bodies, #self.bodies):die()
        else
            self:die()
        end
    end
    if self.move_timer:run(dt) then
        if #self.input_queue > 0 then
            local input = table.remove(self.input_queue, 1)
            if input.x ~= 0 and input.x ~= -self.current_x then
                self.current_x = input.x
                self.current_y = 0
            elseif input.y ~= 0 and input.y ~= -self.current_y then
                self.current_x = 0
                self.current_y = input.y
            end
        end
        self.old_x = self.x
        self.old_y = self.y

        self.x = self.x+self.current_x*TILE_SIZE
        self.y = self.y+self.current_y*TILE_SIZE
        
        Physics.col_tiles(self, self.cbs.col)        
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
    end
end

function Player:new_fruit()
    local d = math.round(math.sqrt(health_time/move_time*#self.bodies))
    local tx = math.round(self.x/TILE_SIZE)
    local ty = math.round(self.y/TILE_SIZE)
    local x = math.random(clamp(tx-d), clamp(tx+d))*TILE_SIZE
    local y = math.random(clamp(ty-d), clamp(ty+d))*TILE_SIZE
    Game:add(OBJECT_TABLE.fruit, {x = x, y = y})
    Camera:shake(1)
    if math.random(1, 100) <= 45 then
        local wx = math.random(1, Res.w/TILE_SIZE-2)*TILE_SIZE
        local wy = math.random(1, Res.w/TILE_SIZE-2)*TILE_SIZE
        Game:add(OBJECT_TABLE.warning, {x = wx, y = wy})
    end
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

-- function Player:push()
--     self:die()
-- end

function Player:grow()
    for i = #self.trails-#self.bodies, #self.trails-#self.bodies*2, -1 do
        if i < 1 then
            return
        end
        local trail = self.trails[i]
        table.insert(self.bodies, Game:add(Body, trail.x, trail.y, gap, self, #self.bodies))
    end
end

function Player:die()
    self.remove = true
    Game.dead = true
    Game:add(Particle, self.old_x+self.w/2, self.old_y+self.h/2, math.random(-5, 5), math.random(-5, 5), math.random(6, 8), Color.player)
    Camera:shake(2)
    for i, body in ipairs(self.bodies) do
        body:die()
    end
end

function Player:cut(other)
    for i = #self.bodies, other.i, -1 do
        table.remove(self.bodies, i):die()
    end
end

return Player