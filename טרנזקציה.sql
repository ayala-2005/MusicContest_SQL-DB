--עדכון של דירוג רק אם הציון בטוח תקין
BEGIN TRANSACTION;

BEGIN TRY
    UPDATE Ratings
    SET Score = 8.5
    WHERE RatingID = 10 AND Score BETWEEN 0 AND 10;

    COMMIT TRANSACTION;
    PRINT 'העדכון בוצע בהצלחה!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'שגיאה התרחשה! העדכון בוטל.';
END CATCH


--מחזיר שגיאה
BEGIN TRANSACTION
BEGIN TRY
    UPDATE Ratings
    SET Score = 11
    WHERE RatingID = 10 AND Score BETWEEN 0 AND 10;

    COMMIT TRANSACTION;
    PRINT 'העדכון בוצע בהצלחה!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'שגיאה התרחשה! העדכון בוטל.';
END CATCH