require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'

set :database,  adapter: 'sqlite3', database: 'blog.db'

class Post < ActiveRecord::Base
  validates :author, :title, :content, presence: true
  validates :author, length: { minimum: 2 }
  validates :title, length: { maximum: 200 }
end

class Comment < ActiveRecord::Base
  validates :content, presence: true, length: { in: 1..200 }
end

configure do
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
  @post = Post.find params[:id]
  erb :post_details
end

post '/post/:id' do
  comment = Comment.new post_id: params[:id], content: params[:content], datestamp: DateTime.current.to_date

  if comment.save
    redirect to('/post/' + params[:id])
  else
    @error = comment.errors.full_messages.first
    erb :post_details
  end
end
