local Player = Object:extend()

NewImage("player")

function Player:new(data)
    self.x = data.x
    self.y = data.y
    self.smooth_x = self.x
    self.smooth_y = self.y
    self.old_x = self.x
    self.old_y = self.y
    self.w = TILE_SIZE
    self.h = TILE_SIZE

    self.cbs = {
        col = function (other)
            self.x = self.old_x
            self.y = self.old_y
        end,
        push = function (other)
            other:push(self.x-self.old_x, self.y-self.old_y)
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
    Physics.col_tiles(self, self.cbs.col)
    Physics.col(self, FILTERS.box, self.cbs.push)

    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*MOVE_DAMP*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*MOVE_DAMP*dt
end

function Player:draw()
    love.graphics.draw(Image.player, self.smooth_x, self.smooth_y)
end

function Player:push()
    self.x = self.old_x
    self.y = self.old_y
end

return Player