require 'rubygems'
require 'sinatra'


get '/' do
  erb 'Hello Blog'
end

get '/add_post' do
  erb :add_post
end

post '/add_post' do
  @title = params[:title]
  @content = params[:content]

  erb "Your title: #{@title}\ncontent: #{@content}"
end
