local Player = Object:extend()

NewImage("player")

local mx_damp = 0.5
local gravity = 0.1
local jump_force = 2

function Player:new(data)
    self.x = data.x
    self.y = data.y
    self.w = Image.player:getWidth()
    self.h = Image.player:getHeight()

    self.mx = 0
    self.vy = 0
    self.gravity = gravity

    self.cbs = {
        x = function (other)
            Physics.solve_x(self, self.mx, other)
        end,
        y = function (other)
            Physics.solve_y(self, self.vy, other)
        end,
    }

    if not Edit.editing then
        Camera:offset(Res.w/2, Res.h/2)
        Camera:set(self.x+self.w/2, self.y+self.h/2)
        Camera:snap_back()
    end
end

function Player:update(dt)
    Camera:set(self.x+self.w/2, self.y+self.h/2)
    local ix = 0
    if Input.right.down then
        ix = ix+1
    end
    if Input.left.down then
        ix = ix-1
    end
    self.mx = self.mx+(ix-self.mx)*mx_damp*dt
    self.x = self.x+self.mx
    Physics.col_tiles(self, self.cbs.x)
    
    self.vy = self.vy+self.gravity*dt
    self.y = self.y+self.vy
    Physics.col_tiles(self, self.cbs.y)
    
    if Input.jump.pressed then
        self:jump()
    end
    if Input.jump.pressed then
        self.gravity = gravity/2
    else
        self.gravity = gravity
    end
end

function Player:draw()
    love.graphics.draw(Image.player, self.x, self.y)
end

function Player:jump()
    self.vy = -jump_force
end

return Player