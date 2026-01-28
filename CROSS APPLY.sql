--מביא למשתתף שיש לו ביצוע את הביצוע האחרון
SELECT C.ContestantID, C.First_Name, C.Last_Name, P.SongName, P.PerformanceDate
FROM Contestants C
CROSS APPLY (
    SELECT TOP 1 P.SongName, P.PerformanceDate
    FROM Performances P
    WHERE P.ContestantID = C.ContestantID
    ORDER BY P.PerformanceDate DESC
) P