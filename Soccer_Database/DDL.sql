select * from project_goalscorers;

alter table SCORER
	rename column First_Name to Player_Name;

alter table SCORER
	drop column Last_Name;
    
select * from SCORER;

alter table GOAL_TYPE
modify column Penalty varchar(20);

alter table GOAL_TYPE
modify column Own_Goal varchar(20);

-- More SCORER table reworking:

Select max(length(scorer))
from project_goalscorers;

desc SCORER;

ALTER TABLE SCORER
MODIFY Player_Name varchar(50);

-- -------------------------------------------------------
-- VIEW STATEMENT:

CREATE VIEW vw_ALL
as
SELECT
g.Date as date,
g. Home_Team as home_team,
g.Away_Team as away_team,
s.Scorer_Team as team,
s.Player_Name as scorer,
gm.Minute as minute,
gt.Own_Goal as own_goal,
gt.Penalty as penalty
FROM GAME g
	INNER JOIN SCORER s ON
    g.Scorer_ID = s.Scorer_ID
    INNER JOIN GOAL_MINUTE gm ON
    g.Goal_Minute_ID = gm.Goal_Minute_ID
    INNER JOIN GOAL_TYPE gt ON
    g.Goal_Type_ID = gt.Goal_Type_ID;
    
Select * from vw_ALL;