require 'rubygems'
require 'sinatra'


get '/' do
  erb 'Hello Blog'
end

get '/add_post' do
  erb :add_post
end
