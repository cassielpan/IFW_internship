#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 15:24:41 2022

@author: zixin
"""
import time
import requests
import pandas as pd

url = 'https://csrbox.org/ajaxdata.php'
htmls = []

for page in range(1, 4):
    post_data = (('page', page), ('tab','Ongoing'), ('keyword', ''), ('state', ''))
    time.sleep(1)
    print("**scraping: page%d" % page)
    r = requests.post(url, data=post_data)
    htmls.append(r.text)

htmls[1]

df = pd.read_html(htmls[1])
print(len(df))
print(type(df))
df[0].head(20)


df_list = []
for html in htmls:
    df = pd.read_html(html)
    df_list.append(df[0])
    
df_all = pd.concat(df_list)

df_all.head(3)    
df_all.shape    

df_all[["Project Name", "Name of the Company", "Thematic Area", "Project Budget", "Location"]].to_excel("csr_data_Ongoing.xlsx", index=False)
