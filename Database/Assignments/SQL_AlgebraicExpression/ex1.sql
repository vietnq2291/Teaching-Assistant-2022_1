-- 1
CREATE TABLE Student (
    Snum CHAR(9) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Major VARCHAR(50) NOT NULL,
    Level VARCHAR(15) CHECK (Level IN ('undergraduate', 'graduate', 'professional')),
    Age INT
);

CREATE TABLE FacultyMember (
    Fid CHAR(9) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Dept VARCHAR(50) NOT NULL
);

CREATE TABLE Class (
    Name VARCHAR(50) PRIMARY KEY,
    Semester CHAR(5),
    WeekDay INT CHECK (WeekDay IN (2,3,4,5,6,7)),
    StartTime TIME,
    EndTime TIME,
    Room VARCHAR(50),
    Fid CHAR(9),
	CONSTRAINT Class_fk_FacultyMember 
			FOREIGN KEY (Fid)
			REFERENCES FacultyMember (Fid)
);

CREATE TABLE Enrolled (
    Snum CHAR(9),
    ClassName VARCHAR(50),
	PRIMARY KEY (Snum, ClassName),
	CONSTRAINT Enrolled_fk_Class FOREIGN KEY (ClassName)
			REFERENCES Class (Name),
	CONSTRAINT Enrolled_fk_Student FOREIGN KEY (Snum)
			REFERENCES Student (Snum)
);


-- 2.  Find the students (Snum, Name) of all CS Majors (Major = 'CS') who are enrolled in the course 'IT3292E Database 20221'.
SELECT Snum, Name
FROM Student
WHERE Major = 'CS' AND Snum IN (
    SELECT Snum
    FROM Enrolled
    WHERE ClassName IN (
        SELECT Name
        FROM Class
        WHERE Name = 'IT3292E Database' AND Semester = '20221'
    )
);

SELECT Snum, Name
FROM Student s
WHERE Major = 'CS' AND EXISTS (
    SELECT Snum
    FROM Enrolled e
    WHERE Snum = s.Snum AND EXISTS (
		SELECT Name
		FROM Class
		WHERE e.ClassName = 'IT3292E Database' AND Semester = '20221'
	)
);

SELECT s.Snum, s.Name
FROM Student s JOIN Enrolled e ON s.Snum = e.Snum
				JOIN Class c ON e.ClassName = c.Name
WHERE s.Major = 'CS' AND e.ClassName = 'IT3292E Database' AND c.Semester = '20221';

-- 3.  Find the students (Snum, Name) of all classes that either meet in room D9-205 or are taught by 'Prof. Nguyen' working in “Computer Science” Department.
SELECT DISTINCT s.Snum, s.Name
FROM Student s, Class c, Enrolled e, FacultyMember f
WHERE s.Snum = e.Snum AND e.ClassName = c.Name AND c.Fid = f.Fid
AND (c.Room = 'D9-205'
    OR (f.Name = 'Prof. Nguyen' AND f.Dept = 'Computer Science'));

SELECT Snum, Name
FROM Student
WHERE Snum IN (
    SELECT Snum
    FROM Enrolled
    WHERE ClassName IN (
        SELECT Name
        FROM Class
        WHERE Room = 'D9-205'
    )
) OR Snum IN (
    SELECT Snum
    FROM Enrolled
    WHERE ClassName IN (
        SELECT Name
        FROM Class
        WHERE Fid IN (
            SELECT Fid
            FROM FacultyMember
            WHERE Name = 'Prof. Nguyen' AND Dept = 'Computer Science'
        )
    )
);

SELECT s.Snum, s.Name
FROM Student s JOIN Enrolled e ON s.Snum = e.Snum
                JOIN Class c ON c.Name = e.ClassName
WHERE c.Room = 'D9-205'
UNION
SELECT s.Snum, s.Name
FROM Student s JOIN Enrolled e ON s.Snum = e.Snum
                JOIN Class c ON c.Name = e.ClassName
                JOIN FacultyMember f  ON c.Fid = f.Fid
WHERE f.Name = 'Prof. Nguyen' AND f.Dept = 'Computer Science';

