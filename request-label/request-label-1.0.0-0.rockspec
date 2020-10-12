package = "request-label"  -- TODO: rename, must match the info in the filename of this rockspec!
                                  -- as a convention; stick to the prefix: `kong-plugin-`
version = "1.0.0-0"               -- TODO: renumber, must match the info in the filename of this rockspec!
-- The version '1.0.0-0' is the source code version, the trailing '1' is the version of this rockspec.
-- whenever the source version changes, the rockspec should be reset to 1. The rockspec version is only
-- updated (incremented) when this file changes, but the source remains the same.

-- TODO: This is the name to set in the Kong configuration `plugins` setting.
-- Here we extract it from the package name.

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/xbini/kong-plugins.git",
  tag = "1.0.0-0"
}

description = {
  summary = "A test plugin",
  homepage = "",
  license = "MIT"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    -- TODO: add any additional files that the plugin consists of
    ["kong.plugins.request-label.handler"] = "./handler.lua",
    ["kong.plugins.request-label.schema"] = "./schema.lua"
  }
}
