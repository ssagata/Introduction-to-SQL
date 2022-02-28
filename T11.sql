use theorry;

-- insert a new department
DELIMITER //
CREATE OR REPLACE PROCEDURE
    procInsertNewDepartment( n VARCHAR(32), l VARCHAR(64))
    BEGIN
        INSERT INTO Departments (depName, city) VALUES (n, l) ;
    end //
DELIMITER ;

CALL procInsertNewDepartment('Economy', 'Boston') ;


-- Insert a new Employee
-- jako input przy nazwie procedury podajemy wartości odpowiadoające tej tabeli
-- do której bedzziemy sie odwolywac podajac nowe nazwy i typ
-- BEGIN i piszemy co ma być robione
-- najpierw decalrujamy parametr z typem
-- potem setujeemy - uzywajac czesto select
--
DELIMITER //
CREATE OR REPLACE PROCEDURE procInsertEmployee
    (depID INT, bID INT , eName VARCHAR(20), salarry DECIMAL,
    sDate DATE, eDaate DATE, com DOUBLE)
    BEGIN
        IF(sDate = NULL) THEN
            SET sDate = SYSDATE() ;
        end if ;
        INSERT INTO Employee (departmentId, bossId, empName, salary, startDate, endDate, commission)
        VALUES (depID, bID, eName, salarry, sDate, eDaate, com );
    end //
DELIMITER ;
CALL procInsertEmployee (1, NULL, 'Daniel', 500, NULL, '2020-09-15', 0.2);

-- make commision of every employee equal to the averaage commision

DELIMITER //
CREATE OR REPLACE PROCEDURE procComEqualAVGcom()
BEGIN
    DECLARE AveraageCommission DECIMAL;
    SET AveraageCommission = (SELECT AVG(commission) FROM Employee );
    UPDATE Employee SET commission = AveraageCommission;

end //
DELIMITER ;
CALL procComEqualAVGcom();

-- Raaise the commision of a particular employee

-- CO ROBI ROW TYPE !!!!!
/*
DELIMITER //
CREATE OR REPLACE PROCEDURE procRaiseCom
    (idOfEmployee VARCHAR(50), raise DECIMAL)
BEGIN
    DECLARE employee ROW TYPE OF Employee ;
    DECLARE newCommision DOUBLE;
    SELECT * INTO employee -- the result of the statement is stored
        FROM Employee
            WHERE employeeId = idOfEmployee;
    SET newCommision = employee.commision + raise; -- dzieki temu wczzessniejszemu selectowi możżemy ustawić employee.commision
    UPDATE Employee
            SET commission = newCommision;
            WHERE idofEmployee = id;
end //

 */

/*                                                              */
-- --------------------------------FUNCTIONS
/*                                                                 */

-- Reeturns the number of employeees from a particulaar city

DELIMITER //
CREATE OR REPLACE FUNCTION
    fNumEmplOfCity(nameOFCity VARCHAR(64)) RETURNS INT
BEGIN
    RETURN (
        SELECT  COUNT(*)
    FROM Employee E JOIN Departments D ON E.departmentId = D.departmentId
    WHERE D.city = nameOFCity);
end //
DELIMITER ;

SELECT fNumEmplOfCity('Sevilla');

-- wyswietlanie wszystkiego czzylio uzycie funkcji w zwykłym SELECT
/*
SELECT city,
       fNumEmplOfCity(city)
           FROM employeestats GROUP BY city;

 */

-- invoke a function inside a procedure
-- their result szhould be stored in a varieble

DELIMITER //
CREATE OR REPLACE FUNCTION
    fAAvgCommisiion() RETURNS DOUBLE
BEGIN
    RETURN (
        SELECT AVG(commission) FROM Employee
        );
end //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE
    procRaiseCommision()
BEGIN
    DECLARE avgC DOUBLE;
    SET avgC = fAAvgCommisiion();
    UPDATE Employee SET commission = avgC;
end //
DELIMITER ;


/*                                                              */
-- --------------------------------TIGGERS
/*                                                                 */

