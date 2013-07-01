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
    @message = "Login%20successful"
  else
    session[:admin] = :false
    @message = "Login%20unsuccessful"
  end
  if @params['post_id'] != nil
    redirect "/posts?message=#{@message}&post_id=#{@params['post_id']}"
  else
    redirect "/posts?message=#{@message}"
  end
end

post '/admin_logout' do
  session[:admin] = :false
  @message = "Goodbye."
  if @params['post_id'] != nil
    redirect "/posts?message=#{@message}&post_id=#{@params['post_id']}"
  else
    redirect "/posts?message=#{@message}"
  end
end


get '/posts' do
  # @author_id = params["author_id"]
  # @tag = params["tag"]
  @message = @params[:message]
  @post_id = @params[:post_id].to_i
  sql = "select * from posts"
  if @post_id > 0
      sql = sql + " where id = '#{@post_id}'"
  end
  sql = sql + " order by creation_date DESC;"

  @results = run_sql(sql)
  # binding.pry

  haml  :posts
end

get '/new_post' do

# Goto Form to add data

haml  :new_post
end



post '/create' do
  @title, @content, @tags = @params["title"], @params["content"], @params["tags"]
  add_new(@title, @content, @tags)
  redirect to ('/posts')
end

get '/edit' do
# Get details of post_id
  @post_id = params[:post_id].to_i
  sql = "select * from posts  where id = '#{@post_id}';"

  @results = run_sql(sql)

  haml :edit
end

post '/update' do
  @post_id, @title, @content, @tags = @params["post_id"], @params["title"], @params["content"], @params["tags"]
  update(@post_id, @title, @content, @tags)
  redirect to ("/posts?post_id=#{@params['post_id']}")
end


get '/delete' do
  if session[:admin] == :true
    @post_id = params["post_id"]
    sql = "delete from posts where id = #{@post_id}"
    run_sql(sql)
    @message = "Post%20deleted."
    redirect to ("/posts?message=#{@message}")
  else
    redirect to ("/posts?message=Please%20login%20to%20delete%20posts.")
  end
end


