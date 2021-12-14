DROP DATABASE IF EXISTS `test_users`;

CREATE DATABASE `test_users`;
USE `test_users`;

CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(255),
    `last_name` VARCHAR(255),
    `email_address` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT (NOW()),
    `updated_at` TIMESTAMP DEFAULT (NOW()),
    PRIMARY KEY (`id`)
);

LOCK TABLES `users` WRITE;
INSERT INTO `users` VALUES
    (1, 'Brett', 'Michaels', 'a@a.com', NOW(), NOW()),
    (2, 'Alison', 'Michaels', 'B@B.com', NOW(), NOW()),
    (3, 'William', 'Hendershot', 'c@c.com', NOW(), NOW());
UNLOCK TABLES;
SELECT * FROM `users`;

SELECT * FROM `users` WHERE email_address = 'a@a.com';
SELECT * FROM `users` WHERE id = 3;

LOCK TABLES `users` WRITE;
UPDATE `users` SET last_name = 'Pancakes', updated_at = NOW() WHERE id = 3;
DELETE FROM `users` WHERE id = 2;
UNLOCK TABLES;

SELECT * FROM `users` ORDER BY first_name ASC;
SELECT * FROM `users` ORDER BY first_name DESC;
