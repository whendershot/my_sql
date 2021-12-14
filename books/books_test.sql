SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP DATABASE IF EXISTS `books_db`;

CREATE DATABASE `books_db`;
USE `books_db`;

CREATE TABLE `authors` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT (NOW()),
    `updated_at` TIMESTAMP DEFAULT (NOW()),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB ;

CREATE TABLE `books` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(45),
    `num_of_pages` INT,
    `created_at` TIMESTAMP DEFAULT (NOW()),
    `updated_at` TIMESTAMP DEFAULT (NOW()),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB ;

CREATE TABLE `favorites` (
    `author_id` INT UNSIGNED NOT NULL,
    `book_id` INT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT (NOW()),
    `updated_at` TIMESTAMP NOT NULL DEFAULT (NOW()),
    PRIMARY KEY (`author_id`, `book_id`),
    CONSTRAINT `fk_favorites_authors`
        FOREIGN KEY (`author_id`)
        REFERENCES `books_db`.`authors` (`id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_favorites_books`
        FOREIGN KEY (`book_id`)
        REFERENCES `books_db`.`books` (`id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
) ENGINE = InnoDB ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

LOCK TABLES `authors` WRITE, `books` WRITE;
INSERT INTO `authors` VALUES
    (1, 'Jane Austin', NOW(), NOW()),
    (2, 'Emily Dickenson', NOW(), NOW()),
    (3, 'Fyodor Dostoevsky', NOW(), NOW()),
    (4, 'William Shakespeare', NOW(), NOW()),
    (5, 'Lau Tzu', NOW(), NOW())
;
INSERT INTO `books` VALUES
    (1, 'C Sharp', 1, NOW(), NOW()),
    (2, 'Java', 1, NOW(), NOW()),
    (3, 'Python', 1, NOW(), NOW()),
    (4, 'PHP', 1, NOW(), NOW()),
    (5, 'Ruby', 1, NOW(), NOW())
;
UNLOCK TABLES;

SELECT * FROM books;

LOCK TABLES `books` WRITE, `authors` WRITE, `favorites` WRITE;
UPDATE `books` SET title = 'C#', updated_at = NOW() WHERE id = 1;
UPDATE `authors` SET name = 'Bill Shakespeare', updated_at = NOW() WHERE id = 4;
INSERT INTO `favorites` VALUES
    (1, 1, NOW(), NOW()),
    (1, 2, NOW(), NOW()),
    (2, 1, NOW(), NOW()),
    (2, 2, NOW(), NOW()),
    (2, 3, NOW(), NOW()),
    (3, 1, NOW(), NOW()),
    (3, 2, NOW(), NOW()),
    (3, 3, NOW(), NOW()),
    (3, 4, NOW(), NOW()),
    (4, 1, NOW(), NOW()),
    (4, 2, NOW(), NOW()),
    (4, 3, NOW(), NOW()),
    (4, 4, NOW(), NOW()),
    (4, 5, NOW(), NOW())
;
UNLOCK TABLES;

SELECT
    *
FROM
    `authors`
LEFT JOIN
    `favorites`
ON
    `authors`.`id` = `favorites`.`author_id`
WHERE
    `favorites`.`book_id` = 3
;

DELETE FROM `authors` WHERE `authors`.`id` =
(SELECT
    MIN(author_id)
FROM
    `favorites`
WHERE
    `book_id` = 3
);

INSERT INTO `authors` VALUES
    (6, 'Lau Tzu', NOW(), NOW())
;
    
INSERT INTO `favorites` VALUES
    (6, 2, NOW(), NOW())
;

SELECT 
    *
FROM
    books
WHERE
    id IN (
        SELECT
            book_id
        FROM
            favorites
        WHERE
            author_id = 3
        )
;

SELECT 
    *
FROM
    authors
WHERE
    id IN (
        SELECT
            author_id
        FROM
            favorites
        WHERE
            book_id = 5
        )
;
