SM = {}

function SM:init()
    self.fade_in = 0
    self.fading_in = false
    self.fade_out = 0
    self.fading_out = false
    self.fade_cb = nil
    self.global_volume_alpha = 0
end

function SM:load(name)
    self.current = require("scenes."..name)
    self.current:init()
end

FADE_TIME = 20
function SM:update(dt)
    if self.fading_in then
        self.fade_in = self.fade_in+dt
        if self.fade_in > FADE_TIME then
            self:fade_cb()
            self.fade_cb = nil
            self.fading_in = false
            self.fading_out = true
            Audio.fade:play(0.6)
        end
    end
    if self.fading_out then
        self.fade_out = self.fade_out+dt
        if self.fade_out > FADE_TIME then
            self.fading_out = false
        end
    end
    self.current:update(dt)

    if not Edit.editing then
        if Input.wheel.up then
            Audio:change_global_volume(1)
            self.global_volume_alpha = 1
            Audio.volume:play(0.5, Audio.global_volume+1)
        end
        if Input.wheel.down then
            Audio:change_global_volume(-1)
            self.global_volume_alpha = 1
            Audio.volume:play(0.5, Audio.global_volume+1)
        end
        self.global_volume_alpha = self.global_volume_alpha-self.global_volume_alpha*0.05*dt
    end
    Music:update()
end

function SM:draw()
    self.current:draw()
    if self.fading_in then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", Res.w*(EaseOut(self.fade_in/FADE_TIME)-1), 0, Res.w, Res.h)
        Color.reset()
    end
    if self.fading_out then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", Res.w*EaseOut(self.fade_out/FADE_TIME), 0, Res.w, Res.h)
        Color.reset()
    end
    love.graphics.setFont(Font)
    love.graphics.setColor(Color.alpha(Color.fg, self.global_volume_alpha))
    local s = "volume: "..Audio.global_volume
    love.graphics.print(s, Res.w-10-Font:getWidth(s), 10+Font:getHeight())
    Color.reset()
end

function SM:reset_fade()
    self.fade_in = 0
    self.fade_out = 0
    self.fading_in = true
    self.fading_out = false
    Audio.fade:play(0.6)
end

function SM:set_fade(func)
    if self.fading_in then
        return
    end
    self.fade_cb = func
    self:reset_fade()
end

SM:init()