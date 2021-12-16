-- 1. What query would you run to get the total revenue for March of 2012?
SELECT
    SUM(amount) AS total_revenue_pennies
FROM
    lead_gen_business.billing
WHERE
    charged_datetime BETWEEN '2012-03-01' AND '2012-03-31'
;

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
SELECT
    client_id,
    SUM(amount) AS total_revenu_pennies
FROM
    lead_gen_business.billing
WHERE   
    client_id = 2
;

-- 3. What query would you run to get all the sites that client with an id of 10 owns?
SELECT
    first_name,
    last_name,
    domain_name
FROM
(
    SELECT
        client_id,
        domain_name
    FROM
        lead_gen_business.sites
) AS sites

INNER JOIN
(
    SELECT
        client_id,
        first_name,
        last_name
    FROM
        clients
    WHERE
        client_id = 10
) AS clients
ON
    sites.client_id = clients.client_id
;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client with an id of 20?
SELECT
    client_id,
    YEAR(created_datetime) AS `year`,
    MONTH(created_datetime) AS `month`,
    COUNT(DISTINCT site_id) AS num_sites
FROM
    lead_gen_business.sites
WHERE
    client_id IN (1, 20)
GROUP BY
    `year`, `month`
;

-- 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
SELECT
    site_id,
    COUNT(DISTINCT leads_id) AS num_leads
FROM
    lead_gen_business.leads
WHERE
    registered_datetime BETWEEN '2011-01-01' AND '2011-02-15'
GROUP BY
    site_id
;

-- 6. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients between January 1, 2011 to December 31, 2011?
SELECT
    clients.client_id,
    clients.first_name,
    clients.last_name,
    SUM(leads.num_leads) AS num_leads
FROM
(
SELECT
    client_id,
    first_name,
    last_name
FROM
    clients
) AS clients

LEFT JOIN
(
    SELECT
        client_id,
        site_id
    FROM
        lead_gen_business.sites
) AS sites
ON
    clients.client_id = sites.client_id

LEFT JOIN
(
    SELECT
        site_id,
        COUNT(DISTINCT leads_id) AS num_leads
    FROM
        lead_gen_business.leads
    WHERE
        registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
    GROUP BY
        site_id
) AS leads
ON
    sites.site_id = leads.site_id
    
WHERE
    num_leads >= 0
GROUP BY
    clients.client_id
;

-- 7. What query would you run to get a list of client names and the total # of leads we've generated for each client each month between months 1 - 6 of Year 2011?
SELECT
    clients.client_id,
    clients.first_name,
    clients.last_name,
    leads.`month`,
    SUM(leads.num_leads) AS num_leads
FROM
(
    SELECT
        client_id,
        first_name,
        last_name
    FROM
        lead_gen_business.clients
) AS clients

LEFT JOIN
(
    SELECT
        client_id,
        site_id
    FROM
        lead_gen_business.sites
) AS sites
ON
    clients.client_id = sites.client_id

LEFT JOIN
(
    SELECT
        site_id,
        MONTH(registered_datetime) AS `month`,
        COUNT(DISTINCT leads_id) AS num_leads
    FROM
        lead_gen_business.leads
    WHERE
        MONTH(registered_datetime) BETWEEN 1 AND 6 AND
        YEAR(registered_datetime) = 2011
    GROUP BY
        site_id, `month`
) AS leads
ON
    sites.site_id = leads.site_id
    
WHERE
    num_leads >= 0
GROUP BY
    clients.client_id, leads.`month`
;

-- 8. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients' sites between January 1, 2011 to December 31, 2011? Order this query by client id.  Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
SELECT
    clients.client_id,
    clients.first_name,
    clients.last_name,
    leads.site_id,
    SUM(leads.num_leads) AS num_leads
FROM
(
SELECT
    client_id,
    first_name,
    last_name
FROM
    clients
) AS clients

LEFT JOIN
(
    SELECT
        client_id,
        site_id
    FROM
        lead_gen_business.sites
) AS sites
ON
    clients.client_id = sites.client_id

LEFT JOIN
(
    SELECT
        site_id,
        COUNT(DISTINCT leads_id) AS num_leads
    FROM
        lead_gen_business.leads
    WHERE
        registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
    GROUP BY
        site_id
) AS leads
ON
    sites.site_id = leads.site_id
    
WHERE
    num_leads >= 0
GROUP BY
    clients.client_id,
    leads.site_id
ORDER BY
    clients.client_id
;

-- 8b Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
SELECT
    clients.client_id,
    leads.site_id,
    clients.first_name,
    clients.last_name,    
    sites.domain_name,
    SUM(leads.num_leads) AS num_leads
FROM
(
SELECT
    client_id,
    first_name,
    last_name
FROM
    clients
) AS clients

LEFT JOIN
(
    SELECT
        client_id,
        site_id,
        domain_name
    FROM
        lead_gen_business.sites
) AS sites
ON
    clients.client_id = sites.client_id

LEFT JOIN
(
    SELECT
        site_id,
        COUNT(DISTINCT leads_id) AS num_leads
    FROM
        lead_gen_business.leads
    GROUP BY
        site_id
) AS leads
ON
    sites.site_id = leads.site_id
    
-- WHERE
   --  num_leads >= 0
GROUP BY
    clients.client_id,
    leads.site_id
;

-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.  First try this with integer month, second with month name.  A SELECT subquery will be needed for the second challenge.
SELECT
    client_revenues.client_id,
    client_revenues.`year`,
    client_revenues.`month`,
    client_revenues.month_name,
    client_revenues.revenue_pennies
FROM
(
    SELECT
        client_id,
        YEAR(charged_datetime) AS `year`,
        MONTH(charged_datetime) AS `month`,
        MONTHNAME(charged_datetime) AS `month_name`,
        SUM(amount) AS revenue_pennies
    FROM
        lead_gen_business.billing
    GROUP BY
        client_id,
        `year`,
        `month`
) AS client_revenues

ORDER BY
    client_revenues.client_id,
    client_revenues.`year`,
    client_revenues.`month`
;

-- 10. Write a single query that retrieves all the sites that each client owns. Group the results so that all of the sites for each client are displayed in a single field. It will become clearer when you add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
SELECT
    CONCAT(first_name, ' ',last_name) AS client_name,
    GROUP_CONCAT(domain_name SEPARATOR ' / ') AS sites
FROM
    lead_gen_business.clients
LEFT JOIN
    lead_gen_business.sites
USING (client_id)
GROUP BY
    client_name
;