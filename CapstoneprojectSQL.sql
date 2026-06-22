----- Retrieve all the table1 and table2
Select *
From table1;
Select *
From table2;

---- Join the table1 and table2 
SELECT *
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id;


--- What is the overall Smoking rate
SELECT 
      smoke, 
	  Count(*) AS "Total smokers", 
	  ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1
GROUP BY smoke;

---- What is the overall drinking rate
SELECT 
      drink, 
	  Count(*) AS "Total drinkers", 
	  ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1
GROUP BY drink;

--- Get the average age of patients
SElECT ROUND(AVG(age)) AS "Avg Age"
FROM table1;


-- What is the average age across each gender
SElECT gender, ROUND(AVG(age)) AS "Avg Age"
FROM table1
GROUP BY gender;

-- What is the average age across lifestyle habit
SElECT smoke, drink, ROUND(AVG(age)) AS "Avg Age"
FROM table1
WHERE smoke = 'TRUE' AND drink = 'TRUE'
GROUP BY smoke, drink;

-- What is the average age across lifestyle habit
SElECT smoke, drink, ROUND(AVG(age)) AS "Avg Age"
FROM table1
WHERE smoke = 'false' AND drink = 'false'
GROUP BY smoke, drink;

-- What is the average age across lifestyle habit
SElECT smoke, drink, ROUND(AVG(age)) AS "Avg Age"
FROM table1
GROUP BY smoke, drink;


---Distribution of gender across each Lifestyle
SElECT smoke, drink, gender, COUNT(*),
       ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1
GROUP BY smoke, drink, gender
ORDER BY smoke, drink, gender ASC;

---- What is the count distinct diagnostic lesions type

SELECT 
      count (distinct diagnostic) 
	   AS dis_diagnostic
FROM table2;

---- What is the overall diagnostic lesions type
SELECT 
      diagnostic, 
	  Count(*) AS "Count diagnostic", 
	  ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table2
GROUP BY diagnostic;


---- What is the gender distribution on overall diagnostic lesions type
SELECT 
      diagnostic, gender, Count(*), 
	  ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage" 
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY gender, diagnostic;


---How does lifestyle habits vary by diagnostic?
SElECT smoke, drink, diagnostic, COUNT(*),
       ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY smoke, drink, diagnostic;


---How does lifestyle habits vary by diagnostic both having both smoker and drinker
SElECT diagnostic, COUNT(*),
       ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE smoke = 'TRUE' AND drink = 'TRUE'
GROUP BY diagnostic;

---How does lifestyle habits vary by diagnostic both not drinking and smoking
SElECT diagnostic, COUNT(*),
       ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE smoke = 'false' AND drink = 'false'
GROUP BY diagnostic;

---How does lifestyle habits and gender vary by diagnostic?
SElECT smoke, drink, gender, diagnostic, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY smoke, drink, gender, diagnostic;


---How does Environmental exposure (pesticide) contributes to occurance of lesion in patients?
SElECT diagnostic, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE pesticide = 'false'
GROUP BY diagnostic;

SElECT diagnostic, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE pesticide = 'true'
GROUP BY diagnostic


---How does Environmental exposure pipe water and sewage contributes to occurance of lesion in patients?
SElECT diagnostic, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE has_piped_water = 'false' AND has_sewage_system = 'false'
GROUP BY diagnostic;

SElECT diagnostic, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE has_piped_water = 'true' AND has_sewage_system = 'true'
GROUP BY diagnostic


--- Demographic Factors: What is the age distribution of patients per diagnostic type.

-- What is the average age across each diagnostic type
SElECT diagnostic, ROUND(AVG(age)) AS "Avg Age"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY diagnostic;


---- What is the distinct enthicity
SELECT 
      distinct background_father 
	   AS ethicity_father
FROM table1;

---- What is the distinct enthicity
SELECT 
      distinct background_mother 
	   AS ethicity_mother
FROM table1;



---How does enthicity influences diagnostic lesion type

SELECT background_father, background_mother, diagnostic, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY background_father, background_mother, diagnostic
ORDER BY diagnostic, total DESC;


---What is the distribution of gender to eithicity, skin cancer history and cancer history

SELECT background_father, background_mother, gender, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE skin_cancer_history = 'false' AND cancer_history = 'false' 
GROUP BY background_father, background_mother, gender
ORDER BY gender, total DESC;

SELECT background_father, background_mother, gender, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE skin_cancer_history = 'true' AND cancer_history = 'true' 
GROUP BY background_father, background_mother, gender
ORDER BY gender, total DESC;


---- What is the count fitspatrick skin type

SELECT 
      count (distinct fitspatrick) 
	   AS dis_fitspatrick
FROM table2;

---- What is the overall fitspatrick skin type
SELECT 
      fitspatrick, 
	  Count(*) AS "Count fitspatrick", 
	  ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table2
