# Import libraries 
from weibo_scraper import get_weibo_profile
import csv
import pandas as pd
import os

# change the working path as the same as where file is.
base_dir = os.path.dirname(os.path.realpath('__file__'))

# os.chdir('/Users/zixin/Desktop/Kiel/weibo/codes')
print(os.getcwd())
# Import csv data for Algeria
algeria_meta = pd.read_excel('merge_in_total.xlsx')

# Extract user names, create dataframe with them and create list
user_id_list_meta=algeria_meta['userid'].values.tolist()




#remove the repetitons of user names
user_id_list_unique = []
for i in user_id_list_meta:
    if i not in user_id_list_unique:
        user_id_list_unique.append(i)

# Get user identification from weibo (uid)
user_id_list = []
for i in user_id_list_unique:
    weibo_profile = get_weibo_profile(name= i,)
    if weibo_profile is None:
        user_id_individual  = str(weibo_profile)
    else:
        user_id_meta = str(weibo_profile).split(",")[0]
        user_id_split = user_id_meta.split(" ")[1]
        user_id_individual = user_id_split.split("=")[1] 
    print("**output: %s" % i)
    user_id_list.append(user_id_individual)





# save the df with user_name and uid as csv
with open('uid.csv','w') as csvfile: 
    writer=csv.writer(csvfile)
    writer.writerow(['user name','uid'])
    writer.writerows(zip(user_id_list_unique, user_id_list))
    
#save user name to txt file, encoding="utf-8"
with open("user_name.txt", "w") as output:
    output.write(str(user_id_list_unique))


# remove all of none values in the list of user id
try:
    while True:
        user_id_list.remove('None')
except ValueError:
    pass
# save user id to txt file
with open("uid.txt", "w") as output:
    output.write(str(user_id_list))




#open the txt file
# my_file = open("user_name.txt", "r")
# content = my_file. read()
# print(content)
# content_list = content. split(",")
# my_file. close()
# print(content_list)
