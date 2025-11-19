# MockVim

MockVim is a lightweight Lua library designed to mock the Neovim `vim` global object for unit testing Lua scripts. It allows you to run Neovim plugin tests in a standalone Lua environment (like `busted`) without needing a running Neovim instance.

## Features

*   **Recursive Mocking**: Automatically creates mocks for any accessed field (e.g., `vim.api.nvim_buf_get_lines`, `vim.fn.glob`).
*   **Function Stubbing**: Configure return values for functions using a fluent API.
*   **Conditional Returns**: Return different values based on the arguments passed to the function.
*   **Call Verification (Spies)**: Verify if a function was called, how many times, and with what arguments.
*   **Variable Mocking**: Supports setting and getting mock variables (e.g., `vim.g`, `vim.o`, `vim.env`).

## Installation

### Using LuaRocks

```bash
luarocks install mockvim
```

### Manual

Copy the `lua/mockvim` directory into your project's `lua` folder or add it as a dependency in your test setup.

## Usage

### 1. Setup

In your test file (e.g., `spec/my_plugin_spec.lua`), require and setup `mockvim`. This will replace the global `vim` table with the mock object.

```lua
local mockvim = require("mockvim")

describe("My Plugin", function()
  before_each(function()
    mockvim.setup()
  end)

  it("should do something", function()
    -- Test code here
  end)
end)
```

### 2. Mocking Functions

You can define return values for any `vim` function. Since `mockvim` uses recursive mocking, you don't need to pre-define the function structure.

#### Simple Return Values

Use `:returns(...)` to set a default return value for a function.

```lua
-- Mock vim.api.nvim_get_current_buf to return 1
vim.api.nvim_get_current_buf:returns(1)

assert.are.equal(1, vim.api.nvim_get_current_buf())
```

#### Conditional Return Values

Use `:with(...):returns(...)` to return specific values when the function is called with specific arguments.

```lua
-- Mock vim.fn.fnamemodify
vim.fn.fnamemodify:with("test.lua", ":p"):returns("/abs/path/to/test.lua")
vim.fn.fnamemodify:with("other.lua", ":p"):returns("/abs/path/to/other.lua")

assert.are.equal("/abs/path/to/test.lua", vim.fn.fnamemodify("test.lua", ":p"))
```

### 3. Verifying Calls

You can verify if a function was called and with what arguments.

```lua
-- Call a function
vim.cmd("packadd packer.nvim")

-- Check if it was called
assert.is_true(vim.cmd:was_called())

-- Check call count
assert.is_true(vim.cmd:was_called_times(1))

-- Check arguments
assert.is_true(vim.cmd:was_called_with("packadd packer.nvim"))
```

### 4. Mocking Variables

You can simply assign values to `vim` variables like `vim.g`, `vim.o`, etc.

```lua
vim.g.my_plugin_enabled = 1
vim.o.background = "dark"

assert.are.equal(1, vim.g.my_plugin_enabled)
```

### 5. Clearing Mocks

If you are using a test runner like `busted`, `mockvim.setup()` in `before_each` creates a fresh mock environment for every test, so you don't usually need to manually clear mocks.

## API Reference

### `Stub` Object methods

Every function in the `vim` mock is a `Stub` object.

*   `stub:returns(...)`: Sets the default return values.
*   `stub:with(...):returns(...)`: Sets return values for specific arguments.
*   `stub:was_called()`: Returns `true` if the stub was called at least once.
*   `stub:was_called_times(n)`: Returns `true` if the stub was called exactly `n` times.
*   `stub:was_called_with(...)`: Returns `true` if the stub was called with the specified arguments at least once.
*   `stub:clear()`: Clears call history.

## License

MIT
