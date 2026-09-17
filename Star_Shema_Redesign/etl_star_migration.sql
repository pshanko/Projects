-- I'm aware that my method of aggregating means that I will have many rows for each visit.
-- However, this is the level of granularity that made the most sense to me in order to maintain all the records AND perform aggregations.
Insert into Staging
(Visit_ID,
Old_Patient_ID, -- Every attribute that begins with 'Old' is simply for reference when I later load my foreign keys. They won't be added to the facts table.
Visit_Date,
Old_Provider_ID,
Old_Procedure_ID,
Old_Lab_ID,
Old_Diagnosis_ID,
Procedure_Total,
Lab_Test_Total,
Diagnosis_Total)
	SELECT 
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
			SELECT -- Subquery to perform the aggregations
				v.visit_id,
				COUNT(DISTINCT vp.procedure_id) as procedure_total,
				COUNT(DISTINCT vl.lab_id) as lab_total,
				COUNT(DISTINCT vd.diagnosis_id) as diagnosis_total
			FROM emr.visit v
				LEFT JOIN emr.visit_procedure vp ON
				v.visit_id = vp.visit_id
				LEFT JOIN emr.visit_lab vl ON 
				v.visit_id = vl.visit_id
				LEFT JOIN emr.visit_diagnosis vd ON
				v.visit_id = vd.visit_id
			GROUP BY v.visit_id
		) counts ON v.visit_id = counts.visit_id;

-- LOADING MY PATIENT DIMENSION:

INSERT INTO Patient_Dim
(Old_Patient_ID, First_Name, Last_Name, DOB, Gender, Symptom)
	SELECT 
		p.patient_id, 
        p.first_name, 
        p.last_name, 
        p.dob, 
        p.gender, 
        s.note
	FROM emr.visit v
		LEFT JOIN emr.patient p ON
		v.patient_id = p.patient_id
		LEFT JOIN emr.visit_symptom vs ON
		v.visit_id = vs.visit_id
			LEFT JOIN emr.symptom s ON
			vs.symptom_id = s.symptom_id;

SELECT 
        Coalesce(s.note, 'No symptom on file')
	FROM emr.visit v
		LEFT JOIN emr.patient p ON
		v.patient_id = p.patient_id
		LEFT JOIN emr.visit_symptom vs ON
		v.visit_id = vs.visit_id
			LEFT JOIN emr.symptom s ON
			vs.symptom_id = s.symptom_id;

ALTER TABLE Staging
ADD Patient_ID INT;

UPDATE Staging s, Patient_Dim pd -- This is now how I'm linking my patient dimension into my staging table, and why I kept the old ID
SET s.Patient_ID = pd.Patient_ID
WHERE s.Old_Patient_ID = pd.Old_Patient_ID;

-- LOADING MY PROVIDER DIMENSION
INSERT INTO Provider_Dim
(Old_Provider_ID, First_Name, Last_Name, Specialty)
SELECT DISTINCT provider_ID, first_name, last_name, specialty from emr.provider;

ALTER TABLE Staging
ADD Provider_ID INT;

UPDATE Staging s, Provider_Dim pd -- This is now how I'm linking my provider dimension into my staging table, and why I kept the old ID
SET s.Provider_ID = pd.Provider_ID
WHERE s.Old_Provider_ID = pd.Old_Provider_ID;

-- LOADING MY PROCEDURE DIMENSION

INSERT INTO Procedure_Dim
(Old_Procedure_ID, Icd10_Code, Procedure_Name, Description)
SELECT procedure_id, icd10_code, proc_name, description from emr.clinical_procedures;

ALTER TABLE Staging
ADD Procedure_ID INT;

UPDATE Staging s, Procedure_Dim pd -- This is now how I'm linking my procedure dimension into my staging table, and why I kept the old ID
SET s.Procedure_ID = pd.Procedure_ID
WHERE s.Old_Procedure_ID = pd.Old_Procedure_ID;

-- LOADING MY TIME DIMENSION

-- When initially loading data in, I discovered an error. My Year, Month, Day columns should be integers, not datetime! Here's my fix:
ALTER TABLE Time_Dim
MODIFY COLUMN Year INT,
MODIFY COLUMN Month INT,
MODIFY COLUMN Day INT;

INSERT INTO Time_Dim
(Full_Date, Year, Month, Day)
SELECT visit_date, Year(visit_date), Month(visit_date), Day(visit_date) FROM emr.visit;


ALTER TABLE Staging
ADD Time_ID INT;

UPDATE Staging s, Time_Dim TD
SET s.Time_ID = TD.Time_ID
Where s.Visit_Date = TD.Full_Date;

-- LOADING MY DIAGNOSIS DIMENSION:

INSERT INTO Diagnosis_Dim
(Old_Diagnosis_ID, Icd10_Code, Diagnosis_Name)
SELECT diagnosis_id, icd10_code, name FROM emr.diagnosis;

ALTER TABLE Staging
ADD Diagnosis_ID INT;

UPDATE Staging s, Diagnosis_Dim dd -- This is now how I'm linking my diagnosis dimension into my staging table, and why I kept the old ID
SET s.Diagnosis_ID = dd.Diagnosis_ID
WHERE s.Old_Diagnosis_ID = dd.Old_Diagnosis_ID;

-- LOADING MY LAB DIMENSION

INSERT INTO Lab_Dim
(Old_Lab_ID, Cpt_Code, Lab_Name)
SELECT lab_id, cpt_code, lab_name FROM emr.lab;

ALTER TABLE Staging
ADD Lab_ID INT;

UPDATE Staging s, Lab_Dim ld -- This is now how I'm linking my lab dimension into my staging table, and why I kept the old ID
SET s.Lab_ID = ld.Lab_ID
WHERE s.Old_Lab_ID = ld.Old_Lab_ID;

-- LOADING MY FACTS TABLE:

INSERT INTO Records_Fact
(Visit_ID, Patient_ID, Time_ID, Provider_ID, Procedure_ID, Lab_ID, Diagnosis_ID, Procedure_Total, Lab_Test_Total, Diagnosis_Total)
SELECT Visit_ID, Patient_ID, Time_ID, Provider_ID, Procedure_ID, Lab_ID, Diagnosis_ID, Procedure_Total, Lab_Test_Total, Diagnosis_Total
FROM Staging;

