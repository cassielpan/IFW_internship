#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 21 17:15:26 2022

@author: zixin
"""

import time
import requests
import pandas
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as ec

Path = '/Users/zixin/Downloads/chromedriver'



url = 'https://csrbox.org/India-list-CSR-projects-India'

driver = webdriver.Chrome(Path)

driver.get(url)
time.sleep(5)

link = driver.find_element_by_link_text('2019-20').send_keys(Keys.ENTER)


import pandas as pd
import requests
from bs4 import BeautifulSoup

url = 'https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldAll'

r = requests.get(url)
html = r.text

soup = BeautifulSoup(html)
table = soup.find('table', {"class": "t-chart"})
rows = table.find_all('tr')
data = []
for row in rows[1:]:
    cols = row.find_all('td')
    cols = [ele.text.strip() for ele in cols]
    data.append([ele for ele in cols if ele])

result = pd.DataFrame(data, columns=['Date', '1 Mo', '2 Mo', '3 Mo', '6 Mo', '1 Yr', '2 Yr', '3 Yr', '5 Yr', '7 Yr', '10 Yr', '20 Yr', '30 Yr'])

print(result)





