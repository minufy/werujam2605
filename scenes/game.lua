Game = {}

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
    Edit:init()
    Level:init("1")
end

function Game:reset()
    self.objects = {}
    self.group_names = {}
    self.input_on = true
end

local update_order = {
    "player",
    "body",
    "box",
    "fruit",
    "particle",
    "square_particle",
}

function Game:update(dt)
    Edit:update(dt)

    if not Edit.editing then
        for _, group_name in ipairs(update_order) do
            if self.objects[group_name] then
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
        end
    end
end

function Game:draw()
    love.graphics.setColor(Color.bg)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()
    
    Camera:start()
    -- Shader:start()
    
    for group_name, group in pairs(self.objects) do
        for _, object in ipairs(group) do
            if object.draw then
                object:draw()
            end
        end
    end
    
    if Edit.editing then
        Edit:draw()
    end
    
    Camera:stop()

    if Edit.editing then
        Edit:draw_hud()
    end

    -- Shader:stop()
end

return Game