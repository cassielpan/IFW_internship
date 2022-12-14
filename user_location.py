#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 14 09:04:37 2022

@author: zixin
"""

import numpy as np
import requests
import os
import pandas as pd
import glob

# change the working path as the same as where file is.
base_dir = os.path.dirname(os.path.realpath('__file__'))

#open all files in the input folder
input_path = r'input' 
# create a new folder automatically to store the results
output_path = r'output/' 
if not os.path.exists(output_path):
    os.makedirs(output_path)
##get the location column
#location = user1.iloc[:,9]
#location_none = location.replace({np.nan: None})

# import all files to python    
all_files = glob.glob(input_path + "/*.csv")
file_list = []
for filename in all_files:
    df = pd.read_csv(filename, lineterminator='\n', index_col=None, header=0)
    file_list.append(df)
    
# create a list of file names in advance
file_name_list= []
for filename in all_files:
    new_file_list = filename.split("/")[1]
    file_name_list.append(new_file_list.split(".")[0])


payload={}
headers = {}
user_all= []
address_all = []
lat_all = []
lng_all = []
url_list = []
#creat a big loop to handle all files
for df in file_list:
    #create a list to get all url from locations
    ##replace all nan with none in location column to have urls
    user_none = df
    user_none['location'] = user_none['location'].replace(np.nan, "none")
    for a in user_none['location']:
        url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" + str(a) + "&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=Yourkey&language=en"
        url_list.append(url)
    # get information from google maps using API  
    for url in url_list:
        response = requests.request("GET", url, headers=headers, data=payload)
        response_json = response.json()
        try:
            response_json_new = response_json['candidates'][0]
            address = response_json_new['formatted_address']
            geo = response_json_new['geometry']["location"]
            lat = str(geo["lat"])
            lng = str(geo["lng"])
        except IndexError:
            address = "none"
            lat = "none"
            lng = "none"
        address_all.append(address)
        lat_all.append(lat)
        lng_all.append(lng)   
    user_none['address'] = address_all
    user_none['lat'] = lat_all
    user_none['lng'] = lng_all
    user_all.append(user_none)
    address_all.clear()
    lat_all.clear()
    lng_all.clear()
    url_list.clear()
    # append our lists to the dataframe
   # user_none['address'] = address_all
    #user_none['lat'] = lat_all
    #user_none['lng'] = lng_all
    
# save the dataframe to csv files individually
adict = dict(zip(file_name_list, user_all)) 
for key in adict.keys():
    filename = f'{key}.csv'
    adict[key].to_csv(output_path + filename, sep = ',' , 
                      encoding = 'utf-8', index = False)


# check the df
#a = user1_none[["location", "address","lat", "lng"]]


