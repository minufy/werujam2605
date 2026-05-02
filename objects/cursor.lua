local Cursor = Object:extend()

NewImage("cursor")

local filters = {
    img = {"img"}
}

function Cursor:new()
    self.x = 0
    self.y = 0
    self.w = 1
    self.h = 1
    self.grabbed = nil
    self.original_x = 0
    self.original_y = 0

    self.cbs = {
        grab = function (other)
            self.grabbed = other
            self.original_x = self.grabbed.x
            self.original_y = self.grabbed.y
            Game.touched = true
        end,
    }
end

function Cursor:update(dt)
    local dx = self.x
    local dy = self.y
    self.x = Res:get_x()
    self.y = Res:get_y()
    dx = self.x-dx
    dy = self.y-dy
    
    if Game.shuffle then
        if Input.mb[1].pressed then
            Physics.col(self, filters.img, self.cbs.grab)
        end
        if Input.mb[1].released then
            if self.grabbed then
                self.grabbed:place(self.original_x, self.original_y, self.cbs.place)
                self.grabbed = nil
            end
        end
    end

    if self.grabbed then
        self.grabbed.x = self.grabbed.x+dx
        self.grabbed.y = self.grabbed.y+dy
    end
end

function Cursor:draw()
    if self.grabbed then
        love.graphics.setColor(Color.alpha(Color.fg, 0.2))
        love.graphics.rectangle("fill", math.round_s(self.grabbed.x, TILE_SIZE), math.round_s(self.grabbed.y, TILE_SIZE), TILE_SIZE, TILE_SIZE)
        Color.reset()
    end
    love.graphics.draw(Image.cursor, self.x, self.y)
end

return Cursor