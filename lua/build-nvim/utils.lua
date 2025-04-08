return {
    popup = function(command, on_exit)
        require("toggleterm.terminal").Terminal:new({
            direction = "float",
            cmd = command,
            hidden = false,
            close_on_exit = false,
            on_exit = function (terminal, j, code, n)
                if code == 0 then
                    terminal:close()
                    if on_exit then on_exit() end
                end
            end
        }):toggle()
    end,
}