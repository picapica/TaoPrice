#!/usr/bin/env ruby -w
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require './common.rb'

require './app.rb'

map '/taoprice' do
  run AppController
end

map "/assets" do
  run Rack::Directory.new("./public")
end