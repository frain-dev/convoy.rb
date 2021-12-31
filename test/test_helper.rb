$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "convoy"

require "minitest/autorun"
require "webmock/minitest"

WebMock.disable_net_connect!

