local M = {}

local replacedata = function(data)
  vim.cmd("normal! diw")                                                 --delete the current numbering section
  local char = vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.')) -- get character under cursor after deletion
  local action = "i"
  if char ~= " " then
    -- at the end of the line just append
    action = "a"
  end
  -- inject the converted time into the buffer
  vim.cmd("normal! " .. action .. tostring(data))
end

local convert_time = function(units)
  local data = vim.fn.expand("<cword>")
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
      multiplier = 60 ^ 2
    elseif units == "m" then
      multiplier = 60
    end
  elseif c == "d" then
    if units == "s" then
      multiplier = 60 ^ 2 * 24
    elseif units == "m" then
      multiplier = 60 * 24
    elseif units == "h" then
      multiplier = 24
    end
  end
  t = t * multiplier

  replacedata(t)
end

local convert_data_units = function(units)
  local data = vim.fn.expand("<cword>")
  local pattern = '^(%d+)([KMGT])B$'

  local t, u = string.match(data, pattern)

  if (t == nil or u == nil) then
    print("no matching conversion pattern:" .. pattern)
    return
  end

  if units == nil then
    units = 'B'
  end

  local multiplier = 1
  if u == 'K' then
    if units == "B" then
      multiplier = 1024
    else
      -- no change
      print("no change. Desired unit:" .. units .. "B is >= to current unit: " .. u .. "B")
      return
    end
  elseif u == 'M' then
    if units == "B" then
      multiplier = 1024 ^ 2
    elseif units == "K" then
      multiplier = 1024
    else
      -- no change
      print("no change. Desired unit:" .. units .. "B is >= to current unit: " .. u .. "B")
      return
    end
  elseif u == 'G' then
    if units == "B" then
      multiplier = 1024 ^ 3
    elseif units == "K" then
      multiplier = 1024 ^ 2
    elseif units == "M" then
      multiplier = 1024
    else
      -- no change
      print("no change. Desired unit:" .. units .. "B is >= to current unit: " .. u .. "B")
      return
    end
  elseif u == 'T' then
    if units == "B" then
      multiplier = 1024 ^ 4
    elseif units == "K" then
      multiplier = 1024 ^ 3
    elseif units == "M" then
      multiplier = 1024 ^ 2
    elseif units == "G" then
      multiplier = 1024
    else
      -- no change
      print("no change. Desired unit:" .. units .. "B is >= to current unit: " .. u .. "B")
      return
    end
  end

  t = t * multiplier

  if units == 'B' then
    replacedata(t)
  else
    replacedata(tostring(t) .. units .. 'B')
  end
end

local toggle_temp = function()
  -- add . to iskeyword and remove at the end

  local iskeyword_orig = vim.opt.iskeyword
  vim.opt.iskeyword:append(".")
  local data = vim.fn.expand("<cword>")


  local pattern = '^(.+)([FfCc])$'

  local t, u = string.match(data, pattern)

  if (t == nil or u == nil) then
    print("no matching conversion pattern:" .. pattern)
    return
  end

  local temp = tonumber(t)
  if string.lower(u) == 'c' then
    -- currently celcius, convert to fahrenheit
    temp = temp * 9 / 5 + 32
    outchar = 'F'
  else
    -- currently fahrenheit, convert to celcius
    temp = (temp - 32) * 5 / 9
    outchar = 'C'
  end

  replacedata(tostring(temp) .. outchar)

  vim.opt.iskeyword = iskeyword_orig -- reset iskeyword to original
end

-- API functions
-- time conversions
M.conv_sec = function()
  return convert_time("s")
end

M.conv_min = function()
  return convert_time("m")
end

M.conv_hour = function()
  return convert_time("h")
end

M.conv_day = function()
  return convert_time("d")
end

-- data units conversions
M.conv_bytes = function()
  return convert_data_units()
end
M.conv_kbytes = function()
  return convert_data_units("K")
end
M.conv_mbytes = function()
  return convert_data_units("M")
end
M.conv_gbytes = function()
  return convert_data_units("G")
end
M.conv_tbytes = function()
  return convert_data_units("T")
end

-- temperature conversions
M.conv_toggletemp = function()
  return toggle_temp()
end

M.run = function(command)
  local cmd = string.gsub(command.args, '^%s*(.-)%s*$', '%1')
  for _, v in pairs(vim.tbl_keys(require "nvim-superconv")) do
    print("input: '" .. cmd .. "'")
    print("table: '" .. v .. "'")
    if v == cmd then
      cmd = "M." .. cmd
      print(cmd)
      -- FIXME can't seem to run the command
      loadstring(cmd)()
      break
    end
  end
end

return M
