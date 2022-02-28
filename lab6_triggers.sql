-- TRIGGERS

DELIMITER //
CREATE OR REPLACE TRIGGER triggerWithHonours
    BEFORE INSERT ON Grades
    FOR EACH ROW
    BEGIN
        IF (new.withHonours = 1 AND new.value <9.0 ) THEN
            SIGNAL SQLSTATE '45000' SET message_text  =
                'you cannot insert a grade with honours whose value is less then 9';
        end if;
    end //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER triggerGradeStudentGroup
    BEFORE INSERT ON Grades
    FOR EACH ROW
    BEGIN
        DECLARE isInGroup INT;
        SET isInGroup = (SELECT COUNT(*)
            FROM GroupsStudents WHERE studentId = new.studentId
            AND groupId = NEW.groupId);
        IF (isInGroup < 1  ) THEN
            SIGNAL SQLSTATE '45000' SET message_text  =
                'A student cannt have grades for groups in which they are not registered';
        end if;
    end //
DELIMITER ;

/*
DELIMITER //
CREATE OR REPLACE TRIGGER triggerGradesChangeDifference
    BEFORE UPDATE ON Grades
    FOR EACH ROW
    BEGIN
        DECLARE difference DECIMAL(4,2) ;
        DECLARE student ROW TYPE OF Students ;
        SET difference = new.value - OLD.value;

        IF (difference > 4  ) THEN
            SELECT * INTO student FROM Students WHERE studentId = new.studentId;
            SET @error_message = CONCAT('Y cant add', difference,
                'points to a grade for the student', student.firstName, ' ', student.surname);
            SIGNAL SQLSTATE '45000' SET message_text  = @error_message;
        end if;
    end //
DELIMITER ;

 */



