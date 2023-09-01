local M = {}

M.test = function()
  print("Yay it works!")
end

-- TODO - function to convert to bytes, kbytes, etc

-- TODO - function to convert temperature F->C or C->F (e.g. toggle between them?)

-- FIXME perhaps use a param for different time ranges (e.g. 5d in hours, or 7h in minutes)
M.convert = function(units)
  local data = vim.fn.expand("<cword>")
  print(data)
  if units == nil then
    units = 's'
  end

  local pattern = '^(%d+)([smhd])$' -- default is seconds
  if units == 'm' then
    pattern = '^(%d+)([mhd])$'
  elseif units == 'h' then
    pattern = '^(%d+)([hd])$'
  elseif units == 'd' then
    pattern = '^(%d+)(d)$'
  end

  local t, c = string.match(data, pattern)
  vim.print(t)
  vim.print(c)

  if (t == nil or c == nil) then
    print("no matching conversion pattern:" .. pattern)
    return
  end

  local multiplier = 1
  if c == "m" then
    if units == "s" then
      multiplier = 60
    end
  elseif c == "h" then
    if units == "s" then
      multiplier = 60 * 60
    elseif units == "m" then
      multiplier = 60
    end
  elseif c == "d" then
    if units == "s" then
      multiplier = 60 * 60 * 24
    elseif units == "m" then
      multiplier = 60 * 24
    elseif units == "h" then
      multiplier = 24
    end
  end

  t = t * multiplier

  print(t)

  print("before")
  local before = vim.fn.col('.')
  print(vim.fn.col('.'))
  print(vim.fn.col('$') - 1)

  -- works but if the conversion is at the end of the line then need to append to the line instead of using 'i'
  vim.cmd("normal! diw") --delete the current numbering section
  print("after")
  local after = vim.fn.col('.')
  print(vim.fn.col('.'))
  print(vim.fn.col('$') - 1)

  print('before:' .. before)
  print('after:' .. after)

  -- FIXME - finally fixed the calculation, clean up this line?
  local char = vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.')) -- get character under cursort after deletion
  print('char:"' .. char .. '"')
  if char ~= " " then
    -- at the end of the line just append
    print('appending')
    vim.cmd("normal! a" .. tostring(t))
  else
    --otherwise insert
    print('inserting')
    vim.cmd("normal! i" .. tostring(t))
  end
end

return M
