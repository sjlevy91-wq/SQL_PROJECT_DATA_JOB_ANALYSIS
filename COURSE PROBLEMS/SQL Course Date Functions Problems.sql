-- Date Functions Problem 1
SELECT
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM   
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type;    
-- Problem 1 corrections
SELECT
    job_schedule_type,
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM   
    job_postings_fact
WHERE
    job_posted_date::date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type;    

-- Date Functions Problem 2
SELECT
    COUNT(job_id) AS number_of_jobs,
    EXTRACT (MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
     job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
GROUP BY
    MONTH
ORDER BY
    MONTH
-- Problem 2 corrections
SELECT
    EXTRACT (MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
     COUNT(*) AS postings_count
FROM
    job_postings_fact
GROUP BY
    MONTH
ORDER BY
    MONTH;

-- Date Functions Problem 3
SELECT
    COUNT(job_postings_fact.job_id) AS job_count,
    company_dim.name AS company_name,
    EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) AS posted_quarter
FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_health_insurance = TRUE
    AND job_postings_fact.posted_quarter = 2
GROUP BY
    company_dim.company_name
HAVING
    job_postings_fact.job_count >= 1
ORDER BY 
    job_postings_fact.job_count DESC
-- Problem 3 corrections
SELECT
    company_dim.name AS company_name,
    COUNT(job_postings_fact.job_id) AS job_postings_count
    
FROM job_postings_fact
    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
GROUP BY
    company_dim.name
HAVING
    COUNT(job_postings_fact.job_id) > 0
ORDER BY 
   job_postings_count DESC
