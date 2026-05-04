return {
    -- basic settings:
    name = "replicate", -- name of the game for your executable
    developer = "minufy", -- dev name used in metadata of the file
    output = "dist", -- output location for your game, defaults to $SAVE_DIRECTORY
    version = "01", -- "version" of your game, used to name the folder in output
    love = "11.5", -- version of LÖVE to use, must match github releases
    ignore = {"dist", "ignoreme.txt"}, -- folders/files to ignore in your project
    icon = "assets/imgs/mirror.png", -- 256x256px PNG icon for game, will be converted for you
    platforms = {"windows"},
}