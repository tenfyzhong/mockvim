local Stub = require("mockvim.stub")

local M = {}

function M.setup()
  if _G.vim then
    -- Optional: warn or backup existing vim?
    -- For now, we assume we are in a test environment where we want to replace it.
  end

  _G.vim = Stub.new()

  -- Pre-define some common structures if needed,
  -- but the recursive Stub handles most things dynamically.

  return _G.vim
end

function M.mock()
  return Stub.new()
end

return M
