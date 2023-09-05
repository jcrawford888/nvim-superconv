if 1 ~= vim.fn.has "nvim-0.9.0" then
  vim.api.nvim_err_writeln "nvim-superconv.nvim requires at least nvim-0.9.0."
  return
end

if vim.g.loaded_nvim_superconv == 1 then
  return
end
vim.g.loaded_nvim_superconv = 1

vim.api.nvim_create_user_command("Superconv", function(opts)
  require("nvim-superconv").run(opts)
end, {
  nargs = 1,
  complete = function(_, line)
    local builtin_list = vim.tbl_keys(require "nvim-superconv")

    -- Remove the 'run' routine from the list
    local toremove = nil
    for i = 1, #builtin_list do
      if builtin_list[i] == "run" then
        toremove = i
        break
      end
    end

    table.remove(builtin_list, toremove)

    local l = vim.split(line, "%s+")
    local n = #l - 2

    if n == 0 then
      local commands = vim.tbl_flatten { builtin_list }
      table.sort(commands)

      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[2])
      end, commands)
    end
  end,
})
