/*
Question: What are the top paying data analyst jobs?
- Identify the top 10 highest paying Data Analyst roles that are available remotely.
- Focus on job postings with specified salaries (remove nulls).
- Why? highlight the top paying opportunities for Data Analysts, offering insights into employment optionas and location flexibility
*/
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS comapany_name,
    job_country
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE   
    job_title = 'Data Analyst' AND
    (job_country = 'United Kingdom' OR 
    job_work_from_home = TRUE) AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10