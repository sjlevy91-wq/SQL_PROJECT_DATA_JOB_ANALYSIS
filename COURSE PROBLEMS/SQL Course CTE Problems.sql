-- CTE follow along
WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT (*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC

-- Practice problem
WITH remote_job_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE
    AND job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

-- CTE Problem 1
WITH job_titles AS (
    SELECT
        company_id,
        COUNT(DISTINCT job_title) AS job_count
    FROM job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name,
    job_titles.job_count
From job_titles
INNER JOIN
    company_dim ON job_titles.company_id = company_dim.company_id
ORDER BY
    job_count DESC
LIMIT 10;

-- CTE Problem 2
WITH country_avg_salary AS (
    SELECT  
        job_country,
        avg(salary_year_avg) AS avg_salary_country
    FROM job_postings_fact
    GROUP BY
        job_country
)

SELECT
    company_dim.name,
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    CASE
        WHEN job_postings_fact.salary_year_avg > country_avg_salary.avg_salary_country THEN 'Above Average'
        ELSE 'Below Average'
    END AS relative_avg,
    EXTRACT(MONTH from job_postings_fact.job_posted_date) AS month_of_posting,
    job_postings_fact.job_country
FROM job_postings_fact
INNER JOIN 
    country_avg_salary ON job_postings_fact.job_country = country_avg_salary.job_country
INNER JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
ORDER BY    
    month_of_posting DESC

/* CTE Problem 3
 This one was hard - gave up and had to get the solution
*/
WITH required_skills AS (
    SELECT
        companies.company_id,
        COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
    FROM
        company_dim AS companies
    LEFT JOIN
        job_postings_fact AS job_postings ON companies.company_id = job_postings.company_id
    LEFT JOIN 
       skills_job_dim AS skills_to_job ON job_postings.job_id = skills_to_job.job_id
    GROUP BY
        companies.company_id
),

max_salary AS (
    SELECT
        job_postings.company_id,
        MAX(job_postings.salary_year_avg) AS highest_average_salary
    FROM
        job_postings_fact AS job_postings
    WHERE
        job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
    GROUP BY
        job_postings.company_id
    ORDER BY highest_average_salary
)

SELECT
    companies.name,
    required_skills.unique_skills_required AS unique_skills_required,
    max_salary.highest_average_salary
FROM  
    company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY    highest_average_salary DESC;