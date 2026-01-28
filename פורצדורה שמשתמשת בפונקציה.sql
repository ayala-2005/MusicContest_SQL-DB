--פונקציה שמחשבת ממוצע ציונים לביצוע מסוים
alter FUNCTION dbo.Get_Avg_Score
(
@ContestantID int,
@CompetitionID int
)
RETURNS float
AS
BEGIN
DECLARE @Avg_Score float

select @Avg_Score= avg(r.Score)
from Performances p
join Ratings r on r.PerformanceID=p.PerformanceID
where ContestantID=@ContestantID and CompetitionID=@CompetitionID

RETURN ISNULL(@Avg_Score, 0);

end

--פורצדורה שבודקת  האם ממוצע הציונים של המתמודד גדול ממוצע כל הציונים
--אם כן – תדפיס שהמתמודד עבר לשלב הבא
--אם לא – תדפיס שהמתמודד לא עבר
alter procedure Check_Performance_Score
@ContestantID int,
@CompetitionID int
as
begin
--בדיקה ממוצע ציונים
DECLARE @avg_CompetitionID FLOAT
select @avg_CompetitionID=AVG(r.Score)
from Performances p
join Ratings r on r.PerformanceID=p.PerformanceID
where  CompetitionID=@CompetitionID
--קריאה לפונקציה שבודקת את ממוצע הציונים של המתחרה
DECLARE @Avg_Score_Contestant float
SET @Avg_Score_Contestant = dbo.Get_Avg_Score(@ContestantID, @CompetitionID)
--בדיקה אם המשתתף עובר לשלב הבא - אם הסכום נקודות שלו גדול מהממצוע נקודות של כולם
if @Avg_Score_Contestant>@avg_CompetitionID
begin
print 'המשתתף עבר לשלב הבא'
end

else
begin
print 'המשתתף לא עבר לשלב הבא'
end
end

--בדיקה
exec Check_Performance_Score @ContestantID=5,@CompetitionID=3
go
exec Check_Performance_Score @ContestantID=2,@CompetitionID=1
go
