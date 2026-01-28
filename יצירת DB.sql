CREATE DATABASE MusicContestDB
USE MusicContestDB
go



--יצירת טבלה משתתפים
create table Contestants(
ContestantID int PRIMARY KEY IDENTITY,--מזהה ייחודי
Tz NVARCHAR(9) not null,--תעודת זהות
First_Name NVARCHAR(50) not null,--שם פרטי
Last_Name NVARCHAR(50) not null,--שם משפחה
Age Int not null,--גיל
Contestants_Type int not null--סוג משתתף
)


--יצירת טבלה סוג משתתף
create table Contestants_Type(
Contestants_Type_ID Int PRIMARY KEY IDENTITY,--מזהה ייחודי
Contestants_Type_Name NVARCHAR(50) not null--שם הסוג
)
 --הוספת מפתח זר לסוג משתתף
alter table Contestants
add constraint Contestants#Contestants_Type
FOREIGN KEY (Contestants_Type)  REFERENCES Contestants_Type (Contestants_Type_ID)

--יצירת טבלת תחרויות
create table Competitions (
CompetitionID Int PRIMARY KEY IDENTITY,--מזהה תחרות
Name_Competitions NVARCHAR(100) not null,--שם התחרות
Start_Date DATE not null,--תאריך התחלה
End_Date DATE--תאריך סיום
)

--יצירת טבלת ביצועים
create table Performances  (
PerformanceID INT PRIMARY KEY IDENTITY,--מזהה ביצוע
ContestantID int not null FOREIGN KEY REFERENCES Contestants(ContestantID),--המשתתף שמבצע
SongName NVARCHAR(100),--שם השיר
PerformanceDate DATE ,--תאריך הביצוע
CompetitionID INT not null FOREIGN KEY REFERENCES Competitions(CompetitionID)--התחרות שבה מתבצע
)

-- טבלת דירוגים
CREATE TABLE Ratings (
    RatingID INT  PRIMARY KEY IDENTITY,--מזהה דירוג
    PerformanceID INT not null,--הביצוע שמדורג
    Ratings_Type INT not null,--סוג המדרג
    Score int not null,--ציון
    FOREIGN KEY (PerformanceID) REFERENCES Performances(PerformanceID),
    FOREIGN KEY (Ratings_Type) REFERENCES Contestants_Type(Contestants_Type_ID)
)
alter table Ratings
ALTER COLUMN Score FLOAT NOT NULL
--יצירת טבלת סיבת הדחה
create table Elimination_Reasons (
ReasonID Int PRIMARY KEY IDENTITY,--מזהה ייחודי
Reason_Description NVARCHAR(225) not null--תיאור סיבה 
)

-- טבלת הדחות
CREATE TABLE Eliminations (
    EliminationID INT PRIMARY KEY IDENTITY,--מזהה הדחה
    ContestantID INT not null FOREIGN KEY REFERENCES Contestants(ContestantID),--מזהה משתתף
    CompetitionID INT not null  FOREIGN KEY REFERENCES Competitions(CompetitionID),--מזהה תחרות
    EliminationRound INT not null,--שלב ההדחה
    EliminationReason INT not null FOREIGN KEY  REFERENCES  Elimination_Reasons(ReasonID)--סיבת ההדחה 
)



