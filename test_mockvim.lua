package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"

local mockvim = require("mockvim")
-- local assert = require("assert") -- standard lua assert is global

-- Setup
mockvim.setup()

print("Testing vim object existence...")
assert(vim ~= nil, "vim should be defined")
assert(type(vim) == "table", "vim should be a table")

print("Testing recursive access...")
local get_lines = vim.api.nvim_buf_get_lines
assert(type(get_lines) == "table", "functions should be stubs (tables with call mt)")

print("Testing function call recording...")
vim.api.nvim_buf_get_lines(1, 0, -1, false)
assert(vim.api.nvim_buf_get_lines:was_called(), "should record call")
assert(vim.api.nvim_buf_get_lines:was_called_times(1), "should record 1 call")
assert(vim.api.nvim_buf_get_lines:was_called_with(1, 0, -1, false), "should match args")

print("Testing return values...")
vim.api.nvim_get_current_buf:returns(5)
local buf = vim.api.nvim_get_current_buf()
assert(buf == 5, "should return configured value")

print("Testing conditional return values...")
vim.fn.fnamemodify:with("foo", ":h").returns("bar")
vim.fn.fnamemodify:with("baz", ":h").returns("qux")

assert(vim.fn.fnamemodify("foo", ":h") == "bar", "should match first case")
assert(vim.fn.fnamemodify("baz", ":h") == "qux", "should match second case")
assert(vim.fn.fnamemodify("unknown", ":h") == nil, "should return nil for unknown")

print("Testing variable storage...")
vim.g.my_var = "hello"
assert(vim.g.my_var == "hello", "should store variables")

print("All tests passed!")
