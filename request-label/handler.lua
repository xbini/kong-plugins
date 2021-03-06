local BasePlugin = require "kong.plugins.base_plugin"

local RequestLabelHandler = BasePlugin:extend()

local plugin_name = "request-label"

RequestLabelHandler.VERSION = "1.0.0-0"
RequestLabelHandler.PRIORITY = 10

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instantiate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function RequestLabelHandler:new()
  RequestLabelHandler.super.new(self, plugin_name)
end

function RequestLabelHandler:init_worker()
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.init_worker(self)

  -- Implement any custom logic here
end

function RequestLabelHandler:preread(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.preread(self)

  -- Implement any custom logic here
end

function RequestLabelHandler:certificate(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.certificate(self)

  -- Implement any custom logic here
end

function RequestLabelHandler:rewrite(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.rewrite(self)

  -- Implement any custom logic here
end

function RequestLabelHandler:access(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.access(self)
  ngx.req.set_header("request-label-go", "Hi!")

  -- Implement any custom logic here
end

function RequestLabelHandler:header_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.header_filter(self)
  local ip = ngx.var.remote_addr
  ngx.header["request-label-come"] = "Hi! I am kong proxier."
  -- 当代码运行到body_filter_by_lua*时，HTTP报头（header）已经发送出去了。
  -- 如果在之前设置了跟响应体相关的报头，而又在body_filter_by_lua*中修改了响应体，会导致响应报头和实际响应的不一致。
  -- 举个简单的例子：假设上游的服务器返回了Content-Length报头，而body_filter_by_lua*又修改了响应体的实际大小。
  -- 客户端收到这个报头后，如果按其中的 Content-Length去处理，那他就掉坑里了。
  -- 由于Nginx的流式响应，发出去的报头就像泼出去的水，要想修改只能提前进行。
  ngx.header.content_length = nil

  -- Implement any custom logic here
end

function exec_body(...)
  -- 每个请求都有一个最后的子请求，这个请求中ngx.arg[1]为空字符串，而 ngx.arg[2]为true。
  -- 这是因为Nginx的upstream相关模块，以及OpenResty的content_by_lua，
  -- 会单独发送一个设置了last_buf的空 buffer，来表示流的结束。
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
    local body = ctx.buffer .. suffix
    ngx.arg[1] = body
    ctx.buffer = nil
  end
end

function RequestLabelHandler:body_filter(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.body_filter(self)
  -- exec_body()
  -- Implement any custom logic here
end

function RequestLabelHandler:log(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  RequestLabelHandler.super.log(self)

  -- Implement any custom logic here
end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return RequestLabelHandler
