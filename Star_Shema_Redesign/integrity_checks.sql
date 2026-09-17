-- The first thing I'm doing is creating a view that might be useful for my integrity checks. 
-- This view uses the query that I used to create my staging table.

create view vw_integrity
as
Select
v.visit_id,
v.patient_id,
v.visit_date,
v.provider_id,
vp.procedure_id,
vl.lab_id,
vd.diagnosis_id,
counts.procedure_total,
counts.lab_total,
counts.diagnosis_total
From emr.visit v
	LEFT JOIN emr.visit_procedure vp ON 
    v.visit_id = vp.visit_id
    LEFT JOIN emr.visit_lab vl ON
    v.visit_id = vl.visit_id
    LEFT JOIN emr.visit_diagnosis vd ON
    v.visit_id = vd.visit_id
    LEFT JOIN (
		SELECT
			v2.visit_id,
            COUNT(DISTINCT vp2.procedure_id) as procedure_total,
            COUNT(DISTINCT vl2.lab_id) as lab_total,
            COUNT(DISTINCT vd2.diagnosis_id) as diagnosis_total
		FROM emr.visit v2
			LEFT JOIN emr.visit_procedure vp2 ON
            v2.visit_id = vp2.visit_id
            LEFT JOIN emr.visit_lab vl2 ON 
            v2.visit_id = vl2.visit_id
            LEFT JOIN emr.visit_diagnosis vd2 ON
            v2.visit_id = vd2.visit_id
		GROUP BY v2.visit_id
	) counts ON v.visit_id = counts.visit_id;
    
-- Since 'Visit' was the granularity I chose, I want to check that I have the same number of rows from my source visit table, my view, and my facts table:

SELECT *
FROM emr.visit; -- Confirmed 306 rows in source table

SELECT DISTINCT Visit_ID, Patient_ID, Provider_ID, Visit_Date
FROM vw_integrity; -- Confirmed 306 rows in the view

SELECT DISTINCT Visit_ID, Patient_ID, Provider_ID, Full_Date
FROM Records_Fact RF
	INNER JOIN Time_Dim TD ON
    RF.Time_ID = TD.Time_ID; -- Confirmed 306 rows in the Facts table after using a join

--
-- Now I'm confirming the row counts between source tables and dimension tables --

-- Checking Patient:

SELECT p.patient_id, p.first_name, p.last_name, p.dob, p.gender, s.note
FROM emr.visit v
	 LEFT JOIN emr.patient p ON
    v.patient_id = p.patient_id
     LEFT JOIN emr.visit_symptom vs ON
    v.visit_id = vs.visit_id
		LEFT JOIN emr.symptom s ON
        vs.symptom_id = s.symptom_id; -- Confirmed 497 rows in source tables after JOIN
        
SELECT * FROM Patient_Dim; -- Confirmed 497 rows in dimension table

-- Checking diagnosis:

SELECT * FROM emr.diagnosis; -- Confirmed 500 rows
SELECT * FROM Diagnosis_Dim; -- Confirmed 500 rows

-- Checking Provider:

SELECT * FROM emr.provider; -- Confirmed 50 rows
SELECT * FROM Provider_Dim; -- Confirmed 50 rows

-- Checking Procedure:

SELECT * FROM emr.clinical_procedures; -- Confirmed 500 rows
SELECT * FROM Procedure_Dim; -- Confirmed 500 rows

-- Checking Lab:

SELECT * FROM emr.lab; -- Confirmed 500 rows
SELECT * FROM Lab_Dim; -- Confirmed 500 rows

--
-- Now I'm performing a large join, bringing all my dimensions together with my fact table, to verify referential integrity --

SELECT * 
FROM Records_Fact rf
	JOIN Patient_Dim pat_d ON
    rf.Patient_ID = pat_d.Patient_ID
    JOIN Provider_Dim pro_d ON
    rf.Provider_ID = pro_d.Provider_ID
    JOIN Procedure_Dim proc_d ON
    rf.Procedure_ID = proc_d.Procedure_ID
    JOIN Time_Dim td ON
    rf.Time_ID = td.Time_ID
    JOIN Diagnosis_Dim dd ON
    rf.Diagnosis_ID = dd.Diagnosis_ID
    JOIN Lab_Dim ld ON
    rf.lab_ID = ld.lab_id; -- Confirmed that everything loads correctly!
    