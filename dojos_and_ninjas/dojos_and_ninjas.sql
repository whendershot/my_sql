USE `dojos_and_ninjas`;

LOCK TABLES `dojos` WRITE;
INSERT INTO `dojos` VALUES 
    (1, 'Seattle DOJO', NOW(), NOW()),
    (2, 'Osaka DOJO', NOW(), NOW()),
    (3, 'Redmond', NOW(), NOW())
;
UNLOCK TABLES;

SELECT * FROM `dojos`;

LOCK TABLES `dojos` WRITE;
DELETE FROM `dojos` WHERE id > 0;
UNLOCK TABLES;

SELECT * FROM `dojos`;

LOCK TABLES `dojos` WRITE, `ninjas` WRITE;
INSERT INTO `dojos` VALUES
    (4, 'New York DOJO', NOW(), NOW()),
    (5, 'London DOJO', NOW(), NOW()),
    (6, 'Hong Kong', NOW(), NOW())
;
INSERT INTO `ninjas` VALUES
    (1, 'Albert', 'A', 20, NOW(), NOW(), 4),
    (2, 'Beth', 'B', 30, NOW(), NOW(), 4),
    (3, 'Charles', 'C', 40, NOW(), NOW(), 4),
    
    (4, 'Don', 'D', 21, NOW(), NOW(), 5),
    (5, 'Eliza', 'E', 31, NOW(), NOW(), 5),
    (6, 'Frank', 'F', 41, NOW(), NOW(), 5),
    
    (7, 'Glenn', 'G', 22, NOW(), NOW(), 6),
    (8, 'Hannah', 'H', 32, NOW(), NOW(), 6),
    (9, 'Ingrid', 'I', 42, NOW(), NOW(), 6)
;
UNLOCK TABLES;

SELECT * FROM `ninjas` WHERE dojo_id = 3;
SELECT * FROM `ninjas` WHERE dojo_id = 6;

SELECT 
    dojos.name 
FROM
    ninjas
LEFT JOIN
    dojos
ON
    ninjas.dojo_id = dojos.id
WHERE
    ninjas.id = 9
;