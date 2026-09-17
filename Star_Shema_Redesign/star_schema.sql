-- The first thing I'm doing is creating a staging table. This will make it easier for me to identify bugs before loading into my FACTS table, 
-- and it will also make that eventual load easier.

CREATE TABLE Staging
(Visit_ID INT,
Old_Patient_ID INT, -- These 'Old...' values will be what I eventually use to link to my dimension tables when creating foreign keys.
Visit_Date DATETIME,
Old_Provider_ID INT,
Old_Procedure_ID INT,
Old_Time_ID INT,
Old_Lab_ID INT,
Old_Diagnosis_ID INT,
Procedure_Total INT,
Lab_Test_Total INT,
Diagnosis_Total INT
);

-- Besides the foreign keys, I also wanted my facts table to record aggregates for each visit. 
-- This granularity made the most sense. For each visit, healthcare professionals can assess how many procedures, labs, and diagnoses occured. 
-- For more details, such as who the patient or provider was, or what labs took place, they can use the dimensions to access them.

CREATE TABLE Records_Fact
(Record_ID INT AUTO_INCREMENT,
Visit_ID INT,
Patient_ID INT,
Time_ID INT,
Provider_ID INT, 
Procedure_ID INT,
Lab_ID INT,
Diagnosis_ID INT,
Procedure_Total INT,
Lab_Test_Total INT,
Diagnosis_Total INT,
CONSTRAINT PK_Records PRIMARY KEY (Record_ID)
);

CREATE TABLE Patient_Dim
(Patient_ID INT AUTO_INCREMENT,
Old_Patient_ID INT, -- This attribute will be how I link my primary key with my staging table
First_Name VARCHAR (20),
Last_Name VARCHAR (20),
DOB DATETIME,
Gender VARCHAR (10),
Symptom VARCHAR (100),
CONSTRAINT PK_Patient PRIMARY KEY (Patient_ID)
);

CREATE TABLE Provider_Dim
(Provider_ID INT AUTO_INCREMENT,
Old_Provider_ID INT, -- This attribute will be how I link my primary key with my staging table, and is a good reference record to keep.
First_Name VARCHAR (20),
Last_Name VARCHAR (20),
Specialty VARCHAR (20),
CONSTRAINT PK_Provider PRIMARY KEY (Provider_ID)
);

CREATE TABLE Procedure_Dim
(Procedure_ID INT AUTO_INCREMENT,
Old_Procedure_ID INT, -- This attribute will be how I link my primary key with my staging table, and is a good reference record to keep.
Icd10_Code VARCHAR (20),
Procedure_Name VARCHAR (200),
Description VARCHAR (200),
CONSTRAINT PK_Procedure PRIMARY KEY (Procedure_ID)
);


CREATE TABLE Time_Dim
(Time_ID INT AUTO_INCREMENT,
Full_Date DATETIME, -- For this dimension, I don't need to create an 'Old...' attribute since the Full_Date will link back to dates from my staging table.
Year DATETIME,
Month DATETIME,
Day DATETIME,
CONSTRAINT PK_Time PRIMARY KEY (Time_ID)
);


CREATE TABLE Diagnosis_Dim
(Diagnosis_ID INT AUTO_INCREMENT,
Old_Diagnosis_ID INT, -- This attribute will be how I link my primary key with my staging table, and is a good reference record to keep.
Icd10_Code VARCHAR (20),
Diagnosis_Name VARCHAR (200),
CONSTRAINT PK_Diagnosis PRIMARY KEY (Diagnosis_ID)
);

CREATE TABLE Lab_Dim
(Lab_ID INT AUTO_INCREMENT,
Old_Lab_ID INT, -- This attribute will be how I link my primary key with my staging table, and is a good reference record to keep.
Cpt_Code INT,
Lab_Name VARCHAR (200),
CONSTRAINT PK_Lab PRIMARY KEY (Lab_ID)
);

ALTER TABLE Records_Fact
ADD CONSTRAINT FK_Record_Patient_ID FOREIGN KEY (Patient_ID)
REFERENCES Patient_Dim(Patient_ID);

ALTER TABLE Records_Fact
ADD CONSTRAINT FK_Record_Provider_ID FOREIGN KEY (Provider_ID)
REFERENCES Provider_Dim(Provider_ID);

ALTER TABLE Records_Fact
ADD CONSTRAINT FK_Record_Procedure_ID FOREIGN KEY (Procedure_ID)
REFERENCES Procedure_Dim(Procedure_ID);

ALTER TABLE Records_Fact
ADD CONSTRAINT FK_Record_Time_ID FOREIGN KEY (Time_ID)
REFERENCES Time_Dim(Time_ID);

ALTER TABLE Records_Fact
ADD CONSTRAINT FK_Record_Diagnosis_ID FOREIGN KEY (Diagnosis_ID)
REFERENCES Diagnosis_Dim(Diagnosis_ID);

ALTER TABLE Records_Fact
ADD CONSTRAINT FK_Record_Lab FOREIGN KEY (Lab_ID)
REFERENCES Lab_Dim(Lab_ID);
