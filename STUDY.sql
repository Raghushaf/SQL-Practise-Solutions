-- Show first name, last name, and gender of patients who's gender is ‘M'

SELECT first_name, last_name, gender 
FROM patients 
where 
    gender='M';

-- Show first name and last name of patients who does not have allergies. (null)

SELECT first_name, last_name 
FROM patients 
where 
    allergies is null;

-- Show first name of patients that start with the letter 'C'

SELECT first_name 
FROM patients 
where 
    first_name like 'C%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT first_name,last_name 
FROM patients 
where 
        weight between 100 and 120;

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

update patients set allergies='NKA' where allergies is null;

-- Show first name and last name concatinated into one column to show their full name.

select first_name ||' '|| last_name as 'Full Name' from patients;

-- Show first name, last name, and the full province name of each patient.
-- Example: 'Ontario' instead of 'ON'

SELECT p.first_name, p.last_name, n.province_name
FROM patients as p , province_names as n
WHERE p.province_id=n.province_id;


select first_name,
		last_name,
        province_name
from patients p
Inner join province_names as n on p.province_id=n.province_id;

-- Show how many patients have a birth_date with 2010 as the birth year.

select count(*) AS TOTAL_PATIENTS 
from patients 
where 
    YEAR(birth_date)=2010;


-- Show the first_name, last_name, and height of the patient with the greatest height.

SELECT first_name, last_name, height 
from patients
where 
    height=(select max(height) from patients);

-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000

select * 
from patients 
where 
patient_id in (1,45,534,879,1000);

-- Show the total number of admissions.

select count(*) as "Total no of addmissions " from admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT *
FROM admissions
WHERE admission_date = discharge_date;

select * from admissions 
where 
    day(admission_date)- day(discharge_date)=0 
    and month(admission_date)- MONTH(discharge_date)=0
    AND year(admission_date)- YEAR(discharge_date)=0;

-- Show the total number of admissions for patient_id 579.

SELECT patient_id,COUNT(*) as total_number_of_addmission 
FROM admissions 
WHERE 
    patient_id=579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

select distinct city 
from patients 
where province_id = 'NS';


-- Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70

select first_name, last_name, birth_date
from patients 
where 
	height >160 and weight > 70;
-- Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null

select first_name , last_name , allergies 
from patients 
where 
    city = 'Hamilton' and allergies is not null;

-- Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). 
-- Show the result order in ascending by city.

1.  SELECT distinct city from patients
    where left(city,1) in ('A','E','I','O','U')
    order by city;

2.  SELECT distinct first_name from actor
    where lower(left(first_name,1)) in ('a','e','i','o','u')
    order by first_name;


3.  select distinct city
    from patients
    where
    city like 'a%'
    or city like 'e%'
    or city like 'i%'
    or city like 'o%'
    or city like 'u%'
    order by city

-- Show unique birth years from patients and order them by ascending.

select DISTINCT YEAR(birth_date) from patients
order by birth_date;

-- Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list.
-- If only 1 person is named 'Leo' then include them in the output.

select distinct first_name 
from patients 
group by first_name
having count(first_name)=1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
1.  SELECT
    patient_id,
    first_name
    FROM patients
    WHERE first_name LIKE 's____%s';

2.  select patient_id , first_name from patients 
    where first_name like 's%s' and Length(FIRST_name)>=6;

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.

select p.patient_id , p.first_name ,p.last_name
from patients as p , admissions as a
where p.patient_id = a.patient_id and diagnosis= 'Dementia';

select p.patient_id , first_name ,last_name
from patients as p
INNER JOIN admissions as a on p.patient_id = a.patient_id
where a.diagnosis='Dementia'

-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphbetically

select first_name from patients 
order by length(first_name),first_name;

-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.

        with data as( select gender,count(gender) as amount
        from patients 
        group by gender)

        select 
            MAX(case when gender='M' then amount end) as MALE_COUNT,
            max(case when gender='F' then amount end) as FEMALE_COUNT
        from data;

