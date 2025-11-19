package = "mockvim"
version = "0.1.0-1"
source = {
   url = "git+https://github.com/tenfyzhong/mockvim.git",
   tag = "v0.1.0"
}
description = {
   summary = "A Lua library to mock the Neovim vim global object.",
   detailed = [[
      MockVim allows you to run Neovim plugin tests in a standalone Lua environment
      by mocking the global `vim` object, including recursive functions,
      stubs, and call verification.
   ]],
   homepage = "https://github.com/tenfyzhong/mockvim",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["mockvim"] = "lua/mockvim/init.lua",
      ["mockvim.stub"] = "lua/mockvim/stub.lua"
   }
}
