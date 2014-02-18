#!/usr/bin/env ruby
# encoding: utf-8

class AppController < Sinatra::Base
  enable :sessions

  configure {
    set :server, :puma
  }

  get '/' do
    @total_items_count = Item.count
    @per_page    = (params[:per_page] || 50).to_i
    @total_pages_count = (@total_items_count - 1) / @per_page + 1

    page = (params[:page] || 1).to_i
    @page = @total_pages_count > 0 ? (page - 1) % @total_pages_count + 1 : 1
    start = (@page - 1) * @per_page

    items = Item.all(:order => [:id.desc, :created_at.desc])
    @items = items[start, @per_page]

    haml :item_list
  end

  post '/item/create' do
    p params[:url].length
    @item = Item.first_or_create(:url => params[:url])

    redirect "/#item_#{@item.id}"
  end
end