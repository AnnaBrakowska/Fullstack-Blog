require 'sinatra'
# require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models/tag.rb'
require './models/user.rb'
require './models/post.rb'
require './models/post_tag.rb'


enable :sessions




get '/' do
    if session[:user_id]
        @posts = Post.all
        redirect '/posts'
    else
        erb :signin
    end
end


get '/signin' do
    erb :signin, :layout => :signinlayout
end


post '/signin' do
    @user = User.find_by(user_name: params[:user_name])
    puts "HELLO"
    puts @user
    puts "HELLO"
    if @user && @user.password == params[:password]
        session[:user_id] = @user.id
        p ' you passed thru login'
        redirect '/'
    else
        p ' authentication failed'
    redirect '/signup'
    end
end

get '/signup' do
    erb :signup
end

post '/signup' do
   @user= User.create(user_name: params[:user_name], first_name: params[:first_name], last_name: params[:last_name], email: params[:email], birthday: params[:birthday], image_url: params[:image_url], password: params[:password])
   session[:user_id] = @user.id
   redirect '/users'
end

get "/signout" do

    session[:user_id] = nil
    redirect "/signin"
  end


get '/users' do
    @users = User.all
    erb :users
end


get '/posts' do
    @posts = Post.all
    erb :posts
end


get '/createpost' do 
    erb :createpost
end

post '/createpost' do
    @tag = params[:check]

    @post = Post.create(user_id: session[:user_id], title: params[:title], text: params[:text], image: params[:image])
    @tagged_post = PostTag.create(post_id: @post.id, tag_id: @tag.to_i)

    redirect "/posts"
end



get '/users_posts/:user_name' do
    @user_name = params[:user_name]
    @userinfo = User.find_by user_name: @user_name
    @userinfo_posts = Post.where(user_id: @userinfo.id)
    erb :users_posts
end





get '/specific_post/:post' do
    @specific_post = Post.find(params[:post])
    p @specific_post.title
    erb :specific_post
end



get '/myposts' do
    @my_posts = Post.where(user_id: session[:user_id])
    p session[:user_id]
    erb :my_posts
end


get '/delete/:post_id' do

    @post_id = params[:post_id]
    @posttagtodelete = PostTag.where(post_id: params[:post_id])
    Post.delete(@post_id)
    PostTag.delete(@posttagtodelete)

    redirect "/myposts"

end



get '/myposts/:post_id/edit' do
    @post_id = params[:post_id]
    @current_post = Post.find(@post_id)

    if session[:user_id]==@current_post.user_id
    erb :editpost
    else
        redirect '/posts'
    end
end

put '/myposts/:post_id' do 
    @post_id = params[:post_id]
    @current_post = Post.find(@post_id)
    @current_post.update(user_id: session[:user_id], title: params[:title], text: params[:text], image: params[:image])
    redirect '/specific_post/'+@post_id
end


get '/myprofile' do
    @current = User.find(session[:user_id])
    erb :myprofile
end



put '/myprofile' do
    @current = User.find(session[:user_id])
    @current.update(user_name: params[:user_name], first_name: params[:first_name], last_name: params[:last_name], email: params[:email], birthday: params[:birthday], image_url: params[:image], password: params[:password])
    redirect '/myprofile'
end





get '/myprofile/delete' do
    User.delete(session[:user_id])
    redirect '/signout'
end