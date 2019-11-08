local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local header_filter = require "kong.plugins.response-transformer.header_transformer"
local cjson = require "cjson"
local cjson_safe = require "cjson.safe"
local kong = kong

local TesterHandler = BasePlugin:extend()
local is_json_body = header_filter.is_json_body
local table_concat = table.concat
local ngx_log = ngx.log
local NGX_ALERT = ngx.ALERT

local plugin_name = "tester"

TesterHandler.VERSION = "0.0.1"
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
  ngx.header["response-token"] = "Hi! I am kong proxier."
  -- 当代码运行到body_filter_by_lua*时，HTTP报头（header）已经发送出去了。
  -- 如果在之前设置了跟响应体相关的报头，而又在body_filter_by_lua*中修改了响应体，会导致响应报头和实际响应的不一致。
  -- 举个简单的例子：假设上游的服务器返回了Content-Length报头，而body_filter_by_lua*又修改了响应体的实际大小。
  -- 客户端收到这个报头后，如果按其中的 Content-Length去处理，那他就掉坑里了。
  -- 由于Nginx的流式响应，发出去的报头就像泼出去的水，要想修改只能提前进行。
  ngx.header.content_length = nil

  -- Implement any custom logic here
end

function TesterHandler:body_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  -- 每个请求都有一个最后的子请求，这个请求中ngx.arg[1]为空字符串，而 ngx.arg[2]为true。
  -- 这是因为Nginx的upstream相关模块，以及OpenResty的content_by_lua，
  -- 会单独发送一个设置了last_buf的空 buffer，来表示流的结束。
  TesterHandler.super.body_filter(self)
  local chunk, eof = ngx.arg[1], ngx.arg[2]
  local ctx = ngx.ctx
  if ctx.buffer == nil then
    ctx.buffer = ""
  end

  local condition = chunk ~= nil and chunk ~= "" and not ngx.is_subrequest

  if condition then
    ctx.buffer = ctx.buffer .. chunk
    -- 将当前响应赋值为空（不会回传给client），以修改后的内容作为最终响应
    ngx.arg[1] = nil
  end
  if (eof) then
    local suffix = "\n-- From kong!"
    ngx_log(NGX_ALERT, ctx.buffer)
    local body = ctx.buffer .. suffix
    ngx.arg[1] = body
    ctx.buffer = nil
  end
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
