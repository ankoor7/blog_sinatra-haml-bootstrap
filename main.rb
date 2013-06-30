require 'pry'
require 'sinatra'
require 'sinatra/contrib/all'
require 'pg'
require 'haml'

configure do
  enable :sessions
end


# Database accessor
def run_sql(command)
  @db = PG.connect(dbname: "sinatra_blog")
  begin
    @db.exec(command)
  ensure
    @db.close
  end
end

# Commands to edit the database
def add_new(title, content, *tags)
  @title, @content = title, content
  @tags = tags.join(', ')
  sql = "insert into posts (title, content, creation_date, tags) values ('#{@title}', '#{@content}', now(), '#{@tags}');"
  run_sql(sql)
end

def delete(task_id)
  @task_id = task_id.to_s
      sql = "delete from posts where id = '#{@task_id}'"
  run_sql(sql)
end

def update(task_id,title, content, *tags)
  @task_id, @title, @content = task_id, title, content
  @tags = tags.join(', ')
  sql = "update posts set  title = '#{@title}', content = '#{@content}', tags = '#{@tags}' where id='#{@task_id}';"
  run_sql(sql)
end

post '/admin_connect' do
  if @params['username'] == 'admin' and @params['password'] == 'password'
    session[:admin] = :true
    @message = "Hello #{@params['username']}."
    redirect "/posts"
  else
    @message = "We could not verify your login details. Please try again."
    redirect "/admin_connect"
  end
end


# get'/admin' do
#   unless session[:admin] == true

# end



get '/posts' do
  # @author_id = params["author_id"]
  # @tag = params["tag"]
  @message = params[:message]
  @post_id = params[:post_id].to_i
  sql = "select * from posts"
  if @post_id > 0
      sql = sql + " where id = '#{@post_id}'"
  end
  sql = sql + " order by creation_date DESC;"

  @results = run_sql(sql)
  # binding.pry

  haml  :posts
end

get '/add_new' do

# Goto Form to add data

haml  :add_new
end



# post '/add_new' do
#   @title = params[:title]
#   @content = params[:content]

#   # insert sql database - post details

#   redirect to ('/')
# end

get '/edit' do
# Get details of post_id
  @post_id = params[:post_id].to_i
  sql = "select * from posts  where id = '#{@post_id}';"

  @results = run_sql(sql)

  haml :edit
end

post '/edit' do
@post_id = params["post_id"]

  redirect to ('/')
end


# post '/delete' do
#   @post_id = params["post_id"]
#   sql = "select title from posts where id = #{@post_id}"
#   @deleted_post_title = run_sql('sql').first['title']

#   sql = "delete from posts where id = #{@post_id}"
#   run_sql('sql').first['title']

#   @deleted_post_title
#   redirect to ('/') :locals => {:message => @deleted_post_title}
# end



#########################
# post "/posts" do
# end


# get "/post/:id" do
# end


# get "post/:id/edit" do
# end



# before do
#   if environment == production
#     @db = PG.connect(dbname: "sinatra_blog_production")
#   else
#     @db = PG.connect(dbname: "sinatra_blog")
# end

# after do
#   @db.close
# end
