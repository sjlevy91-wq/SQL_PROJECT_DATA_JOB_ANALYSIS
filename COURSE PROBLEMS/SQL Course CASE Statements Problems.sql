SELECT
   COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' Then 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM  job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;
-- CASE Statements Problem 1
SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High salary'
        WHEN salary_year_avg BETWEEN 60000 AND 99999 THEN 'Standard salary'
        WHEN salary_year_avg < 60000 THEN 'Low salary'
        ELSE 'Other'
    END AS salary_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

-- CASE Statements Problem 2
SELECT
    COUNT (DISTINCT company_id),
    CASE
        WHEN job_work_from_home = TRUE THEN 'WFH'
        ELSE 'Onsite'
    END AS WFH_policy
FROM job_postings_fact
GROUP BY
    job_work_from_home;
-- Problem 2 solution format
SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM job_postings_fact;

-- CASE Statements Problem 3
SELECT
    job_id,
    salary_year_avg,
    CASE 
        WHEN job_title ILIKE ('Senior') THEN 'Senior'
        WHEN job_title ILIKE ('Manager', 'Lead') THEN 'Lead/Manager'
        WHEN job_title ILIKE ('Junior', 'Entry') THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END  AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE THEN 'YES'
        ELSE 'NO'
    END AS remote_option
FROM job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id
-- Problem 3 corrections
SELECT
    job_id,
    salary_year_avg,
    CASE 
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_title ILIKE '%Manager%' OR job_title ILIKE '%Lead%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END  AS experience_level,
    CASE
        WHEN job_work_from_home THEN 'YES'
        ELSE 'NO'
    END AS remote_option
FROM job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id