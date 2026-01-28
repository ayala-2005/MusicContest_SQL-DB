--שימוש ב WHILE
--עוברים על כל המשתתפים מהמזהה הנמוך ומדפיסים את הממוצע לכל הביצועים
DECLARE @PerformanceID INT, @AverageScore FLOAT, @ContestantID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50),@SomgName NVARCHAR(50)
SET @PerformanceID = (SELECT MIN(PerformanceID) FROM Performances)

WHILE @PerformanceID IS NOT NULL
BEGIN
    SELECT @ContestantID = ContestantID
    FROM Performances 
    WHERE PerformanceID = @PerformanceID

	select @SomgName=SongName
	from Performances
	WHERE PerformanceID = @PerformanceID

    SELECT @FirstName = First_Name, @LastName = Last_Name
    FROM Contestants
    WHERE ContestantID = @ContestantID

    SELECT @AverageScore = AVG(Score) 
    FROM Ratings 
    WHERE PerformanceID = @PerformanceID

    PRINT 
		  ' שם שיר: '+ @SomgName +
          ', מבצע: ' + @FirstName + ' ' + @LastName + 
          ', ממוצע: ' + CAST(@AverageScore AS NVARCHAR)

    -- ביצוע הבא
    SET @PerformanceID = (SELECT MIN(PerformanceID) 
                          FROM Performances 
                          WHERE PerformanceID > @PerformanceID)
END