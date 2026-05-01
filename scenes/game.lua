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
    self.health_time = 0
    self.health_timer = 1
    self.input_on = true
    self.dead = false
    self.text_bounce = TILE_SIZE
end

local update_order = {
    "player",
    "body",
    "fruit",
    "warning",
    "particle",
    "circle_particle",
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
    
    if self.dead then
        self.text_bounce = self.text_bounce-self.text_bounce*0.2*dt
        if Input.restart.pressed then
            Level:reload()
        end
    end
end

local draw_order = {
    "player",
    "body",
    "fruit",
    "particle",
    "circle_particle",
    "tiles",
    "zone",
    "warning",
}

function Game:draw()
    love.graphics.setColor(Color.bg)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    Color.reset()
    
    Camera:start()
    -- Shader:start()

    for _, group_name in ipairs(draw_order) do
        if self.objects[group_name] then
            for i, object in ipairs(self.objects[group_name]) do
                if object.draw then
                    object:draw()
                end
            end
        end
    end
    
    if Edit.editing then
        Edit:draw()
    end
    
    love.graphics.setColor(Color.player)
    love.graphics.rectangle("fill", 0, 0, (1-self.health_timer/self.health_time)*Res.w, 4)
    Color.reset()
    
    if self.dead then
        love.graphics.setColor(Color.white)
        love.graphics.setFont(Font)
        love.graphics.print("press [r] to restart", 10, 10-self.text_bounce)
        Color.reset()
    end

    Camera:stop()

    if Edit.editing then
        Edit:draw_hud()
    end

    -- Shader:stop()
end

return Game