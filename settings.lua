-- Input.right = NewInput({"right", "d"})
-- Input.left = NewInput({"left", "a"})
-- -- Input.up = NewInput({"up", "w"})
-- -- Input.down = NewInput({"down", "s"})
-- Input.jump = NewInput({"space", "up", "w", "lshift"})

Input.space = NewInput({"space"})

Camera.x_damp = 0.2
Camera.y_damp = 0.2
Camera.shake_damp = 0.4

TILE_TYPES = {
    "tile",
}
OBJECT_TYPES = {
    "cursor",
    -- "zone",
}
IMG_TYPES = {
    "diamond",
    "corner",
    "circle",
}

TILE_SIZE = 16
GRID_SIZE = TILE_SIZE
Shader.offset = 1

local object_align = {
    -- player = Bottom,
}
OBJECT_ALIGN = setmetatable(object_align, {
    __index = function (t, k)
        return None
    end
})