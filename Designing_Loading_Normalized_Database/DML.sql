select * from project_goalscorers;

INSERT INTO GOAL_MINUTE
(Minute)
SELECT DISTINCT minute from project_goalscorers;

ALTER TABLE project_goalscorers
ADD Goal_Minute_ID int;

select * from project_goalscorers;
select * from GOAL_MINUTE;

UPDATE project_goalscorers pg, GOAL_MINUTE gm
SET pg.Goal_Minute_ID = gm.Goal_Minute_ID
WHERE pg.minute = gm.Minute;

-- -----------------------------------------------------------------------

SELECT * FROM SCORER;

INSERT INTO SCORER
(Player_Name, Scorer_Team)
SELECT DISTINCT scorer, team from project_goalscorers;

ALTER TABLE project_goalscorers
ADD Scorer_ID INT;

UPDATE project_goalscorers pg, SCORER s
SET pg.Scorer_ID = s.Scorer_ID
WHERE pg.scorer = s.Player_Name
AND pg.team = s.Scorer_Team;

select * from project_goalscorers;

-- -----------------------------------------------------------------------

INSERT INTO GOAL_TYPE
(Penalty, Own_Goal)
SELECT DISTINCT penalty, own_goal from project_goalscorers;

select * from GOAL_TYPE;

ALTER TABLE project_goalscorers
ADD Goal_Type_ID INT;

UPDATE project_goalscorers pg, GOAL_TYPE gt
SET pg.Goal_Type_ID = gt.Goal_Type_ID
WHERE pg.penalty = gt.Penalty
AND pg.own_goal = gt.Own_Goal;

select * from project_goalscorers;

-- -----------------------------------------------------------------------------
select * from GOAL_MINUTE;

select * from GOAL_TYPE;

select * from SCORER;

SHOW TABLES;
-- ---------------------------------------------------------------------------------------------

DESC GAME;

INSERT INTO GAME 
(Date, Home_Team, Away_Team, Scorer_ID, Goal_Minute_ID, Goal_Type_ID)
SELECT date, home_team, away_team, Scorer_ID, Goal_Minute_ID, Goal_Type_ID
FROM project_goalscorers;

select * from GAME;