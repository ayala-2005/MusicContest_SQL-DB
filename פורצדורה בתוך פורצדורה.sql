--פורצדורה שבודקת אם קיים חמש או פחות  ביצועים למשתתף  
alter PROCEDURE Check_If_Performance_Exists
    @ContestantID INT,
    @CompetitionID INT,
    @Exists bit output --משתנה שמחזיר ערך בוליאני
	AS
BEGIN
DECLARE @PerformanceCount int
SELECT @PerformanceCount=  COUNT(*) 
	from Performances
        WHERE ContestantID = @ContestantID AND CompetitionID = @CompetitionID
   SET @Exists = CASE WHEN @PerformanceCount >= 5 THEN 1 ELSE 0 END;   
END

---פורצדורה שמכניסה ביצוע למשתמש בתנאי שאין לו יותר מחמש ביצועים
alter PROCEDURE Add_Performance_With_Check
    @ContestantID INT,
    @SongName NVARCHAR(100),
    @PerformanceDate DATE,
    @CompetitionID INT
AS
BEGIN
    DECLARE @Exists bit

    -- קריאה לפרוצדורה הראשונה כדי לבדוק כמה ביצועים יש למתמודד
    EXEC Check_If_Performance_Exists @ContestantID, @CompetitionID, @Exists OUTPUT

    -- אם יש פחות מחמש ביצועים
    IF @Exists = 0
    BEGIN
        INSERT INTO Performances (ContestantID, SongName, PerformanceDate, CompetitionID)
        VALUES (@ContestantID, @SongName, @PerformanceDate, @CompetitionID)
        PRINT 'הביצוע נוסף בהצלחה!'
    END
    ELSE
    BEGIN
        PRINT 'למשתתף הזה כבר יש 5 ביצועים בתחרות הזו!'
    END
END
--בדיקה
exec Add_Performance_With_Check @ContestantID=1,@SongName='בדיקה',@PerformanceDate='2015-03-20',@CompetitionID=1
go
exec Add_Performance_With_Check @ContestantID=2,@SongName='בדיקה',@PerformanceDate='2015-03-20',@CompetitionID=1
go
