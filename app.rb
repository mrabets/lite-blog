require 'rubygems'
require 'sinatra'
require "sqlite3"

configure do
  $db = SQLite3::Database.new 'base.db'
  $db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
    (
      "Id"	INTEGER,
      "Title"	TEXT,
      "Content"	TEXT,
      PRIMARY KEY("Id" AUTOINCREMENT)
    )'
end

get '/' do
  erb 'Hello Blog'
end

get '/add_post' do
  erb :add_post
end

post '/add_post' do
  @title = params[:title]
  @content = params[:content]

  # hh = { title: 'Write title name', content: 'Write content'}
  #
  # @error = hh.select { |key, _| params[key] == "" }.values.join(", ")
  #
  # if @error != ''
  #   return erb :add_post
  # end

  $db.execute 'INSERT INTO Posts(Title, Content) VALUES (?, ?)', [@title, @content]

  erb "Your title: #{@title}\ncontent: #{@content}"
end

get '/posts' do
  erb :posts
end
