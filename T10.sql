DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Departments;
-- jak to

-- DAta Definition Language DDL
-- CREATE, ALTER DROP
-- KEYS
-- BUSINESS RULES - CONSTRAAINTS, UNIQUE , CHECK
CREATE TABLE Departments
(
    departmentId INT          NOT NULL AUTO_INCREMENT,
    depName      VARCHAR(100) ,
    city         VARCHAR(200) ,
    PRIMARY KEY (departmentId),
    UNIQUE (depName, city)
);
-- we use UNIQUE every time is AK
CREATE TABLE Employee(
    employeeId INT NOT NULL AUTO_INCREMENT,
    departmentId INT,
    bossId INT ,
    empName VARCHAR(100) NOT NULL UNIQUE ,
    salary DECIMAL(6,2) DEFAULT 2000.00,
    startDate DATE  ,
    endDate DATE ,
    commission DOUBLE ,
    PRIMARY KEY (employeeId),
    FOREIGN KEY (departmentId) REFERENCES Departments(departmentId) ON DELETE CASCADE ,
    FOREIGN KEY (bossId) REFERENCES Employee(employeeId) ON DELETE CASCADE ,
    CONSTRAINT Check_Dates CHECK ( startDate < Employee.endDate ),
    CHECK ( commission BETWEEN 0 and 1)
);

-- DML Data Modification Languafe
-- INSERT INTO
INSERT INTO Departments(depName, city) VALUES ('History', NULL);
INSERT INTO Departments(depName, city) VALUES ('Computers', 'Sevilla');
INSERT INTO Departments(depName, city) VALUES ('Arts', 'Cadiz');

/*DUplicated Values */
# to nie ma bledu
INSERT INTO Departments (depName, city) VALUES ('History', NULL);
-- to ma, bo jest zduplikowane i depName i city
-- INSERT INTO Departments(depName, city) VALUES ('Computers', 'Sevilla');

/* Inserts into employees */

INSERT INTO Employee(departmentId, bossId, empName, salary, startDate, endDate, commission)
VALUES (1, NULL, 'Pedro', 2300.00, '2017-09-15', NULL, 0.2);
/* José at History*/
INSERT INTO Employee(departmentId, bossId, empName, salary, startDate, endDate, commission)
VALUES (1, NULL, 'José', 2500.00, '2018-08-15', NULL, 0.5);
/* Lola at Computers */
INSERT INTO Employee(departmentId, bossId, empName, salary, startDate, endDate, commission)
VALUES (2, NULL, 'Lola', 2300.00, '2018-08-15', NULL, 0.3);
/* Luis worked for Pedro for 3 months */
INSERT INTO Employee(departmentId, bossId, empName, salary, startDate, endDate, commission)
VALUES (1, 1, 'Luis', 1300.00, '2018-08-15', '2018-11-15', 0);

INSERT INTO Employee(departmentId, bossId, empName, salary, startDate, endDate, commission)
VALUES (1, 1, 'Ana', 1300.00, '2018-08-15', '2018-11-15', 0);

/*MISTAKES */
-- Mamy aktualnie 4 rozne departments wiec przyps żeby uzyc piątego
/*
INSERT INTO Employee(departmentId, bossId, empName, salary, startDate, endDate, commission)
VALUES (5, null, 'Manuel', 2300.00, '2017-08-15', NULL, 0.6)
*/

-- UPDATE

UPDATE Employee SET salary = '2500.00' WHERE employeeId = 1;
UPDATE Employee SET endDate = '2019-08-15' WHERE employeeId = 2;

UPDATE Departments SET depName = 'History' WHERE departmentId = 1;

UPDATE Departments SET city = 'Cadiz' WHERE departmentId = 4;
-- UPDATE Departments SET city = 'Sevilla' WHERE departmentId = 4;


-- DELETE
-- DELETE FROM Departments WHERE departmentId = 1;

/* ON DELETE SET NULL */

-- Mamy ustawione na
-- FOREIGN KEY (departmentId) REFERENCES Departments(departmentId) ON DELETE SET NULL ,
-- bez tego nie da sie usunąc
-- teraz usunelo z Departments department 1
-- ale w employy ustawilo nulle tam gdzie byla 1

/* ON DELETE CASCADE */
-- USUWA WSZYSTKO
-- musi być ON DELETE ustawione dla wszystkiego co będzie
-- dotyczyć