GROUP BY fitspatrick;

---Distribution of fitspatrick (skintype) across gender
SElECT fitspatrick, gender, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY fitspatrick, gender;



----What is the average age across each fitspatrick skin type
SElECT fitspatrick, ROUND(AVG(age)) AS "Avg Age"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY fitspatrick;

---Distribution of fitspatrick (skintype) across each diagnostic type
SElECT diagnostic, fitspatrick, gender, COUNT(*),
ROUND(Count (*)*100/SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY diagnostic, fitspatrick, gender
ORDER BY diagnostic, fitspatrick, gender DESC;

------------------
SELECT grew,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS cancer_case,
    ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END)
        / COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY grew;


--body region with high cancer risk
SELECT region,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY region
order by region asc;


--average cancer cases when lesion change
SELECT changed,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY changed;


--percentage of when grow and changed 
SELECT changed,grew, COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY changed, grew;

---percrntage of case when cancer when bleed 
SELECT bleed,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY bleed;


--average cancer rate
SELECT biopsed,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY biopsed;

--percentage by skin type
SELECT fitspatrick,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table2
GROUP BY fitspatrick
order by fitspatrick asc;

--join table
select*
from table1 t1 
join table2 t2
on t1.patient_id= t2.patient_id;

-- percentage by smokers
SELECT smoke,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ( 'SCC','MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
from table1 t1 
join table2 t2
on t1.patient_id= t2.patient_id
group by smoke;
-----------------

-------Avg age across cancer_cases
SELECT ROUND(AVG(age)) AS "Avg_Age",
SUM(CASE WHEN diagnostic IN ('SCC','MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('SCC','MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
FROM table1 t1 
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY age
HAVING SUM(CASE WHEN diagnostic IN ('SCC','MEL','BCC') THEN 1 ELSE 0 END) >= 1
ORDER BY Cancer_case DESC;



--percentage by pesticide
SELECT pesticide,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
from table1 t1 
join table2 t2
on t1.patient_id= t2.patient_id
group by pesticide;

--percentage by background_father
SELECT background_father,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
from table1 t1 
join table2 t2
on t1.patient_id= t2.patient_id
group by background_father
order by background_father asc;

--percentage by background_mother
SELECT background_mother,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
from table1 t1 
join table2 t2
on t1.patient_id= t2.patient_id
group by background_mother
order by background_mother asc;


--percentage by family skin cancer history
SELECT skin_cancer_history,gender,COUNT(*) AS total_cases,
SUM(CASE WHEN diagnostic IN ('SCC','MEL','BCC') THEN 1 ELSE 0 END) AS Cancer_case,
ROUND(100.0 * SUM(CASE WHEN diagnostic IN ('SCC','MEL','BCC') THEN 1 ELSE 0 END) 
/ COUNT(*), 2) AS cancer_rate_percent
from table1 t1 
join table2 t2
on t1.patient_id= t2.patient_id
group by skin_cancer_history,gender
order by skin_cancer_history asc;
   
SELECT background_father, background_mother, diagnostic, COUNT(*) AS total, ROUND(COUNT(*)
* 100.0 / SUM(COUNT(*)) OVER(), 2) AS "Percentage"
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY background_father, background_mother, diagnostic
ORDER BY diagnostic, total ASC;

-- gender,drinking and smoking malignancy rate
SElECT gender,drink, smoke, COUNT(*) total_cases, sum(case when diagnostic in('SCC','MEL','BCC')
then 1 else 0 end) as cancer_cases, Round(100 * sum(case when diagnostic in('SCC','MEL','BCC')
then 1 else 0 end)/count(*),2) as percentage
FROM table1 t1 
join table2 t2
on t1.patient_id = t2.patient_id
group by gender, drink, smoke
order by gender, drink, smoke

SElECT gender,itch,bleed, COUNT(*) total_cases, sum(case when diagnostic in('SCC','MEL','BCC')
then 1 else 0 end) as cancer_cases, Round(100 * sum(case when diagnostic in('SCC','MEL','BCC')
then 1 else 0 end)/count(*),2) as percentage
FROM table1 t1 
join table2 t2
on t1.patient_id = t2.patient_id
group by gender, itch, bleed
order by gender, itch, bleed;



group by SElECT gender,drink, smoke, COUNT(*) total_cases, sum(case when diagnostic in('SCC','MEL','BCC')
then 1 else 0 end) as cancer_cases, Round(100 * sum(case when diagnostic in('SCC','MEL','BCC')
then 1 else 0 end)/count(*),2) as percentage
FROM table1 t1 
join table2 t2
on t1.patient_id = t2.patient_id
group by gender, drink, smoke
order by gender, drink, smoke
order by gender, drink, smoke














