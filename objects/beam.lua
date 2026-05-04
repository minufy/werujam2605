local Beam = Object:extend()

Beam:implement(require("objects.shape.shape"))

NewImage("beam")
NewImage("laser")
NewImage("laser_front")
NewImage("laser_left")
NewImage("laser_right")

function Beam:new(data)
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.draw_x = 0
    self.draw_y = 0
    self.w = Image.beam:getWidth()
    self.h = Image.beam:getHeight()
    self.dir = data.dir or 0
    self.r = self.dir*math.pi/2
    self:shape_init()

    self.laser = {}
    self.laser.dir = self.dir
    self.laser.x = self.x
    self.laser.y = self.y
    self.laser.w = self.w
    self.laser.h = self.h
    self.laser.d = 0

    self.cbs = {
        mirror = function (other)
            if other.held then
                return
            end
            local m = 1
            if other.dir == 1 or other.dir == 3 then
                m = -1
            end
            if self.laser.dir == 0 or self.laser.dir == 2 then
                self:dir_laser(-m)
            elseif self.laser.dir == 1 or self.laser.dir == 3 then
                self:dir_laser(m)
            end
        end,
    }
end

function Beam:update(dt)
    self:shape_update(dt)
end

function Beam:move_laser()
    if self.laser.dir == 0 then
        self.laser.x = self.laser.x+TILE_SIZE
    elseif self.laser.dir == 1 then
        self.laser.y = self.laser.y+TILE_SIZE
    elseif self.laser.dir == 2 then
        self.laser.x = self.laser.x-TILE_SIZE
    elseif self.laser.dir == 3 then
        self.laser.y = self.laser.y-TILE_SIZE
    end
end

function Beam:dir_laser(d)
    self.laser.dir = self.laser.dir+d
    self.laser.d = d
    if self.laser.dir > 3 then
        self.laser.dir = 0
    elseif self.laser.dir < 0 then
        self.laser.dir = 3
    end
end

function Beam:draw()
    if math.abs(self.smooth_x-self.x)+math.abs(self.smooth_y-self.y) < 1 and not self.held then
        self.laser.x = self.x
        self.laser.y = self.y
        self.laser.dir = self.dir
        love.graphics.draw(Image.laser_front, self.laser.x+TILE_SIZE/2, self.laser.y+TILE_SIZE/2, self.laser.dir*math.pi/2, 1, 1, TILE_SIZE/2, TILE_SIZE/2)
        for i = 1, 64 do
            self:move_laser()
            self.laser.d = 0
            Physics.col(self.laser, FILTERS.mirror, self.cbs.mirror)
            local img = Image.laser
            if self.laser.d > 0 then
                img = Image.laser_right
            elseif self.laser.d < 0 then
                img = Image.laser_left
            end
            love.graphics.draw(img, self.laser.x+TILE_SIZE/2, self.laser.y+TILE_SIZE/2, self.laser.dir*math.pi/2, 1, 1, TILE_SIZE/2, TILE_SIZE/2)
        end
    end
    love.graphics.draw(Image.beam, self.smooth_x+self.draw_x, self.smooth_y+self.draw_y, self.r)
end

function Beam:make_path()
    local path = ""
    self.laser.x = self.x
    self.laser.y = self.y
    self.laser.dir = self.dir
    for i = 1, 64 do
        self:move_laser()
        Physics.col(self.laser, FILTERS.mirror, self.cbs.mirror)
        path = path.."|"..self.laser.x..","..self.laser.y
    end
    return path
end

return Beam