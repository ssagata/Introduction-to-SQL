-- FUNCTIONS
DELIMITER //
CREATE OR REPLACE FUNCTION avgGrade(studentId INT) RETURNS DOUBLE
    BEGIN
        DECLARE avgStudentGrade DOUBLE;
        SET avgStudentGrade  = (SELECT AVG(value) FROM Grades
                                WHERE Grades.studentId = studentId);
        RETURN  avgStudentGrade;
    END //
DELIMITER ;

SELECT avgGrade(2);
SELECT firstName, surname, avgGrade(studentId) from Students;
