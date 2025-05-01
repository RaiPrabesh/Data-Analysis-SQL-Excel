--1 Frequency trends by year, country, and attack type
SELECT 
    year, country, attack_type,
    COUNT(*) AS "Incident Frequency"
FROM 
    countrylist
WHERE 
    country IN ('India', 'China', 'USA')
    AND year BETWEEN 2015 AND 2024
GROUP BY
    year, country, attack_type
ORDER BY
    year, country, attack_type;
    
--1 Financial impact trends by year, country, and attack type
SELECT 
    year, country, attack_type,
    SUM(financial_loss_million) AS "Total Financial Impact"
FROM 
    countrylist 
WHERE 
    country IN ('India', 'China', 'USA') 
    AND YEAR BETWEEN 2015 AND 2024
GROUP BY
    year, country, attack_type
ORDER BY
    year, country, attack_type;
    
--1 Hypothesis : Overall financial impact by country
SELECT 
    country,
    SUM(financial_loss_million) AS "Total Financial Impact"
FROM 
    countrylist
WHERE
    year BETWEEN 2015 AND 2024
GROUP BY
    country
ORDER BY
    "Total Financial Impact" DESC;
    
--2 Relstionship between vulnerability, defense, and resolution time
SELECT 
    cl.country,
    dl.security_vulnerability_type,
    dl.defense_mechanism_used,
    ROUND(AVG(cl.incident_resolution_hours), 2) AS "AVG resolution time"
FROM
    countrylist cl
JOIN
    defenselog dl ON cl.incident_key = dl.incident_key
WHERE
    cl.country in ('India', 'China', 'USA')
GROUP BY
    cl.country, dl.security_vulnerability_type, dl.defense_mechanism_used
ORDER BY
    cl.country, dl.security_vulnerability_type, dl.defense_mechanism_used;
    
--2 Hypothesis: Comparing resolution times for "social engineering" vs
-- "Unpatched software"
SELECT 
    cl.country,
    ROUND(
    AVG(CASE WHEN dl.security_vulnerability_type = 'Social Engineering'
        THEN cl.incident_resolution_hours END), 2)
        AS "AVG RT Social Engineering",
    ROUND(
    AVG(CASE WHEN dl.security_vulnerability_type = 'Unpatched Software'
        THEN cl.incident_resolution_hours END), 2)
        AS "AVG RT Unpatched Software"
FROM 
    countrylist cl
JOIN 
    defenselog dl 
    ON cl.incident_key = dl.incident_key
WHERE
    cl.country IN('India', 'China', 'USA')
GROUP BY
    cl.country
ORDER BY
    cl.country;
    
--3 Most frequently targeted industires by country
SELECT 
    cl.country, il.target_industry,
    COUNT(*) AS "Incident Frequency",
    ROUND(SUM(cl.financial_loss_million), 2) AS "Total Financial Loss"
FROM
    countrylist cl
JOIN
    industrylist il ON cl.incident_key = il.incident_key
WHERE
    cl.country IN ('India', 'China', 'USA')
GROUP BY
    cl.country, il.target_industry
ORDER BY
    cl.country, "Total Financial Loss" DESC;
    
--3 Highest financial losses by industry by country
SELECT
    cl.country, il.target_industry,
    ROUND(SUM(cl.financial_loss_million), 2) AS "Total Financial Loss"
FROM
    countrylist cl
JOIN
    industrylist il ON cl.incident_key = il.incident_key
WHERE
    cl.country IN ('India', 'China', 'USA')
GROUP BY
    cl.country, il.target_industry
ORDER BY
    cl.country, "Total Financial Loss" DESC;
    
--3 Hypothesis: If Retail is in the top 3 most frequently targeted industry
-- Lets do this in Excel

--4 Correlation between Financial imapct and affected users by country
SELECT
    country,
    ROUND(CORR(financial_loss_million, number_of_affected_users), 3)
    AS "Correlation_coefficient"
FROM
    countrylist
WHERE
    country IN ('India', 'China', 'USA')
GROUP BY
    country;

--4 The Actual data
SELECT
    country, financial_loss_million AS "Loss In Million",
    number_of_affected_users As "Affected User Count"
FROM
    countrylist
WHERE
    country IN ('India', 'China', 'USA')
ORDER BY
    country, "Loss In Million" DESC;
    
    
    