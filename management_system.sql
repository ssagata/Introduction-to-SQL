DROP IF EXISTS Groups;
DROP IF EXISTS Grades;
DROP IF EXISTS Subjects;
DROP IF EXISTS Appointments;
DROP IF EXISTS TeachingLoads;
DROP IF EXISTS TutoringsHours;
-- DROP IF EXISTS Persons;
DROP IF EXISTS Students;
DROP IF EXISTS Proffesors;
DROP IF EXISTS Departments;
DROP IF EXISTS Places;
DROP IF EXISTS Classrooms;
DROP IF EXISTS Offices;
DROP IF EXISTS Degrees;

CREATE TABLE Degrees(
    degreeId INT NOT NULL AUTO_INCREMENT,
    nameDegree VARCHAR(60) NOT NULL UNIQUE,
    duration INT NOT NULL
    PRIMARY KEY (degreeId)
);

CREATE TABLE Offices(
    officeId INT NOT NULL AUTO_INCREMENT,
    -- nameOffice VARCHAR(60) NOT NULL UNIQUE,
    -- floorOffice INT NOT  NULL, 
    -- capacity INT NOT NULL, 
    PRIMARY KEY (officeId), 
    CONSTRAINT invalidFloorOfOffice CHECK (floorOffice >= 0 AND <= 20)
);

CREATE TABLE Classrooms(
    classroomId INT NOT NULL AUTO_INCREMENT,
    hasProjector BOOLEAN, 
    hasLoundspeakers BOOLEAN,
    PRIMARY KEY (classroomId)
);

CREATE TABLE Places(
    --relacja 
    name VARCHAR(60) NOT NULL UNIQUE,
    floor INT NOT  NULL, 
    capacity INT NOT NULL, 
);

CREATE TABLE Departments(
    departmentId INT NOT NULL AUTO_INCREMENT, 
    nameDepartment VARCHAR(60) NOT NULL UNIQUE,
    PRIMARY KEY(departmentId)
);

CREATE TABLE Students(
    studentId INT NOT NULL AUTO_INCREMENT,
    accessMethod VARCHAR(30) NOT NULL,
    PRIMARY KEY (studentId)
    -- CONSTRAINT invalidStudentAccessMethod CHECK (accessMethod IN ('Selectividad'))

);

CREATE TABLE Proffesors(
    proffesorId INT NOT NULL AUTO_INCREMENT,
    category VARCHAR(20),
    PRIMARY KEY (proffesorId),
    officeId INT NOT NULL AUTO_INCREMENT,
    departmentId INT NOT NULL AUTO_INCREMENT, 
    FOREIGN KEY (officeId) REFERENCES Offices,
    FOREIGN KEY(departmentId) REFERENCES Departments
-- CONSTRAINS invalidCategory CHECK (category IN ('kategoria1', 'kategoria2'))
);

CREATE TABLE Persons(
    --relaacja;
    dni CHAR(9) NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    birthDate DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
 );

 CREATE TABLE TutoringsHours(
     tutoringHoursId INT NOT NULL, 
     dayOfweek VARCHAR(20) NOT NULL,
     startHour INT, 
     endHour INT, 
     PRIMARY KEY(tutoringHoursId),
     proffesorId INT NOT NULL AUTO_INCREMENT,
     FOREIGN KEY (proffesorId) REFERENCES Proffesors,
     CONSTRAINT invalidDayOfWeek CHECK (dayOfweek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))
     CONSTRAINT invalidHour CHECK (startHour, endHour >= 0 AND startHour, endHour <= 24)
 );

 CREATE TABLE TeachingLoads(
     teachingLoadsId INT NOT NULL  AUTO_INCREMENT, 
     creditsTeachingLoads INT NOT NULL, 
     proffesorId INT NOT NULL AUTO_INCREMENT,
     FOREIGN KEY (proffesorId) REFERENCES Proffesors,
     groupId INT NOT NULL AUTO_INCREMENT, 
     FOREIGN KEY(groupId) REFERENCES Groups,
     CONSTRAINT invalidCredits CHECK (creditsTeachingLoads >= 0 AND creditsTeachingLoads <= 30)
 );

 CREATE TABLE Appointments (
     appointmentsId INT NOT NULL AUTO_INCREMENT, 
     hour INT NOT NULL, 
     date DATE, 
     studentId INT NOT NULL AUTO_INCREMENT,
     FOREIGN KEY(studentId) REFERENCES Students, 
     tutoringHoursId INT NOT NULL, 
     FOREIGN KEY (tutoringHoursId) REFERENCES TutoringsHours,
     CONSTRAINT invalidHour CHECK (hour >= 0 AND hour <= 24)
 );

 CREATE TABLE Subjects(
     subjectsId INT NOT NULL AUTO_INCREMENT, 
     nameSubject VARCHAR(60) NOT NULL UNIQUE,
     acronym VARCHAR(8) NOT NULL UNIQUE,
     creditsSubcject INT NOT NULL,
     yearSubject INT NOT NULL,
	 typeSubject VARCHAR(20) NOT NULL,
     departmentId INT NOT NULL AUTO_INCREMENT, 
     gradeId INT NOT NULL AUTO_INCREMENT,
     FOREIGN KEY(departmentId) REFERENCES Departments,
     FOREIGN KEY(gradeId) REFERENCES Grades,
     CONSTRAINT invalidCredits CHECK (creditsSubcject >= 0 AND creditsSubcject <= 30),
     CONSTRAINT invalidSubjectType CHECK (typeSubject IN ('Formacion Basica',
																 'Optativa',
															 'Obligatoria'))
 );

