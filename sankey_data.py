import csv
import json
from flask import flash
from utilities import *

def get_periods_month(data):
    periods=[]
    for row in data:
        #compute order
        year = int(row['time'][0:4])
        month = int(row['time'][6])
        idx = year*12+month
        #only add unique values
        if idx not in [period['idx'] for period in periods]:
            periods.append({"time": row['time'], "idx": idx})

    periodsSorted=sorted(periods, key=lambda k:k['idx'])
    result=[]
    for period in periodsSorted: result.append(period['time'])
    return result

def get_periods_quarter(data):
    periods=[]
    for row in data:
        #compute order
        year = int(row['time'][0:4])
        quarter = int(row['time'][6])
        idx = year*12+quarter*3
        #only add unique values
        if idx not in [period['idx'] for period in periods]:
            periods.append({"time": row['time'], "idx": idx})

    periodsSorted=sorted(periods, key=lambda k:k['idx'])
    result={}
    for period in periodsSorted: result[period['idx']]=period['time']
    return result

def multi_period_transform_sankey_data(data,keys):
    transformed_data=[]

    for row in data:
        source=input(row,'source')
        target=input(row,'target')
        source_level=input(row,'source_level')
        target_level=input(row,'target_level')
        edge_type=input(row,'edge_type')
        time=input(row,'time')
        value=input(row,'value')

        try:
            numericValue = float(value)
            transformed_data.append({ "source": source, "target": target,
            "absValue": numericValue, "time": time, 
            "source_level": source_level, "target_level": target_level, "edge_type": edge_type})
        except ValueError:
            continue
    #keep for validation
    print("Validate data input")
    for idx, row in enumerate(transformed_data):
        print (row)
        if idx>10:
            break
    print(transformed_data[1:10])
    return transformed_data   

def eliminate_zero_values(data):
    dataClean = [row for row in data if (row['absValue']>0)]
    return dataClean

#slice data into two levels
'''
def slice_into_levels(data):
    slicedData=[]
    for row in data:
        slicedData.append({"source": row['source'], "target": row['edge_type'], "absValue": row['absValue'], "time": row['time'],
        "source_level": 0, "target_level": 1, "edge_type": row['target']})
        slicedData.append({"source": row['edge_type'], "target": row['target'], "absValue": row['absValue'], "time": row['time'],
        "source_level": 1, "target_level": 2, "edge_type": row['edge_type']})
    
    return slicedData
'''
