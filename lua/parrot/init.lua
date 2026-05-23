local M = {}

M.config = {
  parrot_cmd = nil,
  gcc_flags = "-Wall -Wextra",
  auto_fmt_on_save = false,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  if not M.config.parrot_cmd then
    local paths = { "./parrot", "parrot", "../src/parrot" }
    for _, p in ipairs(paths) do
      local handle = io.popen("which " .. p .. " 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result ~= "" then
          M.config.parrot_cmd = p
          break
        end
      end
    end
  end
  if M.config.auto_fmt_on_save then
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.pt",
      callback = function()
        M.format()
      end,
    })
  end
  vim.api.nvim_create_user_command("ParrotBuild", function()
    M.build()
  end, {})
  vim.api.nvim_create_user_command("ParrotRun", function()
    M.run()
  end, {})
  vim.api.nvim_create_user_command("ParrotFmt", function()
    M.format()
  end, {})
end

local function get_parrot_cmd()
  if not M.config.parrot_cmd then
    vim.notify("Parrot: no se encontro 'parrot' en el PATH. Configura parrot_cmd.", vim.log.levels.ERROR)
    return nil
  end
  return M.config.parrot_cmd
end

local function get_buf_path()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then
    vim.notify("Parrot: guarda el archivo primero", vim.log.levels.WARN)
    return nil
  end
  return path
end

function M.transpile(path)
  local cmd = get_parrot_cmd()
  if not cmd or not path then return false end
  local out = path:gsub("%.pt$", ".c")
  local pcmd = cmd .. " " .. vim.fn.shellescape(path) .. " " .. vim.fn.shellescape(out)
  local ret = vim.fn.system(pcmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Parrot transpilacion fallo:\n" .. ret, vim.log.levels.ERROR)
    return false
  end
  return true, out, ret
end

function M.build(path)
  path = path or get_buf_path()
  if not path then return end
  local ok, out = M.transpile(path)
  if not ok then return end
  local bin = out:gsub("%.c$", "")
  local cmd = string.format("gcc %s -o %s %s", M.config.gcc_flags, vim.fn.shellescape(bin), vim.fn.shellescape(out))
  local ret = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Parrot compilacion fallo:\n" .. ret, vim.log.levels.ERROR)
    return false
  end
  vim.notify("Parrot: " .. bin .. " compilado exitosamente", vim.log.levels.INFO)
  return true, bin
end

function M.run(path)
  path = path or get_buf_path()
  if not path then return end
  local ok, bin = M.build(path)
  if not ok then return end
  M.config.parrot_cmd = get_parrot_cmd()
  local term_opts = { clear_env = false }
  local cmd = bin
  if not cmd:match("^/") then cmd = "./" .. cmd end
  if vim.fn.executable("gcc") == 1 then
    vim.cmd("terminal " .. vim.fn.shellescape(cmd))
  else
    vim.notify("Parrot: gcc no encontrado en PATH", vim.log.levels.ERROR)
  end
end

function M.format(path)
  path = path or get_buf_path()
  if not path then return end
  local cmd = get_parrot_cmd()
  if not cmd then return end
  local fmt_cmd = cmd .. " --fmt " .. vim.fn.shellescape(path)
  local ret = vim.fn.system(fmt_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Parrot fmt fallo:\n" .. ret, vim.log.levels.ERROR)
    return
  end
  local lines = vim.split(ret, "\n")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.notify("Parrot: formateado", vim.log.levels.INFO)
end

return M
