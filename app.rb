require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'

set :database, { adapter: 'sqlite3', database: 'blog.db' }

class Post < ActiveRecord::Base
end

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
  @post = Post.new
  erb :add_post
end

post '/add_post' do
  @post = Post.new params[:post]
  @post.datestamp = DateTime.current.to_date

  if @post.save
    erb "Your author:#{@post.author}\ntitle: #{@post.title}\ncontent: #{@post.content}"
  else
    @error = @post.errors.full_messages.first
    erb :add_post
  end

end

get '/posts' do
  erb :posts
end

get '/post/:id' do
  post_id = params[:id]

  @post = Post.find post_id

  erb :post_details
end

post '/post/:id' do
  post_id = params[:post_id]
  comment = params[:comment]

  $db.execute 'INSERT INTO Comments(DateTime, Content, PostId) VALUES (datetime(), ?, ?)', [comment, post_id]

  # erb "Your comment #{@comment}, post_id = #{@post_id}"
  redirect to('/post/' + post_id)
end
