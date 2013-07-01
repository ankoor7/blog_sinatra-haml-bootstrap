CREATE TABLE posts (
    id        serial4 primary key,
    title         varchar(40) NOT NULL,
    content       text,
    creation_date   timestamp,
    tags    varchar(255)
);

CREATE TABLE tags (
  id      serial4 primary key,
  tag    varchar(40)   NOT NULL,
  post_id     varchar(4)  NOT NULL
);

CREATE TABLE tag_count (
  id      serial4 primary key,
  tag    varchar(40)   NOT NULL,
  count     varchar(4)
);