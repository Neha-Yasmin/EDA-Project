-- viewing the data of 365_database

-- data of course_info table
SELECT 
    *
FROM
    365_course_info
ORDER BY course_id
LIMIT 15;

-- data of course_ratings table
SELECT 
    *
FROM
    365_course_ratings
ORDER BY student_id
LIMIT 15;


-- data cleaning - ensuring that the data is complete, correct and consistent
-- 1. checking if any record has a null value for every column
SELECT 
    *
FROM
    365_course_info
WHERE
    course_title IS NULL;


SELECT 
    *
FROM
    365_course_ratings
WHERE
	student_id is null or course_rating is null or date_rated IS NULL;

SELECT 
    *
FROM
    365_exam_info
WHERE
    exam_id IS NULL OR exam_category IS NULL
        OR exam_duration IS NULL;
        
SELECT 
    *
FROM
    365_quiz_info
WHERE
    quiz_id IS NULL OR question_id IS NULL
        OR answer_id IS NULL
        OR answer_correct is null;
        
SELECT 
    *
FROM
    365_student_engagement
WHERE
    engagement_id IS NULL
        OR engagement_exams IS NULL
        OR student_id IS NULL
        OR engagement_quizzes IS NULL
        OR engagement_lessons IS NULL
        OR date_engaged IS NULL;        

SELECT 
    *
FROM
    365_student_exams
WHERE
    exam_attempt_id IS NULL
        OR student_id IS NULL
        OR exam_id IS NULL
        OR exam_result IS NULL
        OR exam_completion_time IS NULL
        OR date_exam_completed IS NULL;

SELECT 
    *
FROM
    365_student_hub_questions
WHERE
    hub_question_id IS NULL
        OR student_id IS NULL
        OR date_question_asked IS NULL;

SELECT 
    *
FROM
    365_student_info
WHERE
    student_country IS NULL
        OR student_id IS NULL
        OR date_registered IS NULL;

SELECT 
    *
FROM
    365_student_learning
WHERE
    student_id IS NULL OR course_id IS NULL
        OR minutes_watched IS NULL
        OR date_watched IS NULL;

SELECT 
    *
FROM
    365_student_purchases
WHERE
    purchase_id IS NULL
        OR purchase_type IS NULL
        OR student_id IS NULL
        OR date_purchased IS NULL;
        
        


SELECT 
    *
FROM
    365_student_quizzes
WHERE
    answer_id IS NULL
        OR student_id IS NULL
        OR quiz_id IS NULL
        OR question_id IS NULL;

-- replacing null values in the answer_id column with 0.
 UPDATE 365_student_quizzes 
SET 
    answer_id = 0
WHERE
    answer_id IS NULL;
    
SELECT 
    *
FROM
    365_student_quizzes
WHERE
    answer_id = 0;
 

-- 2. checking for duplicates, use Distinct
SELECT DISTINCT
    course_id, course_title
FROM
    365_course_info;

-- comparing the no of returned row in the above query to total number of rows.
select * from 365_course_info;


SELECT DISTINCT
    course_id, student_id, course_rating, date_rated
FROM
    365_course_ratings;
    
SELECT 
    *
FROM
    365_course_ratings;


SELECT DISTINCT
    quiz_id, question_id, answer_id, answer_correct
FROM
    365_quiz_info;
    
SELECT 
    *
FROM
    365_quiz_info;
    
    

SELECT DISTINCT
    engagement_id, student_id, engagement_quizzes, engagement_exams, engagement_lessons
FROM
    365_student_engagement;

SELECT 
    *
FROM
    365_student_engagement;
    
    

SELECT DISTINCT
    exam_attempt_id,
    student_id,
    exam_id,
    exam_result,
    exam_completion_time,
    date_exam_completed
FROM
    365_student_exams;
    
SELECT 
    *
FROM
    365_student_exams;
    


SELECT DISTINCT
    hub_question_id, student_id, date_question_asked
FROM
    365_student_hub_questions;
    
select * from 365_student_hub_questions;



SELECT DISTINCT
    student_id, student_country, date_registered
FROM
    365_student_info;

SELECT 
    *
