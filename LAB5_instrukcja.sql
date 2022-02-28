-- avaraage grade for each subject

CREATE OR REPLACE  VIEW ViewSubjectGrades AS
    SELECT Grades.value value, `Groups`.name NameOfGroup , Subjects.name  NameOfSub, Subjects.credits Credits, Grades.studentId StudentID, `Groups`.year Year, Grades.gradeCall GradeCall
    FROM Grades
    JOIN `Groups` ON Grades.groupId = `Groups`.groupId
    JOIN Subjects ON `Groups`.subjectId = Subjects.subjectId;

SELECT * FROM ViewSubjectGrades;

SELECT AVG(value ), NameOfSub  FROM ViewSubjectGrades
    GROUP BY NameOfSub;


-- nr of students born in each year
SELECT year(birthDate), COUNT(*)
    FROM Students
    GROUP BY year(birthDate);

-- nr of students per degree in the 2019 academic year

CREATE OR REPLACE VIEW ViewDegreeStudents AS
    SELECT Students.*, Degrees.*, `Groups`.year
    FROM Students
    JOIN GroupsStudents GS on Students.studentId = GS.studentId
    JOIN `Groups` ON GS.groupId = `Groups`.groupId
    JOIN Subjects on Subjects.subjectId = `Groups`.subjectId
    JOIN Degrees ON Subjects.degreeId = Degrees.degreeId;

SELECT ViewDegreeStudents.name, COUNT(DISTINCT surname)
    FROM ViewDegreeStudents
    WHERE year = 2019
    GROUP BY name;

-- maximum mark of each student, with the name and surname
SELECT MAX(value), firstName, surname
    FROM Grades, Students
    WHERE Grades.studentId = Students.studentId
    GROUP BY firstName, surname;


-- name and number of theory groups of the 3 subjects with the highest
-- number of theory groups in 2019

CREATE OR REPLACE VIEW ViewGroupsSubjects AS
    SELECT `Groups`.name  GroupName, `Groups`.activity Activity, Subjects.name SubName
    FROM `Groups`
    JOIN Subjects ON `Groups`.subjectId = Subjects.subjectId;

SELECT SubName, COUNT(Activity = 'Teoria') Liczba
    FROM ViewGroupsSubjects
    WHERE Activity = 'Teoria'
    GROUP BY SubName
    ORDER BY Liczba DESC
    LIMIT 3 ;


-- name and surname of students per yeaar who had an average grade higher
-- then the avarage grade for the year


CREATE OR REPLACE VIEW ViewGradesYear AS
    SELECT firstName, surname, Groups.year, Grades.value
    FROM viewstudentsgrades
    JOIN Grades ON Grades.value = viewstudentsgrades.value
    JOIN `Groups` ON `Groups`.groupId = Grades.groupId;


CREATE OR REPLACE VIEW ViewYearAveerage AS
    SELECT year Y, AVG(value) YearAveragee
    FROM ViewGradesYear
    GROUP BY year;


SELECT firstName, surname , year  , AVG(value) AS studentAverage, YearAveragee
    FROM ViewGradesYear
    JOIN ViewYearAveerage ON ViewYearAveerage.Y = ViewGradesYear.year
    GROUP BY firstName, surname
    HAVING (studentAverage > (SELECT YearAveragee FROM ViewYearAveerage
        WHERE ViewYearAveerage.Y = ViewGradesYear.year));

-- name of subjects that belong to a degree with more then 4 subjects

CREATE OR REPLACE VIEW ViewSubjectDegree AS
    SELECT  Degrees.name NameOfDegree, Degrees.degreeId,  COUNT(*) AS nrOfSub
    FROM Subjects
    JOIN Degrees ON Degrees.degreeId = Subjects.degreeId
    GROUP BY Degrees.name;

SELECT Subjects.name, ViewSubjectDegree.nrOfSub
    FROM Subjects, ViewSubjectDegree
    WHERE ViewSubjectDegree.degreeId  = Subjects.degreeId AND ViewSubjectDegree.nrOfSub > 4;