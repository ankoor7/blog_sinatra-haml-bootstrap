CREATE TABLE posts (
    id        serial4 primary key,
    title         varchar(40) NOT NULL,
    content       text,
    creation_date   timestamp,
    tags    varchar(255)
);