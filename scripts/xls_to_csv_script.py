# importing pandas module
import pandas as pd

# input excel file path
inputExcelFile ="sampleTutorialsPoint.xlsx"

# Reading an excel file
excelFile = pd.read_excel (inputExcelFile)

# Converting excel file into CSV file
excelFile.to_csv ("ResultCsvFile.csv", index = None, header=True)

# Reading and Converting the output csv file into a dataframe object
dataframeObject = pd.DataFrame(pd.read_csv("ResultCsvFile.csv"))

# Displaying the dataframe object
dataframeObject