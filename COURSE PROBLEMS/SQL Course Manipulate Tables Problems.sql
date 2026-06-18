-- Manipulate Tables Problem 1
CREATE TABLE data_science_jobs (
    job_id INT PRIMARY KEY,
    job_title VARCHAR (255),
    company_name VARCHAR (255),
    post_date DATE
);
-- Problem 1 Corrections
ALTER TABLE data_science_jobs
ALTER COLUMN job_title TYPE TEXT,
ALTER COLUMN company_name TYPE TEXT;

-- Manipulate Tables Problem 2
INSERT INTO data_science_jobs
    (job_id,
    job_title,
    company_name,
    post_date)
Values (1,
        'Data Scientist',
        'Tech Innovations',
        '2023-01-01'),
        (2,
         'Machine Learning Engineer',
         'Data Driven Co',
         '2023-01-15'),
         (3,
          'AI Specialist',
          'Future Tech',
          '2023-02-01');

SELECT *
FROM data_science_jobs

-- Manipulate Tables Problem 3
ALTER TABLE data_science_jobs
ADD COLUMN remote BOOLEAN;

-- Manipulate Tables Problem 4
ALTER TABLE data_science_jobs
RENAME COLUMN post_date to posted_on;

-- Manipulate Tables Problem 5
ALTER TABLE data_science_jobs  
ALTER COLUMN remote
SET DEFAULT false

INSERT INTO data_science_jobs
            (job_id,
            job_title,
            company_name,
            posted_on)
Values (4,
        'Data Scientist',
        'Google',
        '2023-02-05');

-- Manipulate Tables Problem 6
ALTER TABLE data_science_jobs
DROP COLUMN company_name

-- Manipulate Tables Problem 7
UPDATE data_science_jobs
SET remote = TRUE
WHERE job_id = 2

-- Manipulate Tables Problem 8
DROP TABLE data_science_jobs