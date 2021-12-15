-- 1. What query would you run to get all the countries that speak Slovene? Your query should return the name of the country, language and language percentage. Your query should arrange the result by language percentage in descending order. (1)
SELECT
    b.Name,
    a.Language,
    a.Percentage
FROM
(
SELECT
    CountryCode,
    Language,
    Percentage
FROM
    world.countrylanguage
WHERE
    Language = 'Slovene'
) AS a
LEFT JOIN
(
    SELECT
        Name,
        Code
    FROM
        world.country
) AS b
ON
    a.CountryCode = b.Code
ORDER BY
    a.Percentage DESC
;

-- 2. What query would you run to display the total number of cities for each country? Your query should return the name of the country and the total number of cities. Your query should arrange the result by the number of cities in descending order. (3)
SELECT
    b.Name,
    a.num_cities
FROM
(
SELECT
    CountryCode,
    COUNT(*) AS num_cities
FROM 
    City
GROUP BY
    CountryCode
) AS a
LEFT JOIN
(
    SELECT
        Name,
        Code
    FROM
        country
) AS b
ON
    a.CountryCode = b.Code
ORDER BY
    a.num_cities DESC
;

-- 3. What query would you run to get all the cities in Mexico with a population of greater than 500,000? Your query should arrange the result by population in descending order. (1)
SELECT 
    *
FROM
    city
WHERE
    Population > 500000 AND
    CountryCode = 'MEX'
ORDER BY
    Population DESC
;

-- 4. What query would you run to get all languages in each country with a percentage greater than 89%? Your query should arrange the result by percentage in descending order. (1)
SELECT
    *
FROM
    countrylanguage
WHERE
    Percentage > 89.0
ORDER BY
    Percentage DESC
;

-- 5. What query would you run to get all the countries with Surface Area below 501 and Population greater than 100,000? (2)
SELECT
    *
FROM
    country
WHERE
    SurfaceArea < 501.0 AND
    Population > 100000
;

-- 6. What query would you run to get countries with only Constitutional Monarchy with a capital greater than 200 and a life expectancy greater than 75 years? (1)
SELECT 
    *
FROM
    country
WHERE
    GovernmentForm = 'Constitutional Monarchy' AND
    Capital > 200 AND
    LifeExpectancy > 75.0
;

-- 7. What query would you run to get all the cities of Argentina inside the Buenos Aires district and have the population greater than 500, 000? The query should return the Country Name, City Name, District and Population. (2)
SELECT
    countries.Name AS 'Country Name',
    cities.Name AS 'City Name',
    cities.District,
    cities.Population
FROM
(
SELECT
    Code,
    Name
FROM
    countries
WHERE
    Name = 'Argentina'
) AS countries
LEFT JOIN
(
SELECT
    CountryCode,
    Name,
    District,
    Population
FROM
    city
WHERE
    District = 'Buenos Aires'
) AS cities
ON
    countries.Code = cities.CountryCode
;

-- 8. What query would you run to summarize the number of countries in each region? The query should display the name of the region and the number of countries. Also, the query should arrange the result by the number of countries in descending order. (2)
SELECT
    Region,
    COUNT(*) AS num_countries
FROM
    country
GROUP BY
    Region
ORDER BY
    num_countries DESC
;