#transformation of individual bank data to summary statistics
#edges are currently summed by standard deviation
import statistics
import math
from operator import itemgetter
import time as t
from flask import flash

#gets unique values for a key
def get_unique_values(data,key):
    values=[]
    for row in data:
        values.append(row[key])
    uniqueValuesSet=set(values)
    uniqueValues=list(uniqueValuesSet)
    return uniqueValues

def input(row,key):
    try:
        value=row[key]
    except KeyError:
        msg = "Data missing " + key
        flash(msg) 
        return -1
    return value



