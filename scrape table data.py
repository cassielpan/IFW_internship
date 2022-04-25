#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 18 15:57:32 2022

@author: zixin
"""


import time
import requests
import pandas as pd



 # elem = driver.find_element_by_xpath("//*[@class='card m-panel card25']")
 # elem.click()

htmls = []
url = 'https://csrbox.org/India-list-CSR-projects-India?page={idx}'
for idx in range(1, 141):
    time.sleep(1)
    print("**scraping: page%d" % idx)
    r = requests.get(url.format(idx=idx))
    htmls.append(r.text)

htmls[1]

df = pd.read_html(htmls[1])
print(len(df))
print(type(df))
df[0].head(4)

df_list = []
for html in htmls:
    df = pd.read_html(html)
    df_list.append(df[0])
    
df_all = pd.concat(df_list)

df_all.head(3)    
df_all.shape    

df_all[["Project Name", "Name of the Company", "Thematic Area", "Project Budget", "Location"]].to_excel("csr_data.xlsx", index=False)
