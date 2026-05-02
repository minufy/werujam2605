Game = {}

local shuffle_time = 120

function Game:add(Object, ...)
    local o = Object(...)
    local group_name = tostring(o)
    if self.objects[group_name] == nil then
        self.objects[group_name] = {}
    end
    table.insert(self.objects[group_name], o)
    return o
end

function Game:init()
    self.level_index = 1
    Edit:init()
    Level:init("1")
end

function Game:reset()
    self.shuffle = false
    self.objects = {}
    self.group_names = {}
    self.shuffle_timer = 0
    self.cursor = self:add(OBJECT_TABLE.cursor)
end

function Game:update(dt)
    Edit:update(dt)

    if not Edit.editing then
        Camera:set(0, 0)
        self.group_names = {}
        for group_name, _ in pairs(self.objects) do
            table.insert(self.group_names, group_name)
        end
        for _, group_name in ipairs(self.group_names) do
            local i = #self.objects[group_name]
            while i > 0 do
                local object = self.objects[group_name][i]
                if object.update then
                    object:update(dt)
                end
                if object.remove then
                    self.objects[group_name][i] = self.objects[group_name][#self.objects[group_name]]
                    self.objects[group_name][#self.objects[group_name]] = nil
                end
                i = i-1
            end
        end

        self.shuffle_timer = self.shuffle_timer+dt
        if self.shuffle_timer > shuffle_time and not self.shuffle then
            self.shuffle = true
            Camera:shake(3)
        end

        if self.shuffle and Input.space.pressed then
            if self:check() then
                self:next_level()
            end
        end
    else
        if Input.next_level.pressed or Input.prev_level.pressed then
            local d_index
            if Input.prev_level.pressed then
                d_index = -1
            end
            if Input.next_level.pressed then
                d_index = 1
            end
            local prev_level_index = self.level_index
            self.level_index = self.level_index+d_index
            Mouse:deselect_all()
            if not Level:load_level(tostring(self.level_index)) then
                self.level_index = prev_level_index
            end
        end
    end
end

function Game:next_level()
    SM:set_fade(function ()
        self.level_index = self.level_index+1
        if not Level:load_level(tostring(self.level_index)) then
            self.level_index = self.level_index-1
        end
    end)
end

function Game:check()
    for _, img in ipairs(self.objects["img"]) do
        if not img.ok then
            return false
        end
    end
    return true
end

function Game:draw_bg()
    love.graphics.setColor(0, 0, 0, 0.05)
    for x = 0, Res.w/TILE_SIZE do
        for y = 0, Res.h/TILE_SIZE do
            if (x+y)%2 == 0 then
                love.graphics.rectangle("fill", x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
    Color.reset()
end

local draw_order = {
    "particle",
    "img",
    "cursor",
}

function Game:draw()
    love.graphics.setColor(rgb(141, 163, 199))
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()
    
    Camera:start()
    self:draw_bg()

    Shader:start()
    
    for i, group_name in ipairs(draw_order) do
        if self.objects[group_name] ~= nil then
            for _, object in ipairs(self.objects[group_name]) do
                if object.draw then
                    object:draw()
                end
            end
        end
    end
    
    if Edit.editing then
        Edit:draw()
    end
    
    love.graphics.rectangle("fill", 0, 0, (1-self.shuffle_timer/shuffle_time)*Res.w, 4)
    if not self.shuffle then
        love.graphics.setFont(Font)
        love.graphics.print("remember...", 10, 10)
    else
        love.graphics.setFont(Font)
        love.graphics.print("replicate!", 10, 10)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.print("press [space] to confirm", 10, Res.h-Font:getHeight()-10)
        Color.reset()
    end
    
    Camera:stop()

    if Edit.editing then
        Edit:draw_hud()
    end

    Shader:stop()
end

return Game