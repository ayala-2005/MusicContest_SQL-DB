
--פונקציה שמקבלת מזהה מתמודד ומזהה תחרות ומחזירה כמה ביצועים היה למתמודד
alter FUNCTION dbo.Get_Performance_Count
(
    @ContestantID int,
    @CompetitionID int
)
RETURNS INT
AS
BEGIN
DECLARE @PerformanceCount INT

select @PerformanceCount= COUNT(*)
from Performances
where ContestantID=@ContestantID and CompetitionID=@CompetitionID

RETURN ISNULL(@PerformanceCount, 0) 
end

--בדיקה
SELECT dbo.Get_Performance_Count(1,1)
SELECT dbo.Get_Performance_Count(2,1)
