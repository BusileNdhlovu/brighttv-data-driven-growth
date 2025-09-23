SELECT * FROM viewership
LIMIT 10;

SELECT * FROM USERPROFILE
LIMIT 10;



--JOIN THE TWO TABLES

SELECT * FROM userprofile AS u
JOIN viewership AS v ON u.userid = v."UserID";


--Joined table named tv

SELECT * FROM broadcast.public.tv
LIMIT 10;


--DATA CLEANING 
--checking if the userid columns are identical

SELECT userid,"userid", "UserID" 
FROM broadcast.public.tv
LIMIT 10;

--removing the two columns userid as they are three identical columns

ALTER TABLE broadcast.public.tv
DROP COLUMN "userid", "UserID";

--Checking for Nulls

SELECT
     SUM( CASE WHEN userid IS NULL THEN 1 ELSE 0 END) AS userid_id_missing,
     SUM( CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_missing,
     SUM( CASE WHEN surname IS NULL THEN 1 ELSE 0 END) AS surname_missing,
     SUM( CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS email_missing,
     SUM( CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_missing,
     SUM( CASE WHEN race IS NULL THEN 1 ELSE 0 END) AS race_missing,
     SUM( CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_missing,
     SUM( CASE WHEN province IS NULL THEN 1 ELSE 0 END) AS province_missing,
     SUM( CASE WHEN social_media_handle IS NULL THEN 1 ELSE 0 END) AS social_media_handle_missing,
     SUM( CASE WHEN channel2 IS NULL THEN 1 ELSE 0 END) AS channel2_missing,
     SUM( CASE WHEN recorddate2 IS NULL THEN 1 ELSE 0 END) AS recorddate2_missing,
     SUM( CASE WHEN duration_2 IS NULL THEN 1 ELSE 0 END) AS duration_2_missing,
FROM broadcast.public.tv;

--Replacing NULL values

UPDATE broadcast.public.tv
SET race ='Unknown'
WHERE race IS NULL;

--checking the none value in the table
--its saved as a string
--what now??

SELECT * FROM tv WHERE province = 'None';


--Checking for duplicates

SELECT userid, name, surname, email,
       COUNT(*) AS duplicate_count
FROM broadcast.public.tv
GROUP BY  userid, name, surname, email
HAVING COUNT(*) > 1;

--Deleting duplicates


--Checking the data type of columns in the table

DESC TABLE tv;

--Change the data type of column reccorddate2 (its saved as a varchar)

SELECT userid,
       name,
       surname,
       age,
       gender,
       race,
       province,
       channel2,

       --time change
       TO_DATE(recorddate2, 'YYYY/MM/DD HH24:MI') AS clean_date,
       DAYNAME(clean_date) AS Day_of_week,
       TO_TIME(recorddate2, 'YYYY/MM/DD HH24:MI') AS time_only,
       TO_CHAR(time_only, 'YYYY/MM/DD HH24:MI') AS time_with_am_pm, 
    
       --Age bucket
     CASE
         WHEN age BETWEEN 0 AND 12 THEN '0-12 Child'
         WHEN age BETWEEN 13 AND 17 THEN '13-17 Child'
         WHEN age BETWEEN 18 AND 24 THEN '18-24 Child'
         WHEN age BETWEEN 25 AND 59 THEN '25-59 Child'
        ELSE 'Older Adult'
     END AS age_bucket,

         --time bucket
     CASE
         WHEN DATE_PART('hour', TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN 0 AND 6 THEN 'Night'
         WHEN DATE_PART('hour', TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN 7 AND 12 THEN 'Morning'
         WHEN DATE_PART('hour', TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN 13 AND 18 THEN 'Afternoon'
         WHEN DATE_PART('hour', TO_TIMESTAMP(recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN 19 AND 23 THEN 'Evening'
        ELSE 'Unknown'
    END AS time_bucket
FROM broadcast.public.tv;