--הכנסת נותנים
--הכנסת נתונים לטבלת סוגי משתתפים
INSERT INTO Contestants_Type (Contestants_Type_Name) VALUES 
('מתחרה'),
('שופט'),
('קהל')
--הכנסת נתונים לטבלת משתתפים
INSERT INTO Contestants (Tz, First_Name, Last_Name, Age, Contestants_Type) VALUES 
('123456789', 'נועם', 'כהן', 22, 1),
('987654321', 'דניאל', 'לוי', 25, 2),
('456789123', 'אורי', 'מזרחי', 20, 3),
('321654987', 'יעל', 'ברק', 30, 1),
('654987321', 'תמר', 'גולן', 27, 1),
('112233445', 'רוני', 'כהן', 24, 1),  
('223344556', 'אורן', 'לוי', 29, 2), 
('334455667', 'גיא', 'שפירא', 21, 3),  
('445566778', 'מאיה', 'בר', 26, 1),  
('556677889', 'אלון', 'קשת', 28, 2),  
('667788990', 'שירה', 'בן דוד', 23, 1),   
('778899001', 'רז', 'אביב', 30, 2),   
('889900112', 'ליאם', 'דרור', 27, 3), 
('990011223', 'עומר', 'סיני', 22, 3),  
('101112233', 'נויה', 'גולן', 19, 1)
--הכנסת נתונים לטבלת תחרויות
INSERT INTO Competitions (Name_Competitions, Start_Date, End_Date) VALUES 
('הכוכב הבא 2015', '2015-03-10', '2015-06-20'),
('קול ישראל 2016', '2016-04-15', '2016-07-30'),
('תחרות השירה הלאומית', '2017-05-01', '2017-08-25'),
('פסטיבל המוזיקה הארצי', '2018-06-10', '2018-09-15'),
('The Voice ישראל 2019', '2019-09-05', '2019-12-18'),
('זמר השנה 2020', '2020-02-20', '2020-05-30'),
('פסטיבל הכוכבים', '2021-07-01', '2021-10-10'),
('הכוכב הבא 2022', '2022-09-15', '2022-12-25'),
('אליפות השירה הארצית', '2023-10-10', '2024-02-01'),
('כוכב המוזיקה 2024', '2024-03-05', '2024-06-20'),
('הבמה הגדולה 2025', '2025-05-10', '2025-08-20')
--הכנסת נתונים לטבלת ביצועים
INSERT INTO Performances (ContestantID, SongName, PerformanceDate, CompetitionID) VALUES 
(1, 'הכל זה מלמעלה', '2015-03-15', 1),
(2, 'דרך השלום', '2015-03-20', 1),
(3, 'תן לי כוח', '2016-04-18', 2),
(4, 'כשהשם איתי', '2016-04-22', 2),
(5, 'יש לי שמחה', '2017-06-01', 3),
(6, 'עוד יום יבוא', '2017-06-05', 3),
(7, 'ילדים כאלה', '2018-07-10', 4),
(8, 'מה שאתה צריך', '2018-07-15', 4),
(9, 'שוב לשמוח', '2019-09-10', 5),
(10, 'גשם בעיתו', '2019-09-15', 5),
(1, 'עד שתגדל', '2020-02-25', 6),
(3, 'תסתכל עליי', '2020-03-01', 6),
(5, 'מחכה', '2021-07-05', 7),
(7, 'מישהו איתי כאן', '2021-07-10', 7),
(2, 'בסוף הכל חולף', '2022-09-20', 8),
(4, 'מתוק כשמרלי', '2022-09-25', 8),
(6, 'זה הזמן שלך', '2023-10-15', 9),
(8, 'תחזרי', '2023-10-20', 9),
(10, 'לילה טוב', '2024-03-10', 10),
(9, 'כמוני', '2024-03-15', 10),
(7, 'לבחור נכון', '2025-05-15', 11),
(5, 'בגלל הרוח', '2025-05-20', 11),
(1, 'מישהו יקרא לך אמא', '2015-04-15', 1)
--הכנסת נתונים לטבלת דירוגים
INSERT INTO Ratings (PerformanceID, Ratings_Type, Score) VALUES 
(1, 1, 8), 
(1, 1, 9), 
(2, 1, 7),
(2, 2, 8),
(3, 2, 9),
(3, 1, 10),
(4, 2, 6),
(4, 1, 7),
(5, 2, 10),
(5, 1, 9),
(6, 1, 8),
(6, 2, 8),
(7, 1, 5),
(7, 2, 6),
(8, 1, 7),
(8, 2, 7),
(9, 1, 9),
(9, 2, 9),
(10, 1, 8),
(10, 2, 7),
(11, 1, 4),
(11, 2, 5),
(12, 1, 7),
(12, 1, 7),
(13, 2, 9),
(13, 1, 10),
(14, 2, 8),
(14, 1, 9),
(15, 2, 7),
(15, 1, 8),
(16, 2, 6),
(16, 1, 7),
(17, 2, 5),
(17, 1, 6),
(18, 2, 4),
(18, 2, 5),
(19, 1, 10),
(19, 2, 10),
(20, 1, 9),
(20, 2, 9),
(21, 2, 8),
(21, 1, 9),
(22, 2, 7),
(22, 1, 8)
--הכנסת נתונים לטבלת סיבות הדחה
INSERT INTO Elimination_Reasons (Reason_Description) VALUES 
('קיבל את מספר ההצבעות הנמוך ביותר'),
('פרש מרצונו'),
('עבירה על הכללים '),
('אחר')
--בכנסת נתונים לטבלת הדחות
INSERT INTO Eliminations (ContestantID, CompetitionID, EliminationRound, EliminationReason) VALUES 
(2, 1, 2, 3),  
(3, 2, 1, 1),
(1, 1, 3, 1),
(3, 2, 2, 2),
(5, 3, 4, 1),
(7, 4, 3, 3),
(9, 5, 5, 1),
(2, 6, 2, 3),
(4, 7, 3, 1),
(6, 8, 4, 2),
(8, 9, 2, 3),
(10, 10, 5, 1),
(12, 11, 3, 2)
--בטעות הכנסתי ביצועים ודירוגים לשופטים ולקהל
UPDATE Ratings
SET Ratings_Type = 3
WHERE Ratings_Type = 1

DELETE FROM Ratings
WHERE PerformanceID IN (
    SELECT p.PerformanceID
    FROM Performances p
    JOIN Contestants c ON c.ContestantID = p.ContestantID
    JOIN Contestants_Type c_t ON c.Contestants_Type = c_t.Contestants_Type_ID
    WHERE c_t.Contestants_Type_Name IN ('שופט', 'קהל')
)

DELETE p
FROM Performances p
JOIN Contestants c ON c.ContestantID = p.ContestantID
JOIN Contestants_Type c_t ON c.Contestants_Type = c_t.Contestants_Type_ID
WHERE c_t.Contestants_Type_Name IN ('שופט', 'קהל')

select * from Competitions
select * from Contestants
select * from Contestants_Type
select * from Elimination_Reasons
select * from Eliminations
select * from Performances
select * from Ratings

