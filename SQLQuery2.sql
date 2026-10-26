-- Clean up existing tables (start with children, move to parents)

IF OBJECT_ID('dbo.EMPLOYEE', 'U') IS NOT NULL
    DROP TABLE dbo.EMPLOYEE;

IF OBJECT_ID('dbo.DEPARTMENT', 'U') IS NOT NULL
    DROP TABLE dbo.DEPARTMENT;

-- If you have a JOB table (not visible but implied in the first query), drop it here:
-- IF OBJECT_ID('dbo.JOB', 'U') IS NOT NULL
--     DROP TABLE dbo.JOB;

IF OBJECT_ID('dbo.LOCATION', 'U') IS NOT NULL
    DROP TABLE dbo.LOCATION;
GO
CREATE TABLE LOCATION (
    Location_ID INT PRIMARY KEY,
    City VARCHAR(50)
);

INSERT INTO LOCATION VALUES
(122, 'New York'),
(123, 'Dallas'),
(124, 'Chicago'),
(167, 'Boston');

CREATE TABLE DEPARTMENT (
    Department_Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Location_Id INT REFERENCES LOCATION(Location_ID)
);

INSERT INTO DEPARTMENT VALUES
(10, 'Accounting', 122),
(20, 'Sales', 124),
(30, 'Research', 123),
(40, 'Operations', 167);
-- Add this block before CREATE TABLE JOB
IF OBJECT_ID(N'dbo.JOB', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.JOB;
END
GO

-- Now the CREATE TABLE will succeed
CREATE TABLE JOB (
    JOB_ID INT PRIMARY KEY,
    DESIGNATION VARCHAR(30)
);


INSERT INTO JOB VALUES
(667, 'Clerk'),
(668, 'Staff'),
(669, 'Analyst'),
(670, 'Sales Person'),
(671, 'Manager'),
(672, 'President');

CREATE TABLE EMPLOYEE (
    Employee_Id INT PRIMARY KEY,
    Last_Name VARCHAR(50),
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Job_Id INT REFERENCES JOB(Job_ID),
    Hire_Date DATE,
    Salary DECIMAL(10,2),
    Comm DECIMAL(10,2),
    Department_Id INT REFERENCES DEPARTMENT(Department_Id)
);

INSERT INTO EMPLOYEE VALUES
(7369, 'Smith', 'John', 'Q', 667, '1984-12-17', 800, NULL, 20),
(7499, 'Allen', 'Kevin', 'J', 670, '1985-02-20', 1600, 300, 30),
(7550, 'Doyle', 'Jean', 'K', 671, '1985-04-04', 2850, NULL, 30),
(7560, 'Dennis', 'Lynn', 'S', 671, '1985-05-15', 2750, NULL, 30),
(7570, 'Baker', 'Leslie', 'D', 671, '1985-06-10', 2200, NULL, 40),
(7521, 'Wark', 'Cynthia', 'D', 670, '1985-02-22', 1250, 50, 30);
-- 1
SELECT * FROM EMPLOYEE;

-- 2
SELECT * FROM DEPARTMENT;

-- 3
SELECT * FROM JOB;

-- 4
SELECT * FROM LOCATION;

-- 5
SELECT First_Name, Last_Name, Salary, Comm FROM EMPLOYEE;

-- 6
SELECT Employee_Id AS "ID of the Employee",
       Last_Name AS "Name of the Employee",
       Department_Id AS "Dep_id"
FROM EMPLOYEE;

-- 7
SELECT First_Name, Last_Name, (Salary * 12) AS Annual_Salary
FROM EMPLOYEE;
-- 1
SELECT * FROM EMPLOYEE WHERE Last_Name = 'Smith';

-- 2
SELECT * FROM EMPLOYEE WHERE Department_Id = 20;

-- 3
SELECT * FROM EMPLOYEE WHERE Salary BETWEEN 2000 AND 3000;

-- 4
SELECT * FROM EMPLOYEE WHERE Department_Id IN (10,20);

-- 5
SELECT * FROM EMPLOYEE WHERE Department_Id NOT IN (10,30);

-- 6
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'L%';

-- 7
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'L%E';

-- 8
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'J___';

-- 9
SELECT * FROM EMPLOYEE
WHERE Department_Id = 30 AND Salary > 2500;

--10
SELECT * FROM EMPLOYEE WHERE Comm IS NULL;
-- 1
SELECT Employee_Id, Last_Name FROM EMPLOYEE ORDER BY Employee_Id ASC;

-- 2
SELECT Employee_Id, First_Name, Salary
FROM EMPLOYEE ORDER BY Salary DESC;

-- 3
SELECT * FROM EMPLOYEE ORDER BY Last_Name ASC;

-- 4
SELECT * FROM EMPLOYEE ORDER BY Last_Name ASC, Department_Id DESC;
-- 1
SELECT Department_Id,
       MAX(Salary) AS Max_Salary,
       MIN(Salary) AS Min_Salary,
       AVG(Salary) AS Avg_Salary
FROM EMPLOYEE
GROUP BY Department_Id;

-- 2
SELECT Job_Id,
       MAX(Salary), MIN(Salary), AVG(Salary)
FROM EMPLOYEE
GROUP BY Job_Id;

-- 3
SELECT MONTH(Hire_Date) AS Month, COUNT(*) AS Count_Employees
FROM EMPLOYEE
GROUP BY MONTH(Hire_Date)
ORDER BY Month;

-- 4
SELECT YEAR(Hire_Date), MONTH(Hire_Date), COUNT(*)
FROM EMPLOYEE
GROUP BY YEAR(Hire_Date), MONTH(Hire_Date)
ORDER BY YEAR(Hire_Date), MONTH(Hire_Date);

-- 5
SELECT Department_Id, COUNT(*)
FROM EMPLOYEE
GROUP BY Department_Id
HAVING COUNT(*) >= 4;

-- 6
SELECT COUNT(*) FROM EMPLOYEE WHERE MONTH(Hire_Date) = 2;

-- 7
SELECT COUNT(*)
FROM EMPLOYEE
WHERE MONTH(Hire_Date) IN (5,6);

-- 8
SELECT COUNT(*) FROM EMPLOYEE WHERE YEAR(Hire_Date) = 1985;

-- 9
SELECT MONTH(Hire_Date), COUNT(*)
FROM EMPLOYEE
WHERE YEAR(Hire_Date) = 1985
GROUP BY MONTH(Hire_Date);

--10
SELECT COUNT(*)
FROM EMPLOYEE
WHERE Hire_Date = '1985-04-04';

--11
SELECT Department_Id
FROM EMPLOYEE
WHERE Hire_Date = '1985-04-04'
GROUP BY Department_Id
HAVING COUNT(*) >= 3;
-- 1
SELECT E.First_Name, E.Last_Name, D.Name AS Department
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id;

-- 2
SELECT E.First_Name, E.Last_Name, J.Designation
FROM EMPLOYEE E
JOIN JOB J ON E.Job_Id = J.Job_ID;

-- 3
SELECT E.First_Name, E.Last_Name, D.Name AS Department, L.City
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id
JOIN LOCATION L ON D.Location_Id = L.Location_ID;

-- 4
SELECT D.Name, COUNT(*) AS Employees_Count
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id
GROUP BY D.Name;

-- 5
SELECT COUNT(*)
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id
WHERE D.Name = 'Sales';

-- 6
SELECT D.Name
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id
GROUP BY D.Name
HAVING COUNT(*) >= 3
ORDER BY D.Name ASC;

-- 7
SELECT COUNT(*)
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id
JOIN LOCATION L ON D.Location_Id = L.Location_ID
WHERE L.City = 'Dallas';

-- 8
SELECT E.*
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Department_Id = D.Department_Id
WHERE D.Name IN ('Sales','Operations');
-- 1
SELECT *,
CASE
    WHEN Salary >= 3000 THEN 'A'
    WHEN Salary >= 2000 THEN 'B'
    WHEN Salary >= 1000 THEN 'C'
    ELSE 'D'
END AS Grade
FROM EMPLOYEE;

-- 2
SELECT
CASE
    WHEN Salary >= 3000 THEN 'A'
    WHEN Salary >= 2000 THEN 'B'
    WHEN Salary >= 1000 THEN 'C'
    ELSE 'D'
END AS Grade,
COUNT(*)
FROM EMPLOYEE
GROUP BY
CASE
    WHEN Salary >= 3000 THEN 'A'
    WHEN Salary >= 2000 THEN 'B'
    WHEN Salary >= 1000 THEN 'C'
    ELSE 'D'
END;

-- 3
SELECT
CASE
    WHEN Salary BETWEEN 2000 AND 5000 THEN '2000-5000'
END AS GradeRange,
COUNT(*)
FROM EMPLOYEE
WHERE Salary BETWEEN 2000 AND 5000
GROUP BY
CASE
    WHEN Salary BETWEEN 2000 AND 5000 THEN '2000-5000'
END;
-- 1
SELECT * FROM EMPLOYEE
WHERE Salary = (SELECT MAX(Salary) FROM EMPLOYEE);

-- 2
SELECT * FROM EMPLOYEE
WHERE Department_Id = (SELECT Department_Id FROM DEPARTMENT WHERE Name = 'Sales');

-- 3
SELECT * FROM EMPLOYEE
WHERE Job_Id = (SELECT Job_ID FROM JOB WHERE Designation = 'Clerk');

-- 4
SELECT *
FROM EMPLOYEE
WHERE Department_Id IN (
    SELECT Department_Id FROM DEPARTMENT
    WHERE Location_Id = (SELECT Location_Id FROM LOCATION WHERE City = 'Boston')
);

-- 5
SELECT COUNT(*) FROM EMPLOYEE
WHERE Department_Id IN (SELECT Department_Id FROM DEPARTMENT WHERE Name = 'Sales');

-- 6
UPDATE EMPLOYEE
SET Salary = Salary * 1.10
WHERE Job_Id = (SELECT Job_ID FROM JOB WHERE Designation = 'Clerk');

-- 7
SELECT * FROM EMPLOYEE E
WHERE 1 = (
    SELECT COUNT(*) FROM EMPLOYEE
    WHERE Salary > E.Salary
);

-- 8
SELECT *
FROM EMPLOYEE
WHERE Salary > ALL (SELECT Salary FROM EMPLOYEE WHERE Department_Id = 30);

-- 9
SELECT Name FROM DEPARTMENT
WHERE Department_Id NOT IN (SELECT Department_Id FROM EMPLOYEE);

--10
SELECT *
FROM EMPLOYEE E
WHERE Salary > (
    SELECT AVG(Salary) FROM EMPLOYEE A WHERE A.Department_Id = E.Department_Id
);
