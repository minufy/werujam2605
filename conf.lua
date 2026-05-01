WINDOW_W = 128
WINDOW_H = 128
CONSOLE = true

function love.conf(t)
    t.console = CONSOLE
    t.window.resizable = true
    t.window.width = WINDOW_W*4
    t.window.height = WINDOW_H*4
    t.window.title = "werujam2505"
end