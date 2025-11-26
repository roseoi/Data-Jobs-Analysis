-- =============================
-- CREATE TABLES AND IMPORT DATA
-- =============================

-- Jobs table
CREATE TABLE jobs (
    job_id BIGINT NOT NULL PRIMARY KEY,
    company_id BIGINT NOT NULL,
    job_title_short TEXT NOT NULL,
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home BOOLEAN NOT NULL,
    search_location TEXT NOT NULL,
    job_posted_date TEXT NOT NULL,
    job_no_degree_mention BOOLEAN NOT NULL,
    job_health_insurance BOOLEAN NOT NULL,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg DOUBLE PRECISION,
    salary_hour_avg DOUBLE PRECISION,
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
);
COPY jobs(
    job_id, company_id, job_title_short, job_title, job_location,
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance,
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
FROM '/tmp/jobs.csv'
DELIMITER ','
CSV HEADER;

-- Company table
CREATE TABLE company_dim (
    company_id BIGINT NOT NULL PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);
COPY company_dim(
    company_id, name, link, link_google, thumbnail
)
FROM '/tmp/company_dim.csv'
DELIMITER ','
CSV HEADER;

-- Skills table
CREATE TABLE skills_dim (
    skill_id BIGINT NOT NULL PRIMARY KEY,
    skills TEXT NOT NULL,
    type TEXT NOT NULL
);
COPY skills_dim(skill_id, skills, type)
FROM '/tmp/skills_dim.csv'
DELIMITER ','
CSV HEADER;

-- Skills-job mapping table
CREATE TABLE skills_job_dim (
    job_id BIGINT NOT NULL,
    skill_id BIGINT NOT NULL,
    CONSTRAINT fk_job FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    CONSTRAINT fk_skill FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id)
);
COPY skills_job_dim(job_id, skill_id)
FROM '/tmp/skills_job_dim.csv'
DELIMITER ','
CSV HEADER;

-- =============================
-- INDEXING FOR PERFORMANCE
-- =============================
CREATE INDEX idx_jobs_job_id ON jobs(job_id);
CREATE INDEX idx_jobs_company_id ON jobs(company_id);
CREATE INDEX idx_company_dim_company_id ON company_dim(company_id);
CREATE INDEX idx_skills_dim_skill_id ON skills_dim(skill_id);
CREATE INDEX idx_skills_job_dim_job_id ON skills_job_dim(job_id);
CREATE INDEX idx_skills_job_dim_skill_id ON skills_job_dim(skill_id);

-- =============================
-- BASIC DATA CHECKS
-- =============================
SELECT COUNT(*) AS total_jobs FROM jobs;
SELECT COUNT(*) AS total_companies FROM company_dim;
SELECT COUNT(*) AS total_skills FROM skills_dim;
SELECT COUNT(*) AS total_job_skills FROM skills_job_dim;

SELECT * FROM jobs LIMIT 5;
SELECT * FROM company_dim LIMIT 5;
SELECT * FROM skills_dim LIMIT 5;
SELECT * FROM skills_job_dim LIMIT 5;

-- =============================
-- ANALYTICAL QUERIES
-- =============================

-- Jobs with a specific skill
SELECT j.job_id, j.job_title, s.skills
FROM jobs j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE s.skills ILIKE '%Python%'
LIMIT 20;

-- Companies with average job salary
SELECT c.company_id, c.name, AVG(j.salary_year_avg) AS avg_salary
FROM company_dim c
JOIN jobs j ON c.company_id = j.company_id
GROUP BY c.company_id, c.name
ORDER BY avg_salary DESC
LIMIT 20;

-- Count of jobs per company
SELECT c.name, COUNT(j.job_id) AS total_jobs
FROM company_dim c
LEFT JOIN jobs j ON c.company_id = j.company_id
GROUP BY c.name
ORDER BY total_jobs DESC
LIMIT 20;

-- Skills demand (most requested skills)
SELECT s.skills, COUNT(sj.job_id) AS job_count
FROM skills_dim s
JOIN skills_job_dim sj ON s.skill_id = sj.skill_id
GROUP BY s.skills
ORDER BY job_count DESC
LIMIT 20;

-- =============================
-- SALARY ANALYSIS
-- =============================

-- Salary bucket classification
SELECT 
    CASE 
        WHEN salary_year_avg < 40000 THEN 'Low'
        WHEN salary_year_avg BETWEEN 40000 AND 80000 THEN 'Medium'
        WHEN salary_year_avg > 80000 THEN 'High'
        ELSE 'Unknown'
    END AS salary_bucket,
    COUNT(*) AS job_count
FROM jobs
GROUP BY salary_bucket
ORDER BY job_count DESC;

-- Average salary for remote vs on-site jobs
SELECT job_work_from_home, AVG(salary_year_avg) AS avg_salary
FROM jobs
GROUP BY job_work_from_home;

-- =============================
-- SUMMARY STATISTICS
-- =============================
-- Only total companies since no numeric columns in company_dim
SELECT COUNT(*) AS total_companies
FROM company_dim;

-- =============================
-- DATA INTEGRITY CHECKS
-- =============================
-- Jobs with missing companies
SELECT *
FROM jobs
WHERE company_id NOT IN (SELECT company_id FROM company_dim);

-- Skills-job entries without valid jobs or skills
SELECT *
FROM skills_job_dim
WHERE job_id NOT IN (SELECT job_id FROM jobs)
   OR skill_id NOT IN (SELECT skill_id FROM skills_dim);
