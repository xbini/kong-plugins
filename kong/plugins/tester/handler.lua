local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local kong = kong

local TesterHandler = BasePlugin:extend()

local plugin_name = 'tester'

TesterHandler.VERSION  = "0.0.1"
TesterHandler.PRIORITY = 10


-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instantiate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function TesterHandler:new()
  TesterHandler.super.new(self, plugin_name)
end

function TesterHandler:init_worker()
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.init_worker(self)

  -- Implement any custom logic here
end


function TesterHandler:preread(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.preread(self)

  -- Implement any custom logic here
end


function TesterHandler:certificate(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.certificate(self)

  -- Implement any custom logic here
end

function TesterHandler:rewrite(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.rewrite(self)

  -- Implement any custom logic here
end

function TesterHandler:access(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.access(self)
  -- ngx.log('---------tester config:'..config.tag)
  ngx.req.set_header("request-token", "嗨！兄弟，我们好久不见，你在哪里？")
 
  -- Implement any custom logic here
end

function TesterHandler:header_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.header_filter(self)
  -- for k,v in pairs(responses) do
  --   ngx.header[k] = v
  -- end
  ngx.header["response-token"] = "嗨！朋友，如果真的是你，请打招呼。"
 
  -- Implement any custom logic here
end

function TesterHandler:body_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.body_filter(self)

  -- Implement any custom logic here
end

function TesterHandler:log(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  TesterHandler.super.log(self)

  -- Implement any custom logic here
end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return TesterHandler
