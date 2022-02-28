DELIMITER //
CREATE OR REPLACE PROCEDURE procDeleteGrades (studentDni CHAR(9))
    BEGIN
        DECLARE id INT;
        SET id = (SELECT studentId FROM Students WHERE dni = studentDni);
        DELETE FROM Grades WHERE studentId = id;
    END //
DELIMITER ;

CALL procDeleteGrades('12345678A');

DELIMITER //
CREATE OR REPLACE PROCEDURE procDeleteData()
    BEGIN
        DELETE FROM Grades;
        DELETE FROM GroupsStudents;
        DELETE FROM Students;
        DELETE FROM Groups;
        DELETE FROM Subjects;
        DELETE FROM Degrees;
    END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE procTableCreation()
    BEGIN
        CREATE TABLE tbl (
            TableTestId  INT default NULL,
            TableName VARCHAR(30) default NULL);
    end //
DELIMITER ;

CALL procTableCreation() ;


-- populatee thee table  - wypełnianie tabeli

DELIMITER //
CREATE OR REPLACE PROCEDURE procPopulateTable()
    BEGIN
        DECLARE TableTestId ;

        INSERT INTO tbl (TableTestId, TableName)
        VALUES TableTestId = 1, TableName =  'testname';
    end //
DELIMITER ;