SELECT 
(SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
(SELECT count(*) FROM patients WHERE gender='F') AS female_count;

SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients;

select 
  sum(case when gender = 'M' then 1 end) as male_count,
  sum(case when gender = 'F' then 1 end) as female_count 
from patients;


-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
-- Show results ordered ascending by allergies then by first_name then by last_name.

SELECT first_name, last_name, allergies 
from patients 
where allergies in ('Penicillin','Morphine') 
order by allergies, first_name, last_name;

SELECT
  first_name,
  last_name,
  allergies
FROM
  patients
WHERE
  allergies = 'Penicillin'
  OR allergies = 'Morphine'
ORDER BY
  allergies ASC,
  first_name ASC,
  last_name ASC;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

select patient_id, diagnosis 
from admissions
group by patient_id, diagnosis
having count(diagnosis)>1;

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.

select city ,count(*) as 'Num_patients'
from patients 
group by city 
order by c desc, city;

-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"

select first_name , last_name,'Patient' as role
from patients
union all
select first_name , last_name,'Doctor' as role
from doctors;

-- Show all allergies ordered by popularity. Remove NULL values from query.

1.    select allergies, count(allergies) as popularity
    from patients 
    where allergies is not null
    group by allergies
    order by popularity desc;

2.   select allergies, count(allergies) as popularity
    from patients 
    group by allergies
    having allergies is not null
    order by popularity desc;

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
-- Sort the list starting from the earliest birth_date.

1.    select first_name, last_name ,birth_date 
    from patients
    where YEAR(birth_date) between 1970 and 1979
    ORDER BY birth_date;

2.    SELECT
    first_name,
    last_name,
    birth_date
    FROM patients
    WHERE
    birth_date >= '1970-01-01'
    AND birth_date < '1980-01-01'
    ORDER BY birth_date ASC

3.    SELECT
    first_name,
    last_name,
    birth_date
    FROM patients
    WHERE year(birth_date) LIKE '197%'
    ORDER BY birth_date ASC

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first,
-- then first_name in all lower case letters. Separate the last_name and first_name with a comma.
-- Order the list by the first_name in decending order
-- EX: SMITH,jane

1.    select upper(last_name) ||','|| lower(first_name) as name 
    from patients
    order by first_name desc;

2.   SELECT
    CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
    FROM patients
    ORDER BY first_name DESC;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

select province_id, sum(height) as total_sum
from patients 
group by province_id
having total_sum >=7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
-- Sort by the day with most admissions to least admissions.

select day(admission_date) as day_number, count(admission_date) as no_of_admissions
from admissions
group by day(admission_date)
order by no_of_admissions desc;

-- Show all columns for patient_id 542's most recent admission_date.

1.   select * 
    from admissions
    where patient_id = 542
    order by admission_date desc limit 1;

2.   SELECT *
    FROM admissions
    WHERE
    patient_id = '542'
    AND admission_date = (
        SELECT MAX(admission_date)
        FROM admissions
        WHERE patient_id = '542'
    )

3.   SELECT *
    FROM admissions
    GROUP BY patient_id
    HAVING
    patient_id = 542
    AND max(admission_date)

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

1.    select patient_id, attending_doctor_id, diagnosis 
    from admissions
    where patient_id%2<>0 and attending_doctor_id in (1,5,19)

    union 

    select patient_id, attending_doctor_id, diagnosis 
    from admissions
    where length(patient_id)=3 and attending_doctor_id like '%2%';

2.    SELECT
    patient_id,
    attending_doctor_id,
    diagnosis
    FROM admissions
    WHERE
    (
        attending_doctor_id IN (1, 5, 19)
        AND patient_id % 2 != 0
    )
    OR 
    (
        attending_doctor_id LIKE '%2%'
        AND len(patient_id) = 3
    )

-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.

1.      SELECT
        first_name,
        last_name,
        count(*) as admissions_total
        from admissions a
        join doctors ph on ph.doctor_id = a.attending_doctor_id
        group by attending_doctor_id

2.      SELECT
        first_name,
        last_name,
        count(*)
        from
        doctors p,
        admissions a
        where
        a.attending_doctor_id = p.doctor_id
        group by p.doctor_id;

-- For each physicain, display their id, full name, and the first and last admission date they attended.

select 	
    doctor_id,
    first_name ||' '|| last_name as full_name,
    min(admission_date) as first_admission_date, 
    max(admission_date) as last_admission_date
from doctors d
	join admissions a on d.doctor_id=a.attending_doctor_id
group by doctor_id;

-- Display the total amount of patients for each province. Order by descending.

select province_name, count(*) as patient_count
from patients ps
join province_names pn on ps.province_id = pn.province_id
group by province_name
order by patient_count desc;

-- For every admission, display the patient's full name, their admission diagnosis, and
-- their doctor's full name who diagnosed their problem.

1.    SELECT
    CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
    diagnosis,
    CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
    FROM patients
    JOIN admissions ON admissions.patient_id = patients.patient_id
    JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;



2.    with data as (select first_name|| ' ' || last_name as patient_name,
            diagnosis,
            attending_doctor_id
    from patients ps 
    join admissions as ad on ps.patient_id=ad.patient_id)

    select 	patient_name,
            diagnosis,
            first_name || ' ' || last_name as doc_f_name 
    from doctors ds 
    join data on ds.doctor_id=data.attending_doctor_id;

-- display the number of duplicate patients based on their first_name and last_name.

select first_name ,last_name, count(*) as no_of_duplicate
from patients
group by first_name, last_name
having no_of_duplicate>1;

-- Show all of the patients grouped into weight groups.
-- Show the total amount of patients in each weight group.
-- Order the list by the weight group decending.

-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

1.  select count(*) as patient_in_group, 
            weight as weight_group 
    from (select 
        case
        when weight between 140 and 149 then 140
        when weight between 130 and 139 then 130
        when weight between 120 and 129 then 120
        when weight between 110 and 119 then 110
        when weight between 100 and 109 then 100
        when weight between 90 and 99 then 90
        when weight between 80 and 89 then 80
        when weight between 70 and 79 then 70
        when weight between 60 and 69 then 60
        when weight between 50 and 59 then 50
        when weight between 40 and 49 then 40
        when weight between 30 and 39 then 30
        when weight between 20 and 29 then 20
        when weight between 10 and 19 then 10
        else 0 
        end as weight
    from patients) as data
    group by weight
    order by weight desc;

2.  SELECT
    COUNT(*) AS patients_in_group,
    FLOOR(weight / 10) * 10 AS weight_group
    FROM patients
    GROUP BY weight_group
    ORDER BY weight_group DESC;
    
3.  SELECT
    TRUNCATE(weight, -1) AS weight_group,
    count(*)
    FROM patients
    GROUP BY weight_group
    ORDER BY weight_group DESC;

4.  SELECT
    count(patient_id),
    weight - weight % 10 AS weight_group
    FROM patients
    GROUP BY weight_group
    ORDER BY weight_group DESC

-- Show patient_id, weight, height, isObese from the patients table.

-- Display isObese as a boolean 0 or 1.

-- Obese is defined as weight(kg)/(height(m)2) >= 30.

-- weight is in units kg.

-- height is in units cm.

1.  select patient_id, weight , height,
        (case 
        WHEN (weight/POWER((height/100.0),2))>=30 THEN 1
        ELSE 0
        END) as isObese 
    from patients

2.  SELECT
    patient_id,
    weight,
    height,
    weight / power(CAST(height AS float) / 100, 2) >= 30 AS obese
    FROM patients

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

-- Check patients, admissions, and doctors tables for required information.

1.  SELECT
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    ph.specialty AS attending_doctor_specialty

    FROM patients p
    JOIN admissions a ON a.patient_id = p.patient_id
    JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
    WHERE
    ph.first_name = 'Lisa' and
    a.diagnosis = 'Epilepsy'

2.  SELECT
    pa.patient_id,
    pa.first_name,
    pa.last_name,
    ph1.specialty
    FROM patients AS pa
    JOIN (
        SELECT *
        FROM admissions AS a
        JOIN doctors AS ph ON a.attending_doctor_id = ph.doctor_id
    ) AS ph1 USING (patient_id)
    WHERE
    ph1.diagnosis = 'Epilepsy'
    AND ph1.first_name = 'Lisa'

3.  SELECT
        a.patient_id,
        a.first_name,
        a.last_name,
        b.specialty
    FROM
        patients a,
        doctors b,
        admissions c
    WHERE
        a.patient_id = c.patient_id
        AND c.attending_doctor_id = b.doctor_id
        AND c.diagnosis = 'Epilepsy'
        AND b.first_name = 'Lisa';

4.  with patient_table as (
        SELECT
        patients.patient_id,
        patients.first_name,
        patients.last_name,
        admissions.attending_doctor_id
        FROM patients
        JOIN admissions ON patients.patient_id = admissions.patient_id
        where
        admissions.diagnosis = 'Epilepsy'
    )
    select
    patient_table.patient_id,
    patient_table.first_name,
    patient_table.last_name,
    doctors.specialty
    from patient_table
    JOIN doctors ON patient_table.attending_doctor_id = doctors.doctor_id
    WHERE doctors.first_name = 'Lisa';

-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password. 

-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date

1.    select 
        distinct ps.patient_id,
        cast(ps.patient_id||length(last_name)||YEAR(birth_date) as int) as temp_password 
    from patients ps
    join admissions ad on ps.patient_id=ad.patient_id

2.   SELECT
    DISTINCT P.patient_id,
    CONCAT(
        P.patient_id,
        LEN(last_name),
        YEAR(birth_date)
    ) AS temp_password
    FROM patients P
    JOIN admissions A ON A.patient_id = P.patient_id

3.    select
    pa.patient_id,
    ad.patient_id || floor(len(pa.last_name)) || floor(year(pa.birth_date)) as temp_password
    from patients pa
    join admissions ad on pa.patient_id = ad.patient_id
    group by pa.patient_id;

-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
-- All patients with an even patient_id have insurance. 
-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance.
-- Add up the admission_total cost for each has_insurance group.

1.    with data as (select *,
        case 
        when patient_id%2=0 then 'Yes'
        else 'No' 
        end as Has_insurance 
    from admissions)

    select 
        has_insurance,
        case 
        when Has_insurance='Yes' then count(Has_insurance)*10
        else count(Has_insurance)*50
        end as cost_afer_insurance
    from data 
    group by Has_insurance;

2.    select has_insurance,sum(admission_cost) as admission_total
    from
    (
    select patient_id,
    case when patient_id % 2 = 0 then 'Yes' else 'No' end as has_insurance,
    case when patient_id % 2 = 0 then 10 else 50 end as admission_cost
    from admissions
    )
    group by has_insurance


3.    select 'No' as has_insurance, count(*) * 50 as cost
    from admissions where patient_id % 2 = 1 group by has_insurance
    union
    select 'Yes' as has_insurance, count(*) * 10 as cost
    from admissions where patient_id % 2 = 0 group by has_insurance


4.    SELECT
    has_insurance,
    CASE
        WHEN has_insurance = 'Yes' THEN COUNT(has_insurance) * 10
        ELSE count(has_insurance) * 50
    END AS cost_after_insurance
    FROM (
        SELECT
        CASE
            WHEN patient_id % 2 = 0 THEN 'Yes'
            ELSE 'No'
        END AS has_insurance
        FROM admissions
    )
    GROUP BY has_insurance


-- Show the provinces that has more patients identified as 'M' than 'F'. 
-- Must only show full province_name

1.    select province_name
    from province_names pn
    join patients ps on ps.province_id=pn.province_id
    group by 
        pn.province_name
    having 
        sum(ps.gender='M')>sum(ps.gender='F')

        
2.    SELECT pr.province_name
    FROM patients AS pa
    JOIN province_names AS pr ON pa.province_id = pr.province_id
    GROUP BY pr.province_name
    HAVING
    COUNT( CASE WHEN gender = 'M' THEN 1 END) > COUNT( CASE WHEN gender = 'F' THEN 1 END);

3.    SELECT province_name
    FROM patients p
    JOIN province_names r ON p.province_id = r.province_id
    GROUP BY province_name
    HAVING
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE -1 END) > 0