-- Check that an employee is not his her own boss
DELIMITER //
CREATE OR REPLACE TRIGGER
    tSelfBoss
BEFORE UPDATE ON Employee FOR EACH ROW
    BEGIN
        IF (new.employeeId = new.bossId) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'An employee connot be his own boss';
        end if ;
    end //
DELIMITER ;

UPDATE Employee SET bossId = 1 WHERE employeeId = 1;

-- COMPLEX BUSINESS RULES

-- EXAMPLE: check that the employees commissions cannot increase/decrease
-- by more thean 0.2 points at a time
-- OPTION 1
-- The change is not allowed
DELIMITER //
CREATE OR REPLACE TRIGGER tMaxChangeOfCom
    BEFORE UPDATE ON Employee FOR EACH ROW
    BEGIN
        IF ((NEW.commission - OLD.commission) > 0.2 ) OR
            ((new.commission - old.commission) < -0.2 )
            THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT  =
                'A commision change has to be less then 0.2 points ';
        end if;
    end //
DELIMITER ;

UPDATE Employee SET commission=0.9 WHERE employeeId = 11;

-- OPTION 2
-- The change is allowed but restricted to the maximum

DELIMITER  //
CREATE OR REPLACE TRIGGER tComChange2
    BEFORE UPDATE ON Employee FOR EACH ROW
    BEGIN
        IF ((new.commission - old.commission) > 0.2 )
            THEN
            SET NEW.commission = OLD.commission + 0.2;
        end if;
        IF ((new.commission - old.commission) < -0.2)
            THEN SET new.commission = OLD.commission - 0.2;
        end if;
    end //
DELIMITER ;

-- RN 003
-- Departments cannot have more than 5 employees
DELIMITER //
CREATE OR REPLACE TRIGGER tMaxEmployee
    BEFORE INSERT ON Employee FOR EACH ROW
    BEGIN
        DECLARE number INT ;
        SET number = (SELECT COUNT(*) FROM Employee
        WHERE departmentId = new.departmentId);
        IF ( number >= 4 ) THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT  = 'There caannpt be more then 5 employees'
            'in one department';
        end if;
    end //
DELIMITER  ;

-- WAZNE
-- TU JEST INSERT
-- BO uzywamy procedury insertt wiec musi byc before insert
-- TRZEBA TEZ DAWAC W PIZDU NAWIASOW PRYZ IFACH
CALL procInsertEmployee(1, NULL, 'newbiehalo', 500, NULL, '2020-09-15', 0.2);
CALL procInsertEmployee(1, NULL, 'new3', 500, NULL, '2020-09-15', 0.2);


-- IF an employtee doeasnt have an initial date, set it to the system date
DELIMITER //
CREATE OR REPLACE TRIGGER tDefaultDate
BEFORE INSERT ON Employee
    FOR EACH ROW
    BEGIN
        IF (new.startDate IS NULL) THEN
        SET new.startDate = SYSDATE();
    end if;
END //
DELIMITER ;

INSERT INTO Employee
VALUES (NULL, 2, NULL, 'Gabriela', 1000, NULL, '2022-02-02', 0.4);

/*                                                              */
-- --------------------------------COURSORS
/*                                                                 */

-- Retrieves the sum of every salary without using SELECT SUM()

/*
DELIMITER //
CREATE OR REPLACE FUNCTION sumSalaries() RETURNS DECIMAL
BEGIN
    DECLARE suma DECIMAL;
    DECLARE employee ROW TYPE OF Employee;

    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE curEmployeees CURSOR FOR SELECT * FROM Employee;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

    SET suma = 0;
    OPEN curEmployeees;
    readLoop:LOOP
        FETCH curEmployeees INTO employee;
        IF done then
            LEAVE  readLoop;
        end if ;
        SET suma = suma + employee.salary;
    end loop;
    CLOSE curEmployeees;

    RETURN suma;
end //
DELIMITER ;

SELECT sumSalaries() FROM dual;

 */
