 -- 1 Show all columns and rows in the table
 
 
SELECT * FROM salaries;  


-- 2 Show only EmployeeName and JobTitle columns


SELECT Employeename,jobtitle  FROM salaries;


-- 3 Show the number of Employees in the table 


--Method 1 :
SELECT COUNT(EmployeeName) FROM salaries;


--Method 2 :
SELECT COUNT(*) FROM salaries;


-- 4 Show the unique job titles in the table


SELECT DISTINCT JobTitle FROM salaries;
SELECT COUNT(DISTINCT JobTitle) FROM salaries;


-- 5 Show the job title and overtime pay for all employees with overtime
--pay greater than 1000


SELECT JobTitle, overtimepay FROM salaries
WHERE overtimepay > 1000;


-- 6 Show the average base pay for all employees


SELECT AVG(BasePay) AS "AVG_BasePay" FROM salaries;


-- 7 Show the top 10 highest paid employees


SELECT EmployeeName, TotalPay 
FROM salaries
ORDER BY TotalPay DESC
FETCH FIRST 10 ROWS ONLY;


-- 8 Show the average of BasePay, OvertimePay, and OtherPay for each employee


SELECT  EmployeeName, (BasePay + OvertimePay + OtherPay)/3 AS "AVG_of_bp_op_otherpay"
FROM salaries;


-- 9 Show all employees who have the word "Manager" in their job title


SELECT EmployeeName, JobTitle 
FROM salaries
WHERE LOWER(JobTitle) LIKE '%manager%';


-- 10 Show all employees with a job title not equal to 'Manager'


SELECT EmployeeName, JobTitle
FROM salaries
WHERE LOWER(JobTitle) <> 'manager';


-- 11 Show all employees with a total pay between 50,000 and 75,000


SELECT EmployeeName, TotalPay 
FROM salaries
WHERE TotalPay BETWEEN 50000 AND 75000;


/* 12 Show all employee with a base pay less than 50000
or a total pay greater than 100000*/


SELECT EmployeeName, BasePay, TotalPay
FROM salaries
WHERE (BasePay < 50000) OR (TotalPay > 100000);


/* 13 Show all employees with a total pay benefits value between 125,000
and 150,000 and a job title containing the word "Director"*/


SELECT EmployeeName, TotalPayBenefits, JobTitle
FROM salaries
WHERE (TotalPayBenefits BETWEEN 125000 AND 150000)
    AND (UPPER(JobTitle) LIKE '%DIRECTOR%');
    

-- 14 Show all employees ordered by their total pay benefits in ascending order 


SELECT EmployeeName, TotalPayBenefits
FROM salaries
ORDER BY TotalPayBenefits ASC;


/* 15 Show all job titles with an average BasePay of at least 100,000,
and order them by the average BasePay in descending order */


SELECT JobTitle, AVG(BasePay) AS AVG_BasePay
FROM salaries
GROUP BY JobTitle
HAVING AVG(BasePay) >= 100000
ORDER BY AVG_BasePay DESC;


-- 16 DELETE THE COLUMN 


SELECT Notes FROM salaries;

ALTER TABLE salaries
DROP COLUMN Notes;

SELECT * FROM salaries;


/* 17 Update the BasePay of all employees with the Job title
containing 'Manager' by increasing it by by 10% */


UPDATE salaries
SET BasePay = BasePay * 1.1
WHERE LOWER(JobTitle) LIKE '%manager%';

SELECT * from salaries;


-- 18 Delete all employees who have no OvertimePay

SELECT COUNT(*) FROM salaries
WHERE OvertimePay = 0

DELETE FROM salaries
WHERE OvertimePay =0;


COMMIT;