WINDOW_W = 128
WINDOW_H = 128
CONSOLE = true

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W*4
    t.window.height = WINDOW_H*4
end