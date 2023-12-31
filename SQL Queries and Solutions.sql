-- Uploaded project file to MySQL Workbench 8.0 as a new schema (datascience365_career_track_analysis)

USE datascience365_career_track_analysis;

WITH overall AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY student_id, track_name DESC) AS student_track_id,
        e.student_id,
        t.track_id,
        t.track_name,
        e.date_enrolled,
        e.date_completed,
        IF(e.date_completed IS NULL, 0, 1) AS track_completed,
        DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
    FROM career_track_student_enrollments AS e
    LEFT JOIN career_track_info AS t
    ON e.track_id = t.track_id
),
final AS (
    SELECT *,
        CASE 
            WHEN days_for_completion = 0 THEN 'Same day'
            WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
            WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
            WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
            WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
            WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
            WHEN days_for_completion >= 366 THEN '366+ days'
        END AS completion_bucket
    FROM overall
)


-- Question 1:
-- Study your solution to Extracting the Data with SQL. How many days did it take the student with the most extended completion period to complete a career track?
SELECT *
FROM final
WHERE track_completed = 1
ORDER BY days_for_completion DESC;
 -- Answer: 482 days
 
 
-- Question 2:
-- Study your solution to Extracting the Data with SQL. Referring to the student in the previous question, what career track did the student complete?
SELECT *
FROM final
WHERE student_id = 10549;
-- Answer: Data Analyst


-- Question 3:
-- Study your solution to Extracting the Data with SQL. How many track completions are there in total?
SELECT COUNT(track_completed)
FROM final
WHERE track_completed = 1;
-- Answer: 123


-- Questions below are meant for tableau visualization. Nonetheless, SQL will be able to answer part of the questions too. Further insights shall be derived using Tableau.
-- Question 4:
-- What is the number of enrolled students monthly? 
-- Which is the month with the most enrollments? Speculate about the reason for the increased numbers.
SELECT 
	YEAR(date_enrolled) AS year_enrolled,
	MONTH(date_enrolled) AS month_enrolled, 
	COUNT(student_track_id) as enrollment_count
FROM final
GROUP BY year_enrolled, month_enrolled
ORDER BY enrollment_count DESC
-- Answer: Monthly enrollment count, in descending order, as per table below. August 2022 had the highest enrollment numbers
# year_enrolled, month_enrolled, enrollment_count
'2022', '8', '1653'
'2022', '1', '1284'
'2022', '3', '1216'
'2022', '6', '1192'
'2022', '2', '1021'
'2022', '4', '978'
'2022', '7', '958'
'2022', '5', '898'
'2022', '9', '815'
'2022', '10', '426'

-- Question 5:
-- Which career track do students enroll most in?
SELECT 
    track_name,
    COUNT(student_track_id) AS enrollment_count,
    CONCAT(ROUND((COUNT(student_track_id) / (SELECT COUNT(*) FROM final)) * 100, 2), '%') AS enrollment_percentage
FROM final
GROUP BY track_name 
ORDER BY enrollment_count DESC;
-- Answer: The most popular track enrolled is the Data Analyst Track which had enrollment count of 5130, 49.13% of the total enrollment.
'Data Analyst', '5130', '49.13%'
'Data Scientist', '3843', '36.81%'
'Business Analyst', '1468', '14.06%'

-- Question 5:
-- What is the career track completion rate? Can you say if it’s increasing, decreasing, or staying constant with time?


-- Question 6:
-- How long does it typically take students to complete a career track? 
-- What type of subscription is most suitable for students who aim to complete a career track: monthly, quarterly, or annual?
SELECT
    completion_bucket,
    frequency,
    recomm_subscription_period,
    SUM(frequency) OVER (PARTITION BY recomm_subscription_period) AS subtotal_frequency
FROM (
    SELECT 
        completion_bucket,
        COUNT(student_track_id) AS frequency,
        CASE
            WHEN completion_bucket IN ('Same day', '1 to 7 days', '8 to 30 days') THEN 'Monthly'
            WHEN completion_bucket IN ('31 to 60 days', '61 to 90 days') THEN 'Quarterly'
            ELSE 'Annual'
        END AS recomm_subscription_period
    FROM (SELECT * FROM final WHERE track_completed = 1) AS completed_tracks
    GROUP BY completion_bucket, recomm_subscription_period
) AS recomm_subscription
ORDER BY subtotal_frequency DESC
-- Answer: The students typically complete a career track between 91 to 365 days. Based on the overall frequency, the recommended subscription, in general, is Annually followed by Monthly and Quarterly.
# completion_bucket, frequency, recomm_subscription_period, subtotal_frequency
'366+ days', '10', 'Annual', '65'
'91 to 365 days', '55', 'Annual', '65'
'8 to 30 days', '13', 'Monthly', '41'
'Same day', '14', 'Monthly', '41'
'1 to 7 days', '14', 'Monthly', '41'
'61 to 90 days', '5', 'Quarterly', '17'
'31 to 60 days', '12', 'Quarterly', '17'