-- 4.  Find the (Snum, Name) of all pairs of students who are enrolled in some class together.
SELECT DISTINCT s1.Snum AS snum1, s1.Name AS name1, s2.Snum AS snum2, s2.Name AS name2
FROM Enrolled e1, Enrolled e2, Student s1, Student s2
WHERE e1.ClassName = e2.ClassName AND e1.Snum > e2.Snum
AND s1.Snum = e1.Snum AND s2.Snum = e2.Snum
GROUP BY s1.Snum, s1.Name, s2.Snum, s2.Name
ORDER BY s1.Snum

-- 5.  Find the students (Snum, Name), who are enrolled in two classes that meet at the same time, and names of these two classes
SELECT s.Snum, s.Name, c1.Name, c2.Name
FROM Student s, Enrolled e1, Enrolled e2, Class c1, Class c2
WHERE e1.Snum = e2.Snum AND e1.ClassName > e2.ClassName
AND e1.ClassName = c1.Name AND e2.ClassName = c2.Name
AND c1.StartTime = c2.StartTime
AND s.Snum = e1.Snum
GROUP BY s.Snum, s.Name, c1.Name, c2.Name
ORDER BY s.snum;

-- Chỉ lấy tên
SELECT s.Snum, s.Name
FROM Student s
WHERE Exists (
	SELECT e1.Snum
	FROM Enrolled e1, Enrolled e2, Class c1, Class c2
	WHERE e1.Snum = e2.Snum AND e1.ClassName != e2.ClassName
	AND e1.ClassName = c1.Name AND e2.ClassName = c2.Name
	AND c1.StartTime = c2.StartTime
	AND s.Snum = e1.Snum
);


-- 6.  Find the faculty members (fid, name) who teach every weekday in the semester 20221. 
SELECT f.Fid, f.Name
FROM FacultyMember f JOIN Class c ON f.Fid = c.Fid
WHERE c.Semester = '20221'
GROUP BY f.Fid, f.Name
HAVING Count(DISTINCT c.WeekDay) = 6;
 
-- 7.  Print the Level and the average age of students for that Level.  
SELECT Level, AVG(Age)
FROM Student
GROUP BY Level;

-- 8.  Find the faculty members (fid, name), who teach more than 4 classes per 
-- semester, and the number of classes they teach in each of these semesters 
SELECT f.Fid, f.Name, c.Semester, COUNT(*) AS NoClass_per_semester
FROM FacultyMember f JOIN Class c ON f.Fid = c.Fid
GROUP BY f.Fid, f.Name, c.Semester
HAVING COUNT(*) > 4;

-- 9.  Find the students with the least number of classes enrolled
SELECT s.Snum, s.Name, COUNT(*) AS NoClassEnrolled
FROM Student s JOIN Enrolled e ON s.Snum = e.Snum
GROUP BY s.Snum, s.Name
HAVING COUNT(*) <= ALL (
	SELECT COUNT(*) FROM Enrolled
	GROUP BY Snum
);

SELECT s.Snum, s.Name, COUNT(*) AS NoClassEnrolled
FROM Student s JOIN Enrolled e ON s.Snum = e.Snum
GROUP BY s.Snum, s.Name
HAVING COUNT(*) = (
    SELECT MIN(NoClass)
    FROM (
        SELECT COUNT(*) AS NoClass
        FROM Enrolled
        GROUP BY Snum
    ) AS NoClass
);

-- 10. Find the names of all students who are not enrolled in any class taught  by 
-- professors from department “Computer Science”
SELECT Snum, Name
FROM Student
WHERE Snum IN (
	SELECT Snum FROM Student
	EXCEPT
	SELECT Snum
	FROM Enrolled e JOIN Class c ON e.ClassName = c.Name
					JOIN FacultyMember f ON c.Fid = f.Fid
	WHERE f.Dept = 'Computer Science'
);

SELECT Snum, Name
FROM Student
WHERE Snum not IN (
	SELECT Snum
	FROM Enrolled e JOIN Class c ON e.ClassName = c.Name
					JOIN FacultyMember f ON c.Fid = f.Fid
	WHERE f.Dept = 'Computer Science'
);

SELECT Snum, Name
FROM Student s
WHERE NOT EXISTS (
	SELECT Snum
	FROM Enrolled e JOIN Class c ON e.ClassName = c.Name
					JOIN FacultyMember f ON c.Fid = f.Fid
	WHERE s.Snum = e.Snum AND f.Dept = 'Computer Science'
);