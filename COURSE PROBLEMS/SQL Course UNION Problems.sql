-- UNION follow along
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

-- UNION practice problem
SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter_1_job_postings
WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC

-- UNION Problem 1
(
    SELECT 
        job_id,
        job_title,
        'With Salary Info' AS salary_info
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
UNION ALL
(
    SELECT
        job_id,
        job_title,
        'Without Salary Info' AS salary_info
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NULL
        OR salary_hour_avg IS NULL
)
ORDER BY  
    salary_info DESC,
    job_id;

-- UNION problem 2
SELECT
    quarter_1_job_postings.job_id,
    quarter_1_job_postings.job_title_short,
    quarter_1_job_postings.job_location,
    quarter_1_job_postings.job_via,
    skills_dim.skills,
    skills_dim.type
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter_1_job_postings
LEFT JOIN skills_job_dim ON quarter_1_job_postings.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    quarter_1_job_postings.salary_year_avg > 70000;

-- UNION problem 3
SELECT
    skills_dim.skills,
    COUNT(quarter_1_job_postings.job_id) AS number_of_jobs,
    EXTRACT(MONTH FROM quarter_1_job_postings.job_posted_date) AS month_job_posted,
    EXTRACT(YEAR FROM quarter_1_job_postings.job_posted_date) AS year_job_posted
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter_1_job_postings
INNER JOIN skills_job_dim ON quarter_1_job_postings.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills,
    month_job_posted,
    year_job_posted
ORDER BY
    number_of_jobs DESC;

-- Problem 3 solution
-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
    SELECT
        skills_dim.skills,  
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
        COUNT(combined_job_postings.job_id) AS postings_count 
    FROM
        combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
    GROUP BY
        skills_dim.skills, 
        year, 
        month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
    skills,  
    year,  
    month,  
    postings_count 
FROM
    monthly_skill_demand
ORDER BY
    skills, 
    year,
    month;  