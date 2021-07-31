require 'rubygems'
require 'sinatra'
require 'sqlite3'

configure do
  $db = SQLite3::Database.new 'base.db'
  $db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
    (
      "Id" INTEGER,
      "Title" TEXT,
      "Content"	TEXT,
      "Author" TEXT,
      "DateTime" DATE,
      PRIMARY KEY("Id" AUTOINCREMENT)
    )'

  $db.execute 'CREATE TABLE IF NOT EXISTS "Comments"
    (
      "Id" INTEGER,
      "DateTime" DATE,
      "Content"	TEXT,
      "PostId" INTEGER,
      PRIMARY KEY("Id" AUTOINCREMENT)
    )'
end

helpers do
  require './my_methods'
end

get '/' do
  redirect to '/posts'
end

get '/add_post' do
  erb :add_post
end

post '/add_post' do
  @author = params[:author]
  @title = params[:title]
  @content = params[:content]

  $db.execute 'INSERT INTO Posts(Title, Content, Author, DateTime) VALUES (?, ?, ?, datetime())', [@title, @content, @author]

  erb "Your author:#{@author}\ntitle: #{@title}\ncontent: #{@content}"
end

get '/posts' do
  @result = $db.execute( "SELECT * FROM Posts" )
  erb :posts
end

get '/post/:post_id' do
  post_id = params[:post_id]

  results = $db.execute( "SELECT * FROM Posts WHERE Id = ?", [post_id] )
  @row = results[0]

  results = $db.execute( "SELECT * FROM Comments WHERE PostId = ?", [post_id] )
  @comments = results

  erb :post_details
end

post '/post/:post_id' do
  post_id = params[:post_id]
  comment = params[:comment]

  $db.execute 'INSERT INTO Comments(DateTime, Content, PostId) VALUES (datetime(), ?, ?)', [comment, post_id]

  # erb "Your comment #{@comment}, post_id = #{@post_id}"
  redirect to('/post/' + post_id)
end
