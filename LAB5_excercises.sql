

-- EXCERCISES

-- Number of failures of each student, given the name and surname

 CREATE OR REPLACE VIEW ViewStudentsGrades AS
     SELECT firstName, surname, value FROm Students S, Grades G
     WHERE G.studentId = S.studentId ;

SELECT firstName, surname, COUNT(*)
    FROM ViewStudentsGrades
    WHERE value <5
    GROUP BY firstName, surname
    ORDER BY COUNT(*);


-- The third page (each page contains 3 groups)
-- sorted by yeaar in descending order
SELECT *
    FROM `Groups`
    ORDER BY year DESC, groupId DESC
    LIMIT 3 OFFSET 6;


-- A list of the groups, adding the acronym
-- of the related subject and the name of the related degree.
-- nazwa grupy, acronym of related  subject, naame of relaated degree

SELECT `Groups`.name, Subjects.acronym, Degrees.name
    FROM `Groups`, Subjects, Degrees
    WHERE Degrees.degreeId = Subjects.degreeId AND Subjects.subjectId = `Groups`.subjectId
    GROUP BY `Groups`.name, Subjects.acronym, Degrees.name;


-- Number of different access methods of the students in each group, given the group id.

CREATE OR REPLACE VIEW ViewStudentsGroup AS
    SELECT `Groups`.groupId , GroupsStudents.studentId , Students.accessMethod accesses
    FROM `Groups`
    JOIN GroupsStudents ON `Groups`.groupId = GroupsStudents.groupId
    JOIN Students ON Students.studentId = GroupsStudents.studentId;

SELECT groupId, COUNT(DISTINCT accesses) AS accesses
    FROM ViewStudentsGroup
    GROUP BY groupId;


-- Grade weighted by credits of each student, giving name and surname, of the 2019
-- course in the first call. Hint: Modify the ViewSubjectGrades view by adding the
-- missing attribute. The weighted grade is equal to the sum of each grade multiplied by
-- the credits of its subject, divided by the sum of all the credits of the subjects.

-- grade call  = 1 -> w Grades
-- year = 2019 -> Groups
-- SELECT name, surname -> Student
-- +  SELECT  Grade -> Grade = SUM(Grades.value * credits of its subject)/

/*
CREATE OR REPLACE VIEW ViewGradeWeighted AS
    SELECT viewsubjectgrades.StudentID, ((SUM(value * Credits)  ) / SUM(credits)) srednia
    FROM viewsubjectgrades
    JOIN Students ON Students.studentId = viewsubjectgrades.StudentID
    JOIN Subjects ON Subjects.credits = viewsubjectgrades.Credits
    GROUP BY StudentID;

CREATE OR REPLACE VIEW ViewStudentSubject AS
    SELECT studentId , subjectId , credits
    FROM Students
    JOIN Subjects ON Subjects.

SELECT ViewGradeWeighted.srednia, firstName, surname
    FROM ViewGradeWeighted, Students, viewsubjectgrades
    WHERE Year = 2019 AND GradeCall = 1
    GROUP BY firstName;

 */

CREATE OR REPLACE VIEW ViewStudentSubjectGrade AS
    SELECT firstName IMIE, surname NAZWISKO , Subjects.subjectId PRZEDMIOT , Subjects.credits WAGA,
           value OCENA, `Groups`.year ROK , gradeCall SEMESTR
    FROM Students
    JOIN Grades G on Students.studentId = G.studentId
    JOIN `Groups` ON `Groups`.groupId = G.groupId
    JOIN Subjects ON Subjects.subjectId = `Groups`.subjectId ;

CREATE OR REPLACE VIEW ViewAvgGrade AS
    SELECT ViewStudentSubjectGrade.NAZWISKO NAME, SUM(ViewStudentSubjectGrade.OCENA * ViewStudentSubjectGrade.WAGA)/ SUM(ViewStudentSubjectGrade.WAGA) srednia
    FROM ViewStudentSubjectGrade
    GROUP BY NAZWISKO;

SELECT IMIE, NAZWISKO, srednia
    FROM ViewAvgGrade
    JOIN ViewStudentSubjectGrade ON ViewStudentSubjectGrade.NAZWISKO = ViewAvgGrade.NAME
    WHERE ViewStudentSubjectGrade.ROK = 2019 AND ViewStudentSubjectGrade.SEMESTR = 1;