4.    SELECT pr.province_name
    FROM patients AS pa
    JOIN province_names AS pr ON pa.province_id = pr.province_id
    GROUP BY pr.province_name
    HAVING
    COUNT( CASE WHEN gender = 'M' THEN 1 END) > COUNT(*) * 0.5;

-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- - First_name contains an 'r' after the first two letters.
-- - Identifies their gender as 'F'
-- - Born in February, May, or December
-- - Their weight would be between 60kg and 80kg
-- - Their patient_id is an odd number
-- - They are from the city 'Kingston'

select * 
from patients
where 
	first_name like '__%r%'
    and gender='F' 
    and MONTH(birth_date) in (2,5,12) 
    and (weight between 60 and 80)
    and patient_id%2<>0
    AND CITY='Kingston';

-- Show the percent of patients that have 'M' as their gender. 
-- Round the answer to the nearest hundreth number and in percent form.

select 
	round(count(case when gender='M' then 1 END)*100.0/count(*),2) || '%' as percent_of_male_patients 
from patients

SELECT
  round(100 * avg(gender = 'M'), 2) || '%' AS percent_of_male_patients
FROM
  patients;

SELECT 
   CONCAT(ROUND(SUM(gender='M') / CAST(COUNT(*) AS float), 4) * 100, '%')
FROM patients;

-- Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

1.  select province_name
    from province_names
    order by 
        (case when province_name='Ontario' then 0 else 1 end)

2.    select province_name
    from province_names
    order by
    (not province_name = 'Ontario'),
    province_name

-- For each day display the total amount of admissions on that day. 
-- Display the amount changed from the previous date.

select distinct admission_date,
	count(*) total_no_of_admission,
    count(admission_date)-lag(count(admission_date)) over(order by admission_date) as change
from admissions
group by admission_date

WITH admission_counts_table AS (
  SELECT admission_date, COUNT(patient_id) AS admission_count
  FROM admissions
  GROUP BY admission_date
  ORDER BY admission_date DESC
)
select
  admission_date, 
  admission_count, 
  admission_count - LAG(admission_count) OVER(ORDER BY admission_date) AS admission_count_change 
from admission_counts_table