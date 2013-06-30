module Post
  attr_accessor     :id, :title,  :content,  :creation_date,  :tags

def run_sql(command)
  @db = PG.connect(dbname: "sinatra_blog")
  begin
    @db.exec(command)
  ensure
    @db.close
  end
end


def add_new(title, content, *tags)
  @title, @content = title, content
  @tags = []
  tags.each { |tag| @tags << tag }
  sql = "insert into posts (title, content, creation_date, tags) values ('#{@title}', '#{@content}', 'now', '#{@tags}');"
  run_sql(sql)
end

def delete(task_id)
  @task_id = task_id.to_s
      sql = "delete from posts where id = '#{@task_id}'"
  run_sql(sql)
end

def update(task_id,title, content, *tags)
  @task_id, @title, @content = task_id, title, content
  @tags = []
  tags.each { |tag| @tags << tag }
  sql = "update posts set  title = '#{@title}', content = '#{@content}', tags = '#{@tags}' where id='#{@task_id}';"
  run_sql(sql)
end

end