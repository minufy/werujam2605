Input.right = NewInput({"right", "d"})
Input.left = NewInput({"left", "a"})
Input.up = NewInput({"up", "w"})
Input.down = NewInput({"down", "s"})
Input.restart = NewInput({"r"})

Camera.x_damp = 0.2
Camera.y_damp = 0.2
Camera.shake_damp = 0.6

TILE_TYPES = {
    "tile",
}
OBJECT_TYPES = {
    "player",
    "fruit",
    "warning",
    "zone",
}
IMG_TYPES = {
    -- "test",
}

TILE_SIZE = 8
GRID_SIZE = TILE_SIZE
MOVE_DAMP = 0.4
FILTERS = {
    player = {"player"},
    fruit = {"fruit"},
    body = {"body"},
}

local object_align = {
    -- player = Bottom,
}
OBJECT_ALIGN = setmetatable(object_align, {
    __index = function (t, k)
        return None
    end
})