SELECT *
FROM vw_ALL;

SELECT DISTINCT scorer, team, count(scorer) as cnt
FROM vw_ALL
GROUP BY scorer, team
ORDER BY cnt desc;

-- This query shows me that Angel Romano, from Uruguary, is the top scorer in the dataset, 3 ahead of Neco from Brazil 
-- and Carlos Scarone from Uruguay. From there, the scorers are much closer to each other in their total counts.
-- ---------------------------------------------
SELECT DISTINCT team, count(scorer) as cnt
FROM vw_ALL
GROUP BY team
ORDER BY cnt desc;

-- This query shows me that Uruguay are the highest goal scorers in the datas set, with 36 total goals. 
-- Argentina and Brazil are relatively close with 28 goal each, but there is a massive drop off to the next highest, Chile with 6.
-- ---------------------------------------------------------------------------------
SELECT DISTINCT scorer, team, count(scorer) as cnt
FROM vw_ALL
WHERE own_goal = 'True'
GROUP BY scorer, team
ORDER BY cnt desc;

-- This query shows that Luis Garcia and Manuel Varela, of Argentina, are the only two players in the data set who have scored an own goal.
----------------------------------------------------------------------------------------
SELECT DISTINCT scorer, team, count(scorer) as cnt
FROM vw_ALL
WHERE penalty = 'True'
GROUP BY scorer, team
ORDER BY cnt desc;

-- This query shows that Juan Domingo Brown and Alberto Ohaco of Argentina, 
-- as well as Antonio Urdinaran of Uruguay have scored more penalties than any other players, with 2 penalties each.
------------------------------------------------------------------------------------------
SELECT DISTINCT scorer, team, count(scorer) as cnt
FROM vw_ALL
WHERE minute >= 80
AND own_goal = 'False'
GROUP BY scorer, team
ORDER BY cnt desc;

-- This query shows all the players who have scored goals in the final 10 minutes of a game. 
-- I specifically excluded own_goal so that it would only show players who scoed goals for their own teams.
-- No player scored ore than 1 goal in the final 10 minutes, but Uruguay leads the other teams with 3 goals scored.