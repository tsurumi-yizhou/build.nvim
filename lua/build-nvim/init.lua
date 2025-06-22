local M = {}

-- 存储适配器和配置
M.adapters = {}
M.configurations = {}

-- 初始化函数
function M.setup(opts)
    -- 确保overseer已加载
    local ok, overseer = pcall(require, "overseer")
    if not ok then
        vim.notify("overseer.nvim is required for build.nvim", vim.log.levels.ERROR)
        return
    end

    -- 注册overseer组件
    M.opts = opts or {}
    if M.opts.overseer_components then
        for _, component in ipairs(M.opts.overseer_components) do
            overseer.register_template(component)
        end
    end
end

-- 构建函数
function M.build(config_key)
    -- 如果没有提供配置键，则尝试查找匹配当前工作目录的配置
    if not config_key or config_key == "" then
        vim.notify("No configuration found for current working directory", vim.log.levels.ERROR)
        return
    end

    -- 获取配置
    local config = M.configurations[config_key]
    if not config then
        vim.notify("Configuration '" .. config_key .. "' not found", vim.log.levels.ERROR)
        return
    end

    -- 获取适配器
    local adapter = M.adapters[config.adapter]
    if not adapter then
        vim.notify("Adapter '" .. config.adapter .. "' not found", vim.log.levels.ERROR)
        return
    end

    if not adapter.build then
        vim.notify("Adapter '" .. config.adapter .. "' does not support build", vim.log.levels.ERROR)
        return
    end

    -- 调用适配器的构建函数，获取构建命令
    local ok, overseer = pcall(require, "overseer")
    if not ok then
        vim.notify("overseer.nvim is required for build.nvim", vim.log.levels.ERROR)
        return
    end

    -- 设置工作目录
    local cwd = config.cwd or vim.fn.getcwd()
    
    -- 获取构建命令
    local cmd = adapter.build(config_key)
    
    if not cmd then
        vim.notify("Failed to get build command for '" .. config_key .. "'", vim.log.levels.ERROR)
        return
    end
    
    -- 使用overseer执行命令
    local task_opts = {
        cmd = cmd,
        cwd = cwd,
        name = "Building " .. (config.name or config_key),
    }

    if M.opts.overseer_components then
        task_opts.components = M.opts.overseer_components
    end

    overseer.new_task(task_opts)

    vim.notify("Building '" .. (config.name or config_key) .. "'", vim.log.levels.INFO)
end

-- 清理函数
function M.clean(adapter_name)
    -- 获取适配器
    local adapter = M.adapters[adapter_name]
    if not adapter then
        vim.notify("Adapter '" .. adapter_name .. "' not found", vim.log.levels.ERROR)
        return
    end

    if not adapter.clean then
        vim.notify("Adapter '" .. adapter_name .. "' does not support clean", vim.log.levels.ERROR)
        return
    end

    -- 调用适配器的清理函数，获取清理命令
    local ok, overseer = pcall(require, "overseer")
    if not ok then
        vim.notify("overseer.nvim is required for build.nvim", vim.log.levels.ERROR)
        return
    end

    -- 设置工作目录
    local cwd = vim.fn.getcwd()

    -- 获取清理命令
    local cmd = adapter.clean()
    
    if not cmd then
        vim.notify("Failed to get clean command for adapter '" .. adapter_name .. "'", vim.log.levels.ERROR)
        return
    end
    
    -- 使用overseer执行命令
    local task_opts = {
        cmd = cmd,
        cwd = cwd,
        name = "Cleaning with adapter " .. adapter_name,
    }

    if M.opts.overseer_components then
        task_opts.components = M.opts.overseer_components
    end

    overseer.new_task(task_opts)

    vim.notify("Cleaning with adapter '" .. adapter_name .. "'", vim.log.levels.INFO)
end

-- 停止构建函数
function M.stop()
    local ok, overseer = pcall(require, "overseer")
    if not ok then
        vim.notify("overseer.nvim is required for build.nvim", vim.log.levels.ERROR)
        return
    end

    -- 停止所有运行中的任务
    local tasks = overseer.list_tasks()
    local stopped = false

    for _, task in ipairs(tasks) do
        if task:is_running() then
            task:stop()
            stopped = true
        end
    end

    if stopped then
        vim.notify("Stopped running build tasks", vim.log.levels.INFO)
    else
        vim.notify("No running build tasks found", vim.log.levels.INFO)
    end
end

return M
