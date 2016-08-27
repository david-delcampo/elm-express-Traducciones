#!/usr/bin/python
# -*- coding: utf-8 -*-

import xlrd
from collections import OrderedDict
import json
 
# Open the workbook and select the first worksheet
wb = xlrd.open_workbook('italiano.xls')
sh = wb.sheet_by_index(0)
 
# List to hold dictionaries
cars_list = []
 
# Iterate through each row in worksheet and fetch values into dict
for rownum in range(2, sh.nrows):
    cars = OrderedDict()
    row_values = sh.row_values(rownum)    
    cars['texto'] = row_values[0]
    cars['italiano'] = row_values[1]
    cars['ingles'] = row_values[1]
 
    cars_list.append(cars)
 
# Serialize the list of dicts to JSON
j = json.dumps(cars_list)
 
# Write to file
with open('data.json', 'w') as f:    
    f.write(j)