CREATE TABLE Grades(
     gradesId INT NOT NULL AUTO_INCREMENT,
     valueGrade DECIMAL(4,2) NOT NULL, 
     gradeCall INT NOT NULL, 
     withHonours BOOLEAN NOT NULL, 
     studentId INT NOT NULL AUTO_INCREMENT,
     groupId INT NOT NULL AUTO_INCREMENT, 
     PRIMARY KEY(gradesId) REFERENCES Grades, 
     FOREIGN KEY(studentId) REFERENCES Students,
     FOREIGN KEY(groupId) REFERENCES Groups,
     CONSTRAINT invalidGradeValue CHECK (valueGrade >= 0 AND valueGrade <= 10),
	 CONSTRAINT invalidGradeCall CHECK (gradeCall >= 1 AND gradeCall <= 3),
	 CONSTRAINT duplicatedCallGrade UNIQUE (gradeCall, studentId, groupId)
    
);

CREATE TABLE Groups(
	groupId INT NOT NULL AUTO_INCREMENT,
	nameGroups VARCHAR(30) NOT NULL,
	activity VARCHAR(20) NOT NULL,
	academicYear INT NOT NULL,
	subjectId INT NOT NULL,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	UNIQUE (name, academicYear, subjectId),
	CONSTRAINT negativeGroupYear CHECK (academicYear > 0),
	CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoria',
																		 'Laboratorio'))
);

CREATE TABLE GroupsStudents(
	groupStudentId INT NOT NULL AUTO_INCREMENT,
	groupId INT NOT NULL,
	studentId INT NOT NULL,
	PRIMARY KEY (groupStudentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	UNIQUE (groupId, studentId)
);


--INSERTS
INSERT INTO Degrees (nameDegree, duration) VALUES
	('Ingeniería del Software', 4),
	('Ingeniería del Computadores', 4),
	('Tecnologías Informáticas', 4);

INSERT INTO Offices (nameOffice, floorOffice, capacity) VALUES
    ('office1', 1, 111), 
    ('office2', 2, 222), 
    ('office3', 3, 333);

INSERT INTO Classrooms (nameClassroom, floorClassroom, capacityClassroom, hasProjector, hasLoundspeakers) VALUES
    ('classroom1', 1, 123, 0, 0), 
    ('classroom2', 2, 231, 0, 1),  
    ('classroom3', 3, 432, 1, 1);

INSERT INTO Departments (nameDepartment) VALUES
    ('department1'),
    ('department2'), 
    ('department3');

INSERT INTO Students (accessMethod, dni, firstname, surname, birthdate, email) VALUES
	('Selectividad', '12345678A', 'Daniel', 'Pérez', '1991-01-01', 'daniel@alum.us.es'),
	('Selectividad', '22345678A', 'Rafael', 'Ramírez', '1992-01-01', 'rafael@alum.us.es'),
	('Selectividad', '32345678A', 'Gabriel', 'Hernández', '1993-01-01', 'gabriel@alum.us.es');


INSERT INTO Proffesors (category, dni, firstName, surname, birthDate, email,  officeId, departmentId) VALUES
     ('method1', '123456789', 'Imie1',  'Surname1', '1970-01-02', 'email1@gmail.com', 2, 1), 
     ('method2', '123456709', 'Imie2',  'Surname2', '1973-05-02', 'email2@gmail.com',  2, 2), 
     ('method3', '123432789', 'Imie3',  'Surname3', '1954-12-02', 'email3@gmail.com', 1,3);

INSERT INTO TutoringsHours(dayOfweek,  startHour, endHour, proffesorId) VALUES
    ('Monday',  8, 15, 1), 
    ('Tuesday', 9, 16, 2), 
    ('Friday', 12, 14,3);

INSERT INTO TeachingLoads (creditsTeachingLoads, proffesorId, groupId) VALUES
    (5, 1,2),
    (2, 2, 1),
    (4, 2,3 );

INSERT INTO Appointments (hour, date, studentId, tutoringHoursId) VALUES
    (13, '2021-11-13', 2, 3), 
    (10, '2022-01-12', 1,3), 
    (13, '2020-03-23', 3,2);


INSERT INTO Subjects (nameSubject, acronym, creditsSubcject, yearSubject, typeSubject, departmentId, gradeId) VALUES
	('Fundamentos de Programación', 'FP', 12, 1, 'Formacion Basica', 3, 2),
	('Lógica Informatica', 'LI', 6, 2, 'Optativa', 3, 1),
    ('Subject3', 'S3', 5, 3, 'Optativa', 3 ,1);

INSERT INTO Grades (valueGrade, gradeCall, withHonours, studentId, groupId) VALUES
	(4.50, 1, 0, 1, 1), 
	(2.50, 1, 0, 3, 2);
	(6.50, 1, 0, 2, 2);



INSERT INTO Groups (nameGroups, activity, academicYear, subjectId) VALUES
	('T1', 'Teoria', 2019, 1),
	('L1', 'Laboratorio', 2019, 1),
	('L2', 'Laboratorio', 2019, 1);



INSERT INTO GroupsStudents (groupId, studentId) VALUES
	(1, 1),
	(2,3), 
	(3, 1);


UPDATE Students
	SET birthdate = '1998-01-01', surname='Fernández'
	WHERE studentId = 3;

UPDATE Subjects
	SET credits = credits/2;

DELETE FROM Grades
	WHERE gradeId = 1;