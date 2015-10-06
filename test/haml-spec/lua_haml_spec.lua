local dir       = require 'pl.dir'
local haml      = require 'haml'
local json      = require 'json'
local path      = require 'pl.path'
local telescope = require 'telescope'
local assert    = assert
local describe  = telescope.describe
local getinfo   = debug.getinfo
local it        = telescope.it
local open      = io.open
local pairs     = pairs

module('hamlspec')

local function get_tests(filename)
  local me = path.abspath(getinfo(1).source:match("@(.*)$"))
  return path.join(path.dirname(me), filename)
end

local json_file = get_tests("tests.json")
local file      = assert(open(json_file))
local input     = file:read '*a'
file:close()

local contexts = json.decode(input)

describe("LuaHaml", function()
   for context, expectations in pairs(contexts) do
     describe("When handling " .. context, function()
      for name, exp in pairs(expectations) do
        it(("should correctly render %s"):format(name), function()
          local engine = haml.new(exp.config)
          assert_equal(engine:render(exp.haml, exp.locals), exp.html)
        end)
      end
     end)
   end
end)