# Importing all relevant libraries

import os
from pyspark.sql import SparkSession
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.classification import (RandomForestClassifier, LogisticRegression, 
DecisionTreeClassifier)
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark.ml import Pipeline


base_dir = "/home/filepathhere" # Placeholder for public GitHub display
input_path = f"file://{os.path.join(base_dir, 'loan_data.csv')}"
output_path = os.path.join(base_dir, "output.txt")

# Initializing the Spark session
spark = SparkSession.builder.appName("LoanPredictors").getOrCreate()

# Loading the dataset
df = spark.read.csv(input_path, header=True, inferSchema=True)

# The only column that I'm dropping is Loan_ID. All others seem relevant for the model
df = df.drop("Loan_ID") 

# Dropping all rows with null values
df = df.dropna()

# Encoding categorical values for the model to be able to read
gender_indexer = StringIndexer (inputCol="Gender", outputCol="GenderIndexed")
married_indexer = StringIndexer (inputCol="Married", outputCol="MarriedIndexed")
dependent_indexer = StringIndexer (inputCol="Dependents", outputCol="DependentsIndexed") # This column appeared as a string when I ran the script. So I'm encoding it here.
education_indexer = StringIndexer (inputCol="Education", outputCol="EducationIndexed")
self_employed_indexer = StringIndexer (inputCol="Self_Employed", outputCol="Self_EmployedIndexed")
property_indexer = StringIndexer (inputCol="Property_Area", outputCol="Property_AreaIndexed")

# Since my target variable is also a string value, I'm encoding it as well
loan_status_indexer = StringIndexer (inputCol="Loan_Status", outputCol="Loan_Indexed")


# Assembling the features. I'm including every feature in the dataset, bar Loan_ID, since they all seem to be contributing factors to a person's loan approval prospects.
assembler = VectorAssembler(
	inputCols=["GenderIndexed", "MarriedIndexed", "DependentsIndexed", "EducationIndexed",
 	"Self_EmployedIndexed", "ApplicantIncome", "CoapplicantIncome", "LoanAmount", "Loan_Amount_Term",
 	"Credit_History", "Property_AreaIndexed"],
 	outputCol = "features"
)

# Creating a Random Forest model
rf = RandomForestClassifier(labelCol="Loan_Indexed", featuresCol="features", numTrees=100)

# Building a Pipeline
pipeline = Pipeline(stages=[loan_status_indexer, gender_indexer, married_indexer, dependent_indexer, education_indexer, self_employed_indexer, property_indexer, assembler, rf])

# Training, testing, and splitting
train_data, test_data = df.randomSplit([0.8, 0.2], seed=42)

# Training the model
model = pipeline.fit(train_data)

# Making a prediction
predictions = model.transform(test_data)

# Evaluating the model
evaluator = MulticlassClassificationEvaluator(labelCol="Loan_Indexed", predictionCol="prediction", metricName="accuracy")
accuracy = evaluator.evaluate(predictions)

# Writing the evaluation metrics to the output file
with open(output_path, "w") as f:
	f.write(f"Random Forest Classification Accuracy: {accuracy: .4f}\n")

# Creating, training, fitting, and evaluating  a Logistic Regression model
lr = LogisticRegression(labelCol="Loan_Indexed", featuresCol="features")

pipeline = Pipeline(stages=[loan_status_indexer, gender_indexer, married_indexer, dependent_indexer, education_indexer, self_employed_indexer, property_indexer, assembler, lr])

train_data, test_data = df.randomSplit([0.8, 0.2], seed=42)

model = pipeline.fit(train_data)

predictions = model.transform(test_data)

evaluator = MulticlassClassificationEvaluator(labelCol="Loan_Indexed", predictionCol="prediction", metricName="accuracy")
accuracy = evaluator.evaluate(predictions)

# Appending the Logistic Regression evaluation metrics to the output file
with open(output_path, "a") as f:
	f.write(f"Logistic Regression Classification Accuracy: {accuracy: .4f}\n")

#Creating, training, fitting, and evaluating a Decision Tree Classification model
dt = DecisionTreeClassifier(labelCol="Loan_Indexed", featuresCol="features", maxDepth=5) #I'm setting this max depth to try and fit the model a little better, especially compared to a Random Forest with 100 trees.

pipeline = Pipeline(stages=[loan_status_indexer, gender_indexer, married_indexer, dependent_indexer, education_indexer, self_employed_indexer, property_indexer, assembler, dt])

train_data, test_data = df.randomSplit([0.8, 0.2], seed=42)

model = pipeline.fit(train_data)

predictions = model.transform(test_data)

evaluator = MulticlassClassificationEvaluator(labelCol="Loan_Indexed", predictionCol="prediction", metricName="accuracy")
accuracy = evaluator.evaluate(predictions)

# Appending the Decision Tree evaluation metrics to the output file
with open(output_path, "a") as f:
	f.write(f"Decision Tree Classification Accuracy: {accuracy: .4f}\n")

# Stopping Spark
spark.stop()
