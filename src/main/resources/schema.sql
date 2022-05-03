DROP DATABASE IF EXISTS fortifymule;
CREATE DATABASE fortifymule;
DROP USER IF EXISTS fortifymule;
CREATE USER 'fortifymule'@'%' IDENTIFIED BY 'fortifymule';
GRANT ALL PRIVILEGES ON fortifymule.* TO 'fortifymule'@'%';

USE fortifymule;

CREATE TABLE products
(
    `id`            binary(16)      not null,
    `code`          varchar(255)    not null,
    `name`          varchar(255)    not null,
    `summary`       text            not null,
    `description`   text            not null,
    `image`         varchar(255),
    `price`         float           not null,
    `on_sale`       bit(1)          default 0 not null,
    `sale_price`    float           default 0.0 not null,
    `in_stock`      bit(1)          default 1 not null,
    `time_to_stock` integer         default 0 not null,
    `rating`        integer         default 1 not null,
    `available`     bit(1)          default 1 not null,
    primary key (`id`)
);