local lume = require("modules.lume")

Game = {}

NewImage("heart")
NewImage("bg")

local shuffle_time = 60*4
local musics = {
    love.audio.newSource("assets/audio/music/1.ogg", "stream"),
    love.audio.newSource("assets/audio/music/2.ogg", "stream"),
    love.audio.newSource("assets/audio/music/3.ogg", "stream"),
}

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
    for i, type in ipairs(SHAPE_TYPES) do
        NewImage(type)
    end
    self.level_index = 1
    self.health = 3
    Edit:init()
    Level:init(tostring(self.level_index))
end

function Game:before_reload()
    self.shuffle = false
    self.touched = false
    self.objects = {}
    self.group_names = {}
    self.shape_types = lume.shuffle(lume.clone(SHAPE_TYPES))
    self.shuffle_timer = 0
    self:add(OBJECT_TABLE.cursor)
    self:add(OBJECT_TABLE.remove, {x = Res.w-TILE_SIZE, y = Res.h-TILE_SIZE})
    Music.source = musics[math.random(1, #musics)]
    Music.source:stop()
    Music.source:play()
end

function Game:after_reload()
    if self.objects["shape"] then
        self.shape_count = #self.objects["shape"]
    else
        self.shape_count = 0
    end
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

        if self.shuffle and Input.space.pressed and self.touched then
            if self:check() then
                Audio.ok:play()
                self:next_level()
            else
                Audio.bad:play()
                self:damage()
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

function Game:damage()
    for _ = 1, 4 do
        Game:add(Particle, 10*self.health+4, 20+4, math.random(-10, 10), math.random(-10, 10), math.random(4, 10), Color.heart)
    end
    self.health = self.health-1
    if self.health == 0 then
        SM:set_fade(function ()
            SM:load("game_over")
        end)
    end
    Camera:shake(2)
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
    if self.objects["shape"] and #self.objects["shape"] < self.shape_count then
        return false
    end
    if self.objects["fake_shape"] and #self.objects["fake_shape"] > 0 then
        return false
    end
    for _, shape in ipairs(self.objects["shape"]) do
        if not shape.ok then
            return false
        end
    end
    return true
end

function Game:get_type()
    return table.remove(self.shape_types)
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
    "fake_shape",
    "shape",
    "remove",
    "tile",
    "cursor",
}

function Game:draw()
    Camera:start()
    
    love.graphics.draw(Image.bg)
    self:draw_bg()

    Shader:start()
    
    love.graphics.setColor(Color.fg)
    love.graphics.rectangle("fill", 0, 0, (1-self.shuffle_timer/shuffle_time)*Res.w, 4)
    Color.reset()
    love.graphics.setColor(Color.fg)
    love.graphics.setFont(Font)
    local s
    s = "level "..self.level_index
    love.graphics.print(s, Res.w-10-Font:getWidth(s), 10)
    if not self.shuffle then
        love.graphics.setColor(Color.fg)
        love.graphics.setFont(Font)
        love.graphics.print("remember...", 10, 10)
        Color.reset()
    else
        love.graphics.setFont(Font)
        love.graphics.print("replicate!", 10, 10)
        love.graphics.setColor(Color.alpha(Color.fg, 0.5))
        love.graphics.print("press [space] to confirm", 10, Res.h-Font:getHeight()-10)
        Color.reset()
    end

    for i = 1, self.health do
        love.graphics.draw(Image.heart, i*10, 20)
    end

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
    
    Camera:stop()

    if Edit.editing then
        Edit:draw_hud()
    end

    Shader:stop()
end

return Game