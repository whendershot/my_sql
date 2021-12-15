DROP DATABASE IF EXISTS `test_friendships`;

CREATE DATABASE `test_friendships`;
USE `test_friendships`;

CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(255),
    `last_name` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT (NOW()),
    `updated_at` TIMESTAMP DEFAULT (NOW()),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `friendships` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `friend_id` INT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP DEFAULT (NOW()),
    `updated_at` TIMESTAMP DEFAULT (NOW()),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_users`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`)
        ON DELETE CASCADE 
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_friends`
        FOREIGN KEY (`friend_id`)
        REFERENCES `users` (`id`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
) ENGINE = InnoDB;

LOCK TABLES `users` WRITE, `friendships` WRITE;
INSERT INTO `users` VALUES
    (1, 'Amy', 'Giver', NOW(), NOW()),
    (2, 'Big', 'Bird', NOW(), NOW()),
    (3, 'Eli', 'Byers', NOW(), NOW()),
    (4, 'Marky', 'Mark', NOW(), NOW()),
    (5, 'William', 'Hendershot', NOW(), NOW()),
    (6, 'Steven', 'Otten', NOW(), NOW())
;

INSERT INTO `friendships` VALUES
    (1, 1, 2, NOW(), NOW()),
    (2, 1, 4, NOW(), NOW()),
    (3, 1, 6, NOW(), NOW()),
    (4, 2, 1, NOW(), NOW()),
    (5, 2, 3, NOW(), NOW()),
    (6, 2, 5, NOW(), NOW()),
    (7, 3, 2, NOW(), NOW()),
    (8, 3, 5, NOW(), NOW()),
    (9, 4, 3, NOW(), NOW()),
    (10, 5, 1, NOW(), NOW()),
    (11, 5, 6, NOW(), NOW()),
    (12, 6, 2, NOW(), NOW()),
    (13, 6, 3, NOW(), NOW())
;
UNLOCK TABLES;

SELECT 
    u.first_name,
    u.last_name,
    f.first_name AS friend_first_name,
    f.last_name AS friend_last_name
FROM 
    `users` AS u
LEFT JOIN
    `friendships` j
ON
    u.id = j.user_id
LEFT JOIN
    `users` AS f
ON
    f.id = j.friend_id
;

SELECT
    *
FROM 
    users
WHERE
    users.id IN (
        SELECT user_id FROM friendships WHERE friend_id = 1
    )
;

SELECT
    COUNT(*) AS num_friendships
FROM
    friendships
;


WITH friend_counts AS (
SELECT
    user_id,
    COUNT(*) AS num_friends
FROM
    `friendships`
GROUP BY
    user_id        
)

SELECT
    *
FROM
    users
LEFT JOIN
    friend_counts
ON
    users.id = friend_counts.user_id
WHERE
    num_friends = (SELECT MAX(num_friends) FROM friend_counts)
;

SELECT
    *
FROM
    users
WHERE
    id IN
    (
        SELECT
            friend_id
        FROM
            friendships
        WHERE
            user_id = 3
    ) 
ORDER BY
      first_name ASC
    , last_name ASC
;
