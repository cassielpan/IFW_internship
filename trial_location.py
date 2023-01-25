import os
import pandas as pd
import requests
import glob
import subprocess


# change the working path as the same as where file is.
base_dir = os.path.dirname(os.path.realpath('__file__'))

#os.chdir('/Users/zixin/Desktop/Work/Kiel/part_time/weibo/weibo_actual/trial')

#open all files in the input folder
input_path = r'input' 
# create a new folder automatically to store the results
output_path = r'output/' 
if not os.path.exists(output_path):
    os.makedirs(output_path)
    
# imports all csv sheets
all_files = glob.glob(input_path + "/*.csv")
df_list = (pd.read_csv(file, engine='python') for file in all_files)
# Concatenate all DataFrames
# merge them into one big file called users_merged
users_merged   = pd.concat(df_list, ignore_index=True)

# save unique locations, only keep location column
# how many none values
users_merged_nan_count = users_merged['location'].isna().sum()
# how many unique locations
users_merged_no_nan = users_merged[users_merged['location'].notna()]
users_merged_no_nan_unique = users_merged_no_nan.drop_duplicates(subset=['location'], keep='first')

#save above files to csv
users_merged.to_csv(output_path + "users_merged.csv", index=False)
users_merged_no_nan.to_csv(output_path + "users_merged_no_nan.csv", index=False)
users_merged_no_nan_unique.to_csv(output_path + "users_merged_no_nan_unique.csv", index=False)

#extracts unique location and create locations_unique dataframe
# import the stata file and run it as part of this script so that yxou get locations_unique
cmd = ["/Applications/Stata/StataSE.app/Contents/MacOS/StataSE", "do", "/Users/zixin/Desktop/Work/Kiel/part_time/weibo/weibo_actual/trial/location_tag.do"]
subprocess.call(cmd) 

# save unique df to use for the rest of the code
# see if you can already create a csv here but if not its okay
df = pd.read_csv("locations_unique.csv",index_col=None, header=0)

payload={}
headers = {}
user_all= []
address_all = []
lat_all = []
lng_all = []
url_list = []

for a in df['location']:
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" + str(a) + "&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=&language=en"
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
df['google_places_address'] = address_all
df['google_lat'] = lat_all
df['google_lng'] = lng_all

# save dataframe to csv in the output folder
df.to_csv(output_path + "locations_unique.csv", index=False)


# use lat and lng to get information from nominatim
from geopy.geocoders import Nominatim
# create new df in order not to change the original one
df_nom = df.copy()
geolocator = Nominatim(user_agent="myGeolocator",  timeout=None)
#create a new column which includes both lat and lng
df_nom['geo'] = df_nom[['google_lat', 'google_lng']].apply(lambda x: ', '.join(x[x.notnull()]), axis = 1)

nom_lat_all = []
nom_lng_all = []
nom_display_name_all = []
nom_road_all = []
nom_district_all = []
nom_city_all = []
nom_state_all = []
nom_country_all = []
nom_country_code_all = []
nom_postcode_all = []
nom_province_all = []
nom_suburb_all = []
nom_region_all = []
nom_quarter_all = []
nom_state_district_all = []
nom_district_all = []
nom_borough_all = []
nom_municipality_all = []
nom_city_district_all = []

for i in df_nom['geo']:
    try:
        location = geolocator.reverse(i, language='en')
        location_address = location.raw['address']
        nom_lat = location.latitude
        nom_lng = location.longitude
        nom_display_name = location.raw['display_name']
        nom_country = location_address.get('country')
        nom_country_code = location_address.get('country_code')
        nom_road = location_address.get('road')
        nom_city_district = location_address.get('city_district')
        nom_city = location_address.get('city')
        nom_state = location_address.get('state')
        nom_postcode = location_address.get('postcode')
        nom_province = location_address.get('province')
        nom_suburb = location_address.get('suburb')
        nom_region = location_address.get('region')
        nom_quarter = location_address.get('quarter')
        nom_state_district = location_address.get('state_district')
        nom_district = location_address.get('district')
        nom_borough = location_address.get('borough')
        nom_municipality = location_address.get('municipality')   
        
    except ValueError:
        nom_lat = "none"
        nom_lng = "none"
        nom_display_name = "none"
        nom_country = "none"
        nom_country_code = "none"
        nom_road = "none"
        nom_city_district = "none"
        nom_city = "none"
        nom_state = "none"
        nom_postcode = "none"
        nom_province = "none"
        nom_suburb = "none"
        nom_region = "none"
        nom_quarter = "none"
        nom_state_district = "none"
        nom_district = "none"
        nom_borough = "none"
        nom_municipality = "none"    
        
    nom_lat_all.append(nom_lat)
    nom_lng_all.append(nom_lng)
    nom_display_name_all.append(nom_display_name)   
    nom_country_all.append(nom_country)
    nom_country_code_all.append(nom_country_code)   
    nom_road_all.append(nom_road)
    nom_city_district_all.append(nom_city_district) 
    nom_city_all.append(nom_city)
    nom_state_all.append(nom_state)   
    nom_postcode_all.append(nom_postcode)
    nom_province_all.append(nom_province) 
    nom_suburb_all.append(nom_suburb)
    nom_region_all.append(nom_region)   
    nom_quarter_all.append(nom_quarter)
    nom_state_district_all.append(nom_state_district)
    nom_district_all.append(nom_district)   
    nom_borough_all.append(nom_borough)
    nom_municipality_all.append(nom_municipality)


df_nom['nom_display_name'] = nom_display_name_all
df_nom['nom_lat'] = nom_lat_all
df_nom['nom_lng'] = nom_lng_all
df_nom['nom_road'] = nom_road_all
df_nom['nom_city_district'] = nom_city_district_all
df_nom['nom_city'] = nom_city_all
df_nom['nom_state'] = nom_state_all
df_nom['nom_country'] = nom_country_all
df_nom['nom_country_code'] = nom_country_code_all
df_nom['nom_province'] = nom_province_all
df_nom['nom_suburb'] = nom_suburb_all
df_nom['nom_region'] = nom_region_all
df_nom['nom_quarter'] = nom_quarter_all
df_nom['nom_state_district'] = nom_state_district_all
df_nom['nom_district'] = nom_district_all
df_nom['nom_borough'] = nom_borough_all
df_nom['nom_municipality'] = nom_municipality_all
df_nom['nom_postcode'] = nom_postcode_all


df_nom = df_nom.replace([None], ['none'], regex=True)


# save dataframe to csv in the output folder
# merge the df_nom back  to users_merged df and save as users_merged_locations
left_merged = pd.merge(users_merged, df_nom, how="left", on=["location"])
left_merged.to_csv(output_path + "users_merged_locations.csv", index=False)