FROM
    365_student_info;
    
    
    
SELECT DISTINCT
    student_id, course_id, minutes_watched, date_watched
FROM
    365_student_learning;
    
SELECT 
    *
FROM
    365_student_learning;
    
    
    
SELECT DISTINCT
    purchase_id, student_id, date_purchased
FROM
    365_student_purchases;
    
SELECT 
    *
FROM
    365_student_purchases;
    
    
    
SELECT DISTINCT
    student_id, quiz_id, question_id, answer_id
FROM
    365_student_quizzes;
    
select * from 365_student_quizzes;


-- anaysis
-- 1. 
SELECT 
    date_rated, date_exam_completed
FROM
    365_course_ratings cr
        JOIN
    365_student_exams se ON cr.student_id = se.student_id;
    
SELECT 
    date_rated, date_exam_completed
FROM
    365_course_ratings cr
        JOIN
    365_student_exams se ON cr.student_id = se.student_id
WHERE
    date_rated >= date_exam_completed;
 
 -- the result shows that 24,082 student rated the course before giving the exam.
 
 -- 2. 
 SELECT 
    date_rated, date_purchased
FROM
    365_course_ratings cr
        JOIN
    365_student_purchases se ON cr.student_id = se.student_id;
    
SELECT 
    date_rated, date_purchased
FROM
    365_course_ratings cr
        JOIN
    365_student_purchases se ON cr.student_id = se.student_id
WHERE
    date_rated >= date_purchased;
/* 491 students have rated the courses based on the free videos and material provided and not on the basis of the 
entire course i.e. before purchasing the course. */

-- 3.
SELECT 
    date_exam_completed, date_purchased
FROM
    365_student_exams se
        JOIN
    365_student_purchases sp ON se.student_id = sp.student_id;
    

SELECT 
    date_exam_completed, date_purchased
FROM
    365_student_exams se
        JOIN
    365_student_purchases sp ON se.student_id = sp.student_id
WHERE
    date_exam_completed > date_purchased;
-- out of 40491 students 13,239 preferred giving practice exam 1 before purchasing the entire course.


-- 4. Top 10 bestselling courses
SELECT 
    cr.course_id, COUNT(cr.course_id) AS course_count, ci.course_title
FROM
    365_course_ratings cr
        JOIN
    365_course_info ci ON cr.course_id = ci.course_id
GROUP BY cr.course_id
ORDER BY course_count desc
limit 10;

-- 5. Countries having maximum students
SELECT 
    student_country, COUNT(student_id) AS no_of_students
FROM
    365_student_info
GROUP BY student_country
ORDER BY COUNT(student_id) DESC
LIMIT 5;

-- 6. students enrolled in multiple courses
SELECT 
    si.student_id, COUNT(DISTINCT sl.course_id) AS no_of_courses
FROM
    365_course_info ci
        JOIN
    365_student_learning sl ON ci.course_id = sl.course_id
        JOIN
    365_student_info si ON sl.student_id = si.student_id
GROUP BY student_id
ORDER BY no_of_courses desc;


-- 7. On an average how many minutes a course is watched per day?
SELECT 
    course_id, ROUND(AVG(minutes_watched), 2) avg_minute_watched
FROM
    365_student_learning
GROUP BY course_id
ORDER BY course_id;

-- 7. On an average how many minutes a student spend watching the course videos per day?
SELECT 
    ROUND(AVG(minutes_watched), 2) avg_minute_watched
FROM
    365_student_learning;


-- 8. Top rated course
SELECT 
    cr.course_id,
    ci.course_title,
    AVG(cr.course_rating) AS overall_rating
FROM
    365_course_ratings cr
        JOIN
    365_course_info ci ON cr.course_id = ci.course_id
GROUP BY cr.course_id
ORDER BY overall_rating DESC
LIMIT 5;


-- 9.  Students purchasing the subscription.
SELECT 
    COUNT(distinct si.student_id) AS free_learners
FROM
    365_student_info si;
    
-- out of 35230 students only 2135 are purchasing the subscription.
SELECT 
    COUNT(distinct si.student_id) AS free_learners
FROM
    365_student_purchases si;
