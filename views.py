from flask import Flask, render_template, request, redirect, url_for, flash, Response
from werkzeug import secure_filename
import os
import csv
#import json
from sankey_data import *
from utilities import *

ALLOWED_EXTENSIONS = set(['csv'])

def upload_file():        
    UPLOAD_FOLDER ='upload_data' 
    filename = 'ea_banks_bs.csv'
    filepath = os.path.join(UPLOAD_FOLDER, filename)
    #save content in data
    data = []
    with open(filepath) as file:
        reader = csv.DictReader(file)
        for row in reader:
            data.append(row)

    #save categories in keys 
    keys=[]
    with open(filepath) as file:    
        reader =csv.DictReader(file)
        keys = reader.fieldnames

    #try to create data for sankey chart (sankey_data=-1 if this fails)
    if data != -1: 
        #turn into data suitable for a multi-period sankey
        data=multi_period_transform_sankey_data(data,keys)
        #get time {timeIdx1: date1, timeIdx2: date2} (in order)
        time= get_periods_quarter(data)
        data=eliminate_zero_values(data)

        #save data
        filepath = os.path.join(UPLOAD_FOLDER, 'data.json')
        with open (filepath,'w') as file:
            json.dump(data,file)
        filepath = os.path.join(UPLOAD_FOLDER, 'keys.json')
        with open (filepath,'w') as file:
            json.dump(keys,file)
        filepath = os.path.join(UPLOAD_FOLDER, 'time.json')
        with open (filepath,'w') as file:
            json.dump(time,file)
            
        return

if __name__ == '__main__':
    upload_file()