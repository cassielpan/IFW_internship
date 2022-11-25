clear all

import excel "user.xlsx", firstrow

graph bar (count), over(user_location_province, label(angle(forty_five) labsize(vsmall))) title("User Location Distribution")  ytitle("Number of Weibo Users") 
graph export user_location.png, replace

graph bar (count), over(user_gender, relabel(1 "female" 2 "male" 3 "unknown")) title("User Gender Distribution")  ytitle("Number of Weibo Users")
graph export user_gender.png, replace

graph bar (count), over (user_marriage) title("Marriage Status Distribution")  ytitle("Number of Weibo Users") 
graph export user_marriage.png, replace

graph bar (count), over (user_blood) title("Blood Type Distribution")  ytitle("Number of Weibo Users") 
graph export user_blood.png, replace

graph bar (count), over(registration_date_year, label(angle(forty_five) labsize(small))) title("Registration Year Distribution")  ytitle("Number of Weibo Users") 
graph export user_registration.png, replace

clear all
import excel "user_blood.xlsx", firstrow

graph bar (count), over (user_blood) title("Blood Type Distribution (Excluding unknown)")  ytitle("Number of Weibo Users") 
graph export "user_blood(exclude).png", replace



clear all
import excel "user_marriage.xlsx", firstrow

graph bar (count), over (user_marriage) title("Marriage Status Distribution (Excluding unknown)")  ytitle("Number of Weibo Users") 
graph export "user_marriage(exclude).png", replace


clear all
import excel "user_birth_year.xlsx", firstrow

graph bar (count), over(user_birthday_year, label(angle(forty_five) labsize(tiny))) title("Birth Year Distribution (Up to the Last 80 Years)")  ytitle("Number of Weibo Users") 
graph export "birth_year.png", replace


clear all
import excel "user_birth_year_exclude.xlsx", firstrow

graph bar (count), over(user_birthday_year, label(angle(forty_five))) title("Birth Year Distribution in 1975 - 2004 (Excluding unknown)")  ytitle("Number of Weibo Users") 
graph export "birth_year(exclude).png", replace

clear all
import excel "user_horoscope.xlsx", firstrow

graph bar (count), over(user_birthday, label(angle(forty_five)) relabel(1 "Gemini" 2 "Pisces" 3 "Virgo" 4 "Libra" 5 "Scorpio" 6 "Sagittarius" 7 "Cancer" 8 "Capricorn" 9 "Aquarius" 10 "Leo" 11 "Aries" 12 "Taurus")) title("Horoscope Distribution (Excluding unknown)")  ytitle("Number of Weibo Users") 
graph export "horoscope.png", replace

clear all
import excel "user_ip_china_overseas.xlsx", firstrow

graph bar (count), over (IP_china_overseas) title("IP Location Distribution")  ytitle("Number of Weibo Users") 
graph export "ip_china_overseas.png", replace

clear all
import excel "user_ip_china.xlsx", firstrow

graph bar (count), over(IP_location, label(angle(forty_five) labsize(vsmall)) relabel(1 "Shanghai" 2 "China" 3 "Taiwan" 4 "Macau" 5 "Hongkong" 6 "Yunnan" 7 "Neimenggu" 8 "Beijing" 9 "Jilin" 10 "Sichuan" 11 "Tianjin" 12 "Ningxia" 13 "Anhui" 14 "Shandong" 15 "Shanxi" 16 "Guangdong" 17 "Guangxi" 18 "Xinjiang" 19 "Jiangsu" 20 "Jiangxi" 21 "Hebei" 22 "Henan" 23 "Zhejiang" 24 "Hainan" 25 "Hubei" 26 "Hunan" 27 "Gansu" 28 "Fujian" 29 "Tibet" 30 "Guizhou" 31 "Liaoning" 32 "Chongqing" 33 "Shaanxi" 34 "Qinghai" 35 "Heilongjiang" )) title("Horoscope Distribution (Excluding unknown)") title("IP Location Distribution in China (Excluding unknown)")  ytitle("Number of Weibo Users") 
graph export "ip_china.png", replace


clear all
import excel "user_ip_overseas.xlsx", firstrow

graph bar (count), over (IP_location)

