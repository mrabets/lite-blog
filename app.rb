require 'rubygems'
require 'sinatra'
require 'sqlite3'

configure do
  $db = SQLite3::Database.new 'base.db'
  $db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
    (
      "Id"	INTEGER,
      "Title"	TEXT,
      "Content"	TEXT,
      PRIMARY KEY("Id" AUTOINCREMENT)
    )'

  $db.execute 'CREATE TABLE IF NOT EXISTS "Comments"
    (
      "Id"	INTEGER,
      "DateTime"	DATE,
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
  @title = params[:title]
  @content = params[:content]

  $db.execute 'INSERT INTO Posts(Title, Content) VALUES (?, ?)', [@title, @content]

  erb "Your title: #{@title}\ncontent: #{@content}"
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
  @comment_row = results

  erb :post_details
end

post '/post/:post_id' do
  @post_id = params[:post_id]
  @comment = params[:comment]

  $db.execute 'INSERT INTO Comments(DateTime, Content, PostId) VALUES (datetime(), ?, ?)', [@comment, @post_id]

  erb "Your comment #{@comment}, post_id = #{@post_id}"
end
