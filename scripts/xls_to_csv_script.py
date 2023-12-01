# importing sys module
import sys

# importing os module
import os

# importing pandas module
import pandas as pd

# importing Path from pathlib module
from pathlib import Path

# input excel file path
inputExcelFile = 'null'

# Confirming arguments
if (len(sys.argv) <= 1):
  print('err: resource file path without specifying')
  exit(1)
elif (len(sys.argv) <= 2):
  print('err: destination path without especifying')
  exit(1)
else:
  # Confirming paths
  if (not os.path.exists(sys.argv[1]) or not os.path.isfile(sys.argv[1])):
    print('err: resource file path does not exist or it is not a file')
    exit(1)
  elif (not os.path.exists(sys.argv[2]) or not os.path.isdir(sys.argv[2])):
    print('err: destination path does not exist or it is not a directory')
    exit(1)
  elif(sys.argv[2][-1] != '/' and sys.argv[2][-1] != '\\'):
    print('err: destination path must end with \'/\' or \'\\\' character')
    exit(1)
  else:
    # Reading an excel file
    inputExcelFile = sys.argv[1]
    if (inputExcelFile.split('.')[-1] != 'xls' and inputExcelFile.split('.')[-1] != 'xlsx'):
      print('err: input path is not a xls or xlsx file')
      exit(1)
    else:
      excelFile = pd.read_excel (inputExcelFile)
      # Reading file name
      outputCSVFile = Path(inputExcelFile).stem

      # Reading destination path
      destPath = sys.argv[2]

      # Converting excel file into CSV file
      excelFile.to_csv (destPath + outputCSVFile + '.csv', index = None, header=True)