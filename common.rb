#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('./lib', File.dirname(__FILE__))

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'rubygems'
require 'bundler'
Bundler.require

# === DataMapper Setup === #
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:taobao.sqlite')
DataMapper::Model.raise_on_save_failure = true
DataMapper::Property::String.length(255)
#DataMapper::Logger.new($stdout, :debug)

class Item
  include DataMapper::Resource

  property :id, Serial

  property :url, String

  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :price_records

end

class PriceRecord
  include DataMapper::Resource

  property :id, Serial

  property :url, String

  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :item
end

DataMapper.finalize
DataMapper.auto_upgrade!
# === end DataMapper === #