local Stub = {}
Stub.__index = Stub
local unpack = table.unpack or unpack

function Stub.new()
  local self = setmetatable({}, Stub)
  self.calls = {}
  self.return_values = {}
  self.default_return = nil
  self.children = {}
  return self
end

function Stub:__index(key)
  if Stub[key] then return Stub[key] end

  if not self.children[key] then
    self.children[key] = Stub.new()
  end
  return self.children[key]
end

function Stub:__call(...)
  local args = {...}
  table.insert(self.calls, args)

  -- Check for specific argument matches
  for _, config in ipairs(self.return_values) do
    if self:_args_match(config.args, args) then
      return unpack(config.returns)
    end
  end

  if self.default_return then
    return unpack(self.default_return)
  end
end

function Stub:returns(...)
  self.default_return = {...}
  return self
end

function Stub:with(...)
  local args = {...}
  local config = { args = args, returns = {} }
  table.insert(self.return_values, config)

  local context = {}
  function context.returns(...)
    config.returns = {...}
    return self
  end
  return context
end

function Stub:_args_match(expected, actual)
  if #expected ~= #actual then return false end
  for i, v in ipairs(expected) do
    if v ~= actual[i] then return false end
  end
  return true
end

-- Verification methods
function Stub:was_called()
  return #self.calls > 0
end

function Stub:was_called_times(n)
  return #self.calls == n
end

function Stub:was_called_with(...)
  local expected = {...}
  for _, call in ipairs(self.calls) do
    if self:_args_match(expected, call) then
      return true
    end
  end
  return false
end

-- Helper to clear history
function Stub:clear()
  self.calls = {}
end

return Stub
