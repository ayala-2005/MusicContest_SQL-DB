 -- הכנסת נתונים לטבלת משתתפים
BEGIN TRY
    INSERT INTO Contestants (Tz, First_Name, Last_Name, Age, Contestants_Type) VALUES 
    ('101112233', 'אביגיל', 'כגן', 19, 1);
    
    PRINT 'הנתונים הוזנו בהצלחה!';
END TRY
BEGIN CATCH
    PRINT 'שגיאה בהכנסת הנתונים!';
    PRINT ERROR_MESSAGE();
END CATCH

 -- מחיקת נתונים מטבלת משתתפים
BEGIN TRY
    DELETE FROM Contestants
    WHERE ContestantID IN (16, 17);
    
    PRINT 'הרשומות נמחקו בהצלחה!';
END TRY
BEGIN CATCH
    PRINT 'שגיאה במחיקה!';
    PRINT ERROR_MESSAGE();
END CATCH