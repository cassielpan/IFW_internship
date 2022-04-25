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