-- co robi cascade i czemu nie da sie usunac gdzie jest history = NULL
-- MUSI być ustawione ON DELETE CASCADE dla
-- dla FK(departmentId) i (bossId)


--
-- Data Query Language
-- SELECT
--

-- SELECT

-- kolumny empName, salary , gdy salary <2000 - wszystko z jednej table
SELECT empName, salary FROM Employee WHERE salary <2000;
-- wyswietla wszystkie kolumny z danej table
SELECT * FROM Employee WHERE salary  <2000;


-- SELECT ALL & DISTINCT
-- distinct nie  daje powtorek
SELECT ALL startDate,endDate FROM Employee;
SELECT DISTINCT startDate, endDate FROM Employee;

-- Between

SELECT DISTINCT empName,  salary FROM Employee WHERE salary >= 2000 AND salary <= 3000;

SELECT DISTINCT empName, salary FROM Employee WHERE salary BETWEEN 2000 AND 3000;

-- SELECT IN
SELECT DISTINCT empName, salary FROM Employee WHERE salary IN (1000,2300, 3000);

-- SELECT LIKE
-- '_o' - konczy sie na o
-- % - represents 0 or more character
-- _ - represents single character
-- [ab] a or b
-- [^ab] not a i not b
-- [a-b] range from a to b
-- # any single nr
-- a%, %a %or% '_r%' (ssecond posoition) 'a___%' - has at least 3 charakters after a
SELECT * FROM Employee WHERE empName LIKE '_o%' OR bossId IS NULL;

-- SELECT ORDER BY
SELECT * FROM Employee ORDER BY departmentId, empName;

-- SELECT (cartensian product)
-- every possible combintaation of involved relations

SELECT * FROM Employee, Departments;

-- SELECT (NATURAL JOIN )
--  jaakby  czesc wspolna

SELECT empName, salary, startDate, depName FROM Employee E, Departments D
WHERE E.departmentId  = D.departmentId;

SELECT empName, salary, startDate, depName FROM Employee NATURAL JOIN Departments;

UPDATE Employee SET departmentId= NULL WHERE employeeId= 5;
SELECT empName, salary, startDate, depName
FROM Employee E RIGHT JOIN Departments D ON E.departmentId = D.departmentId;


-- SELECT UNION - łączy
SELECT * From Employee E LEFT JOIN Departments D ON E.departmentId = D.departmentId
UNION
SELECT * FROM Employee E RIGHT JOIN Departments D on D.departmentId = E.departmentId ;

-- SELECT WHERE NOT EXST

SELECT * FROM Departments D WHERE NOT EXISTS(
    SELECT * FROM Employee E
    WHERE D.departmentId = E.departmentId
);

SELECT * FROM Departments D WHERE EXISTS(
    SELECT * FROM Employee E
    WHERE D.departmentId = E.departmentId
);

-- COMPLEX QUIERIES

-- COUNT
-- number of rowes or values specidien

SELECT COUNT(*), MIN(salary), MAX(salary), AVG(salary), SUM(salary) FROM Employee;

-- GROUP BY

SELECT departmentId, COUNT (*) , AVG(salary) salaryMedio,
       AVG(salary * (1+commission)) salaryConcomision,
       SUM(salary) sumasalary
FROM Employee
GROUP BY departmentId;

-- HAVING

SELECT departmentId, COUNT(*),
AVG(salary) salaryMedio, AVG(salary * (1+commission)) salaryConcommission, SUM(salary) gastosalarys
FROM Employee
GROUP BY departmentId HAVING COUNT(*)>1;


-- ALL ANY
SELECT departmentId FROM Employee
GROUP BY departmentId HAVING COUNT(*)>= ALL
( SELECT COUNT(*)
FROM Employee
GROUP BY departmentId );
/* Option 2 */
SELECT departmentId FROM Employee GROUP BY departmentId HAVING COUNT(*) =
( SELECT MAX(total) FROM
( SELECT COUNT(*) AS total
FROM Employee
GROUP BY departmentId ) NumEmployees );


-- VIEWS

CREATE OR REPLACE VIEW EmployeeStats AS
    SELECT departmentId,
           COUNT(*) AS numEmployess,
           AVG(salary) salaryMedio,
           AVG(salary * (1+ commission)) salaryConCommission,
           SUM(salary) suma
FROM Employee
GROUP BY departmentId;

SELECT MAX(numEmployess) FROM EmployeeStats;




