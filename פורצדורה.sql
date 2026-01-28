use MusicContestDB
go

--יצירת פורצדורה
--הפרוצדורה מקבלת את PerformanceID, Ratings_Type ו־Score 
--ומחזירה את המיקום של המשתתף המדורג, יחד עם שלושת המדורגים המובילים בתחרות.
alter procedure Insert_Rating_And_Get_Top3 
@PerformanceID INT,
@Ratings_Type INT,
@Score INT
as
begin
--מכניסה נתונים לטבלה דירוג
insert into Ratings  (PerformanceID,Ratings_Type,Score)values
(@PerformanceID,@Ratings_Type ,@Score)
--מסדרת את כולם
;WITH Ranks_3 AS (
    SELECT p.PerformanceID, c.Tz, c.First_Name, c.Last_Name, com.Name_Competitions, AVG(r.Score) AS avg_score, DENSE_RANK() OVER (ORDER BY AVG(r.Score) DESC) AS ranking
    FROM Ratings r
    JOIN Performances p ON p.PerformanceID = r.PerformanceID
    LEFT JOIN Contestants c ON c.ContestantID = p.ContestantID
    LEFT JOIN Competitions com ON p.CompetitionID = com.CompetitionID
    GROUP BY p.PerformanceID, c.Tz, c.First_Name, c.Last_Name, com.Name_Competitions
)
--מביאה את 3 המקומות הראשונים
select top 3 PerformanceID, Tz, First_Name, Last_Name, Name_Competitions, avg_score, ranking
from Ranks_3
ORDER BY ranking
---לא טוב כי ממספר אחרי הקיבוץ
/*select @Rank =p.PerformanceID, c.Tz,c.First_Name,c.Last_Name,Com.Name_Competitions, avg(r.Score) as avg_score ,ROW_NUMBER() OVER (ORDER BY AVG(Score) DESC) AS ranking
from Ratings r
join Performances  p on p.PerformanceID=r.PerformanceID
left join Contestants c on c.ContestantID=p.ContestantID
left join Competitions com on p.CompetitionID=com.CompetitionID
group by c.Tz,c.First_Name,c.Last_Name,Com.Name_Competitions, p.PerformanceID
having p.PerformanceID =22*/

--מיקום כל המשתתפים
;WITH Ranks AS (
    SELECT p.PerformanceID, c.Tz, c.First_Name, c.Last_Name, com.Name_Competitions, AVG(r.Score) AS avg_score, DENSE_RANK() OVER (ORDER BY AVG(r.Score) DESC) AS ranking
    FROM Ratings r
    JOIN Performances p ON p.PerformanceID = r.PerformanceID
    LEFT JOIN Contestants c ON c.ContestantID = p.ContestantID
    LEFT JOIN Competitions com ON p.CompetitionID = com.CompetitionID
    GROUP BY p.PerformanceID, c.Tz, c.First_Name, c.Last_Name, com.Name_Competitions
)
--הביצוע המסויים
SELECT PerformanceID, Tz, First_Name, Last_Name, Name_Competitions,avg_score, ranking
FROM Ranks
WHERE PerformanceID = @PerformanceID
end
--בדיקה
exec Insert_Rating_And_Get_Top3 @PerformanceID=5,@Ratings_Type=2 ,@Score=10
go








/*select c.Tz,c.First_Name,c.Last_Name, avg(r.Score) as avg_score
from Ratings r
join Performances  p on p.PerformanceID=r.PerformanceID
join Contestants c on c.ContestantID=p.ContestantID
group by c.Tz,c.First_Name,c.Last_Name
order by avg_score desc

select *
from Ratings r
join Performances  p on p.PerformanceID=r.PerformanceID
join Contestants c on c.ContestantID=p.ContestantID
where tz='445566778'

select c.Tz,c.First_Name,c.Last_Name, r.Score 
from Ratings r
join Performances  p on p.PerformanceID=r.PerformanceID
join Contestants c on c.ContestantID=p.ContestantID
where c.Tz='445566778'*/