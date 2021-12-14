USE sakila;

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `created_at` TIMESTAMP DEFAULT NOW() NOT NULL,
    `updated_at` TIMESTAMP DEFAULT NOW() NOT NULL,
    `note` TEXT NULL,
    PRIMARY KEY (`id`)
);

LOCK TABLES `items` WRITE;
INSERT INTO `items` VALUES 
(1, NOW(), NOW(), NULL),
(2, NOW(), NOW(), NULL),
(3, NOW(), NOW(), NULL),
(4, NOW(), NOW(), NULL)
;
UNLOCK TABLES;
SELECT * FROM items;

LOCK TABLES `items` WRITE;
UPDATE `items` SET `note` = 'I am an updated note!!', `updated_at` = NOW() WHERE id = 2;
UNLOCK TABLES;
SELECT * FROM `items`;

LOCK TABLES `items` WRITE;
DELETE FROM `items` WHERE id = 3;
UNLOCK TABLES;
SELECT * FROM `items`;