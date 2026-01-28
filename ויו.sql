--יצירת view
CREATE VIEW vw_Contestants_Details AS
select c.Tz,c.First_Name,c.Last_Name,c.Age,c_t.Contestants_Type_Name,p.SongName,avg(r.Score) as avg_score,p.PerformanceDate,com.Name_Competitions,e_r.Reason_Description 
from Contestants c
join Contestants_Type  c_t on c.Contestants_Type=c_t.Contestants_Type_ID
left join Performances p  on c.ContestantID=p.ContestantID
left join Competitions com on p.CompetitionID=com.CompetitionID
left join Performances per on p.PerformanceID=per.PerformanceID
left join Ratings r on r.PerformanceID=p.PerformanceID
left join Eliminations e on c.ContestantID=e.ContestantID
left join Elimination_Reasons e_r on e_r.ReasonID=e.EliminationReason
group by c.Tz,c.First_Name,c.Last_Name,c.Age,c_t.Contestants_Type_Name,p.SongName,p.PerformanceDate,com.Name_Competitions,e_r.Reason_Description

--בדיקה VIEW
select * from vw_Contestants_Details
