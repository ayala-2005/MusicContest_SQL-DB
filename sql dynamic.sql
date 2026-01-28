--מביא את רשימת הביצועים עבור המשתתף שיכניסו לו
--sql dynamic
DECLARE @ContestantID INT = 1 --צריך להכניס מזהה של משתתף
DECLARE @dynami_performance NVARCHAR(MAX)

SET @dynami_performance = 'SELECT * FROM Performances WHERE ContestantID = ' + CAST(@ContestantID AS NVARCHAR)

EXEC sp_executesql @dynami_performance