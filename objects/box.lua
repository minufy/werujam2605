local Box = Object:extend()

NewImage("box")

function Box:new(data)
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
        player = function (other)
            other:push()
        end,
    }
end

function Box:update(dt)
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*MOVE_DAMP*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*MOVE_DAMP*dt
end

function Box:draw()
    love.graphics.draw(Image.box, self.smooth_x, self.smooth_y)
end

function Box:push(dx, dy)
    self.old_x = self.x
    self.old_y = self.y
    self.x = self.x+dx
    self.y = self.y+dy
    Physics.col_tiles(self, self.cbs.col)
    Physics.col(self, FILTERS.box, self.cbs.col)
    Physics.col(self, FILTERS.player, self.cbs.player)
end

return Box