--טריגר
--טריגר שיבדוק אם הכניסו ציון קטן מ-1 וגדול מ10
--ושבסוג משתתף הכניסו רק 3 או 2
alter TRIGGER trg_takin
ON Ratings
AFTER  INSERT, UPDATE
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(250)=''
    --בדיקה אם קיים ביצוע כזה
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN Performances p ON i.PerformanceID = p.PerformanceID
        WHERE p.PerformanceID IS NULL
    )
    BEGIN
        SET @ErrorMessage = @ErrorMessage + 'שגיאה: הביצוע שדורגים אינו קיים!' + CHAR(13) + CHAR(10)
    END    -- בדיקת תנאים על הנתונים החדשים שנכנסו
    IF EXISTS (
        SELECT 1
		FROM inserted
        WHERE Score < 1 OR Score > 10
    )
    BEGIN
        set @ErrorMessage=@ErrorMessage+ ' הודעת שגיאה: הציון צריך להיות בין 1 ל-10!'+ CHAR(13) + CHAR(10)
    END
	IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Ratings_Type NOT IN (2, 3) 
    )
    BEGIN
        set @ErrorMessage=@ErrorMessage + ' שגיאה: ניתן להכניס לסוג מדרג רק 2 או 3!' 
    END
	IF @ErrorMessage <>''
    BEGIN
        print @ErrorMessage
        ROLLBACK TRANSACTION
    END

END
--בדיקה
exec Insert_Rating_And_Get_Top3 @PerformanceID=9,@Ratings_Type=1 ,@Score=11
go