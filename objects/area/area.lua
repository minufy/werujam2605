local Area = Object:extend()

function Area:init_area()
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

function Area:update(dt)
    self.smooth_x = self.smooth_x+(self.x-self.smooth_x)*MOVE_DAMP*dt
    self.smooth_y = self.smooth_y+(self.y-self.smooth_y)*MOVE_DAMP*dt
end

function Area:push(dx, dy)
    self.old_x = self.x
    self.old_y = self.y
    self.x = self.x+dx
    self.y = self.y+dy
    Physics.col_tiles(self, self.cbs.col)
    Physics.col(self, FILTERS.area, self.cbs.col)
    Physics.col(self, FILTERS.player, self.cbs.player)
end

return Area