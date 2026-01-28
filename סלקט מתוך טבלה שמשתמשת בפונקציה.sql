--סלקט מתוך טבלה שמשתמשת בפונקציה
SELECT 
    c.First_Name,
	c.Last_Name,
    co.Name_Competitions,
    SongName,
    PerformanceDate,
    dbo.Get_Performance_Count(p.ContestantID,p. CompetitionID) AS PerformanceCount
FROM Performances p
join Contestants c on c.ContestantID=p.ContestantID
join Competitions co on co.CompetitionID=p.CompetitionID
order by PerformanceCount asc
