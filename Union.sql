select c.ContestantID,c.tz,c.First_Name,c.Last_Name,c.Age,ct.Contestants_Type_Name 
from Contestants c
join Contestants_Type ct on c.Contestants_Type=ct.Contestants_Type_ID
where ct.Contestants_Type_Name='מתחרה'
union all
select c.ContestantID,c.tz,c.First_Name,c.Last_Name,c.Age,ct.Contestants_Type_Name 
from Contestants c
join Contestants_Type ct on c.Contestants_Type=ct.Contestants_Type_ID
where ct.Contestants_Type_Name='שופט'