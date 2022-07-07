#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul  4 11:00:06 2022

@author: zixin
"""

# Import libraries 
from weibo_scraper import get_weibo_profile
import pandas as pd
import os
import glob

# change the working path as the same as where file is.
base_dir = os.path.dirname(os.path.realpath('__file__'))
#open all files in the input folder
input_path = r'data/input' 
output_path = 'data/output/' 
output_path2 = 'data/output/a/' 
all_files = glob.glob(input_path + "/*.csv")
country_list = []
for filename in all_files:
    df = pd.read_csv(filename, index_col=None, header=0)
    country_list.append(df)

# create a list of country names in advance
country_name_list= []
for filename in all_files:
    new_country_list = filename.split("/")[2]
    country_name_list.append( new_country_list.split(".")[0])

#create a big loop to get a list of user id from different countries
user_id_list_extract= []
user_id_list_df= []
a = -1
for df in country_list:
    #drop all of non values of user names
    meta = df[df['userid'].notna()]
    # Extract user names, create dataframe with them and create list
    user_id_list_meta = meta['userid'].values.tolist()
    a += 1
    print("country:",a)
    #remove the repetitons of user names
    user_id_list_unique = []
    for i in user_id_list_meta:
        if i not in user_id_list_unique:
            user_id_list_unique.append(i)
    # Get user identification from weibo (uid)
    user_id_list = []
    index = -1
    for i in user_id_list_unique:
        try:
            weibo_profile = get_weibo_profile(name= i,)   
        except AttributeError:
            weibo_profile = 0
            user_id_individual  = str(weibo_profile)
        else:
            if weibo_profile is None:
                user_id_individual  = str(weibo_profile)
            else:
                user_id_meta = str(weibo_profile).split(",")[0]
                user_id_split = user_id_meta.split(" ")[1]
                user_id_individual = user_id_split.split("=")[1] 
        index += 1
        print(index,"**scraping: %s" % i)
        user_id_list.append(user_id_individual)
    user_id_list_extract.append(user_id_list)

    # merge uid and country files by user name 
    #and change 'userid' to 'user_name'
    d = pd.DataFrame({'userid':user_id_list_unique,'uid':user_id_list})
    new_df = pd.merge(meta, d)
    new_df.rename(columns={'userid':'user_name'}, inplace = True )
    user_id_list_df.append(new_df)
    
    new_df.to_csv(output_path2+str(a+1)+'.csv', sep = ',', 
                  encoding="utf-8", index=False)
    # with open(output_path2+str(a+1)+'.csv', 'w') as f:
    #     f.write(str(new_df))
    
    user_id_list2 = user_id_list
    try:
        while True:
            user_id_list2.remove('None')
    except ValueError:
        pass
    # save user id to txt file
    with open(output_path2 + str(a+1),mode='w',encoding="utf-8") as output:
        output.write("\n".join(user_id_list2))

# save the dataframes to csv files individually
adict = dict(zip(country_name_list, user_id_list_df)) 
for key in adict.keys():
    filename = f'{key}.csv'
    adict[key].to_csv(output_path + filename, sep = ',' , 
                      encoding = 'utf-8', index = False)



#get a whole list of each country's user id which exludes none and zero value
for uid_list in user_id_list_extract:
    # remove all of none values in the list of user id
    try:
        while True:
            uid_list.remove('None')
    except ValueError:
        pass

    #remove all of 0 values in the list of user id
    user_id_list_excluded= []
    for i in user_id_list_extract:
        if i != '0':
            user_id_list_excluded.append(i)

# save user id from each country to multiple txt files
bdict = dict(zip(country_name_list, user_id_list_excluded)) 
for key,value in bdict.items():
    text_name = key+ '.txt'
    with open(output_path + text_name,mode='w',encoding="utf-8") as f:
        f.write("\n".join(value))



