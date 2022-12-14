#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  6 10:07:05 2022

@author: zixin
"""

import pandas as pd
import os
import glob
# pip install googletrans==3.1.0a0
from googletrans import Translator


# change the working path as the same as where file is.
base_dir = os.path.dirname(os.path.realpath('__file__'))


#open all files in the input folder
input_path = r'test_sample' 
# create a new folder automatically to store the results
output_path = r'test_user_translation/' 
if not os.path.exists(output_path):
    os.makedirs(output_path)

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
    
# create a loop to translate the file one by one
translator = Translator()
file_translation_list= []
a = -1
for df in file_list:
    file_translation = df
    a += 1
    print("user:",a)
    file_translation['location_en'] = file_translation['location'].map(lambda x: translator.translate(x, src="zh-TW", dest="en").text)
    file_translation_list.append(file_translation)
    df.to_csv(output_path+str(a+1)+'.csv', sep = ',', 
                  encoding="utf-8", index=False)


# save the dataframe to csv files individually
adict = dict(zip(file_name_list, file_translation_list)) 
for key in adict.keys():
    filename = f'{key}.csv'
    adict[key].to_csv(output_path + filename, sep = ',' , 
                      encoding = 'utf-8', index = False)
    

    

