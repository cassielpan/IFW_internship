clear all
insheet using "choice_data.csv", comma clear

generate double start_date_new = clock(start_date, "MDYhm")
format start_date_new %tc

generate double end_date_new = clock(end_date, "MDYhm")
format end_date_new %tc

generate double recorded_date_new = clock(recorded_date, "MDYhm")
format recorded_date_new %tc

drop start_date end_date recorded_date

* separate date and time 
** start date
gen start_date = dofc(start_date_new)
format start_date %td 
gen double start_time = mod(start_date_new, 24 * 60 * 60000)
format start_time %tcHH:MM 
** end date
gen end_date = dofc(end_date_new)
format end_date %td 
gen double end_time = mod(end_date_new, 24 * 60 * 60000)
format end_time %tcHH:MM 
** recorded_date_new
gen recorded_date = dofc(recorded_date_new)
format recorded_date %td 
gen double recorded_time = mod(recorded_date_new, 24 * 60 * 60000)
format recorded_time %tcHH:MM 

drop start_date_new end_date_new recorded_date_new

* label all variables
label variable choice_set "Choice Set"
label variable time "Time"
label variable ranking "Ranking"
label variable job_alternative "Job Alternative"
label variable employer_nationality "Employer Nationality"
label variable net_salary "Net Monthly Salary"
label variable contract_term "Contract Term"
label variable workplace_safety "Workplace Safety"
label variable workload "Workload"
label variable supervision "Supervison"
label variable status "Status"
label variable ip_address "IP Address"
label variable progress "Progress"
label variable duration "Duration (in seconds)"
label variable finished "Finished"
label variable last_name "Last Name"
label variable first_name "First Name"
label variable email "Email"
label variable external_data_reference "External Data Reference"
label variable latitude "Latitude"
label variable longitude "Longitude"
label variable distribution_channel "Distribution Channel"
label variable language "Language"
label variable consent_given "Consent Given"
label variable current_occupation "Current Occupation"
label variable current_occupation_other "Current Occupation Other"
label variable university_enrolled "University Enrolled"
label variable study_program "Study Program"
label variable study_program_other "Study Program Other"
label variable study_field "Study Field"
label variable study_field_other "Study Field Other"
label variable study_year "Study Year"
label variable gpa_score "GPA Score"
label variable average_grade_percentage "Average Grade Percentage"
label variable university_enrolled_prior_gradua "University Enrolled Prior Graduation"
label variable graduation_year "Graduation Year"
label variable highest_qualification "Highest Qualification"
label variable highest_qualification_other "Highest Qualification Other"
label variable study_field_prior_graduation "Study Field Prior Graduation"
label variable study_field_prior_graduation_pri "Study Field Prior Graduation Other"
label variable graduation_score_grade "Graduation Score Grade"
label variable graduation_score_grade_other "Graduation Score Grade Other"
label variable gender "Gender"
label variable age "Age"
label variable country "Country"
label variable trust_1 "Can Trust People"
label variable trust_2 "Can't Trust People"
label variable trust_3 "Be Careful Before Trust Strangers"
label variable risk "Willingness to take risks (0=Completely unwilling, 10=Completely willing)"
label variable student_job_aspiration "Student Job Aspiration"
label variable student_job_aspiration_other "Student Job Aspiration Other"
label variable wished_salary "Wished Salary"
label variable minimum_wished_salary "Minimum Wished Salary"
label variable employer_nationality_preference "Employer Nationality Preference"
label variable employer_nationality_preference_ "Employer Nationality Preference Options"
label variable currently_employed "Currently Employed"
label variable work_experience "Work Experience (in months)"
label variable longest_work_experience_employer "Longest Work Experience Employer"
label variable other_work_experience "Other Work Experience"
label variable second_work_experience_employer_ "Second Work Experience Employer Nationality"
label variable fair_salary "Fair Salary"
label variable fair_salary_ranking "Least Likly to offer Fair Salary"
label variable favourable_contract_term "Favourable Contract Term"
label variable favourable_contract_term_ranking "Least Likly to offer Favourable Contract Term"
label variable future_development "Future Development"
label variable future_development_raking "Least Likly to offer Future Development"
label variable working_hours "Reasonable Working Hours"
label variable working_hours_ranking "Least Likly to offer Reasonable Working Hours"
label variable work_place_safety "Work Place Safety"
label variable work_place_safety_ranking "Least Likly to offer Work Place Safety"
label variable work_independently "Work Independently"
label variable work_independently_ranking "Least Likly to offer Work Independently"
label variable labor_laws "Labor Laws"
label variable labor_laws_ranking "Least Likly to offer Labor Laws"
label variable corruption "Engage in Corruption"
label variable corruption_ranking "Least Likly to engage in Corruption"
label variable social_responsibility "Social Responsibility"
label variable social_responsibility_ranking "Least Likly to engage in Social Responsibility"
label variable local_culture "Local Culture"
label variable local_culture_ranking "Least Likly to value Local Culture"
label variable diversity_inclusion "Diversity Inclusion"
label variable diversity_inclusion_ranking "Least Likly to pursue Diversity Inclusion"
label variable perceptions_chinese "Perceptions Chinese"
label variable perceptions_chinese_why "Perceptions Chinese Why"
label variable perceptions_chinese_employers "Perceptions Chinese Employers"
label variable perceptions_chinese_employers_wh "Perceptions Chinese Employers Why"
label variable interaction_chinese_employer "Interaction Chinese Employer"
label variable interaction_chinese_employer_des "Interaction Chinese Employer Description"
label variable interaction_chinese_employer_fri "Interaction Chinese Employer Friends"
label variable interaction_ch_employ_fri_descri "Interaction Chinese Employer Friends Description"
label variable trust_chinese_1 "Can Trust Chinese"
label variable trust_chinese_2 "Can't Trust Chinese"
label variable trust_chinese_3 "Be Careful Before Trust Strange Chinese"
label variable q7_student_loan "Student Loan for Study Financing"
label variable q7_merit_scholarship "Merit Based Scholarship for Study Financing"
label variable q7_family "Family for Study Financing"
label variable q7_employer "Employer for Study Financing"
label variable q7_savings "Savings for Study Financing"
label variable q7_needs_scholarship "Needs Based Scholarship for Study Financing"
label variable q7_other "Others for Study Financing"
label variable study_financing_other "Study Financing Other"
label variable q14_student_loan "Student Loan for Study Financing (Before Graduation)"
label variable q14_merit_scholarship "Merit Based Scholarship for Study Financing (Before Graduation)"
label variable q14_family "Family for Study Financing (Before Graduation)"
label variable q14_employer "Employer for Study Financing (Before Graduation)"
label variable q14_savings "Savings for Study Financing (Before Graduation)"
label variable q14_needs_scholarship "Needs Based Scholarship for Study Financing (Before Graduation)"
label variable q14_other "Others for Study Financing (Before Graduation)"
label variable study_financing_before_graduatio "Study Financing Other (Before Graduation)"
label variable longest_work_experience_dura "Longest Work Experience Duration"
label variable second_longest_work_experience_d "Second Longest Work Experience Duration"
label variable q62_friends "Chinese Info from Friends"
label variable q62_social_media "Chinese Info from Social Media"
label variable q62_online_news "Chinese Info from Online News"
label variable q62_print_news "Chinese Info from Print News"
label variable q62_own_observe "Chinese Info from Own Observe"
label variable q62_other "Chinese Info from Others"
label variable information_source_chinese_other "Information Source Chinese Other"
label variable q133_friends "Chinese Employers Info from Friends"
label variable q133_social_media "Chinese Employers Info from Social Media"
label variable q133_online_news "Chinese Employers Info from Online News"
label variable q133_print_news "Chinese Employers Info from Print News"
label variable q133_own_observe "Chinese Employers Info from Own Observe"
label variable q133_other "Chinese Employers Info from Others"
label variable information_source_chinese_emplo "Information Source Chinese Employers Other"
label variable start_date "Start Date"
label variable start_time "Start Time"
label variable end_date "End Date"
label variable end_time "End Time"
label variable recorded_date "Recorded Date"
label variable recorded_time "Recorded Time"





** label values
label define dummy 1 "Yes" 0 "No"
label define dummy2 1 "Yes" 2 "No"
label define job_alter 1 "Job A" 2 "Job B" 3 "Job C"
label define emply_nat 0 "Chinese" 1 "Zambian" 2 "Multinational" 
label define net_sa 0 "K 9000" 1 "K 10500" 2 "K 12000"
label define contra_term 0 "2 Year" 1 "5 Year" 2 "Permanent"
label define work_safety 0 "Not Provided" 1 "Only Provided by Law" 2 "All Provided"
label define wl 0 "No Overtime Paid" 1 "Overtime Paid with 1.5 Times" 2 "No Overtime"
label define super 0 "Daily" 1 "Weekly" 2 "Monthly"
label define dis 1 "anonymous"
label define en 1 "English"
label define occu 1 "Student" 3 "Recently Graduated" 4 "Employed" 5 "Other"
label define stu 0 "Unknown" 4 "PhD" 5 "Master" 6 "Bachelor" 7 "Other"
label define sex 1 "Male" 2 "Female"
label define level 1 "Agree" 2 "Neutral" 3 "Disagree"
label define level_r 1 "Disagree" 2 "Neutral" 3 "Agree"
label define atti 0 "Unknown" 1 "Positive" 2 "Neutral" 3 "Negative" 4 "I don't know"
label define cs 1 "Choice Set 1" 2 "Choice Set 2" 3 "Choice Set 3" 4 "Choice Set 4" 5 "Choice Set 5" 6 "Choice Set 6" 7 "Choice Set 7" 8 "Choice Set 8" 9 "Choice Set 9" 10 "Choice Set 10" 11 "Choice Set 11" 12 "Choice Set 12" 13 "Choice Set 13" 14 "Choice Set 14" 15 "Choice Set 15" 16 "Choice Set 16" 17 "Choice Set 17" 18 "Choice Set 18"
label define period 1 "Period 1" 2 "Period 2" 3 "Period 3" 4 "Period 4"
label define rank 1 "First" 2 "Second" 3 "Third"
label define gpa 4 "> 3.75" 5 "3.25 - 3.75" 6 "2.68 - 3.24" 7 "< 2.68 " 8 "Not applicable"
label define grad_score 5 "Distinction" 6 "Merit" 7 "Credit" 8 "Other" 9 "Pass"
label define state 119 "Namibia" 144 "Rwanda" 167 "Swaziland" 580 "Zambia" 1357 "Zimbabwe"
label define risk_level 1 "Risk Averse" 2 "Risk Neutral 2" 3 "Risk Taking" 
label define uni 1 "Chalimbana University" 2 "Copperbelt University" 3 "Kapasa Makasa University" 4 "Kwame Nkrumah University" 5 "Levy Mwanawasa Medical University" 7 "Mukuba University" 8 "Mulungushi University" 9 "Northrise University" 11 "University of Lusaka" 12 "University of Zambia" 13 "Other"
label define field 1 "Health Professions" 2 "Agricultural and Biological Sciences" 4 "Medicine" 6 "Biochemistry, Genetics and Molecular" 7 "Biology" 9 "Nursing" 10 "Pharmaceutics Psychology" 13 "Energy" 14 "Engineering" 15 "Environmental Science" 17 "Business, Management and Accounting" 19 "Economics, Econometrics and Finance" 20 "Chemistry" 22 "Mathematics" 24 "Arts and Humanities" 25 "Social Science" 26 "Computer Science" 27 "Other"
label define job_aspiration 1 "Formal employment" 2 "Both formal and self-employment" 3 "Self-employment e.g entrepreneurship, farming" 4 "Further education e.g Master’s/ PhD/ continue studying" 5 "Other"
label define employer_nationality_prefer 1 "Zambian Company" 2 "Foreign Company (based in Zambia)" 3 "No Preference" 
label define employer_nationality_prefer_op 1 "Chinese" 2 "Other Asian" 3 "European" 4 "American" 5 "Latin American" 6 "African" 7 "No Preference"
label define longest_employer 1 "Zambian (local) Company" 2 "Chinese Company" 3 "Other Asian Company" 4 "European Company" 5 "American Company" 6 "Other"
label define fair_sa 1 "Important" 2 "Neutral" 3 "Not Important" 
label define fair_sa_rank 1 "Zambian (local) Company" 2 "Chinese Company" 3 "Other Foreign Company"

label values job_alternative job_alter
label values employer_nationality emply_nat
label values net_salary net_sa
label values contract_term contra_term
label values workplace_safety work_safety
label values workload wl
label values supervision super
label values finished dummy
label values distribution_channel dis
label values language en
label values current_occupation occu
label values study_program stu
label values gender sex
label values highest_qualification stu
label values trust_1 level
label values trust_2 level_r
label values trust_3 level
label values trust_chinese_1 level
label values trust_chinese_2 level_r
label values trust_chinese_3 level
label values q7_student_loan dummy
label values q7_merit_scholarship dummy
label values q7_family dummy
label values q7_employer dummy
label values q7_savings dummy
label values q7_needs_scholarship dummy
label values q7_other dummy
label values q14_student_loan dummy
label values q14_merit_scholarship dummy
label values q14_family dummy
label values q14_employer dummy
label values q14_savings dummy
label values q14_needs_scholarship dummy
label values q14_other dummy
label values q62_friends dummy
label values q62_social_media dummy
label values q62_online_news dummy
label values q62_print_news dummy
label values q62_own_observe dummy
label values q62_other dummy
label values q133_friends dummy
label values q133_social_media dummy
label values q133_online_news dummy
label values q133_print_news dummy
label values q133_own_observe dummy
label values q133_other dummy 
label values interaction_chinese_employer dummy2
label values interaction_chinese_employer_des atti
label values interaction_chinese_employer_fri dummy2
label values interaction_ch_employ_fri_descri atti
label values perceptions_chinese atti
label values perceptions_chinese_employers atti
label values choice_set cs
label values time period
label values ranking rank
label values gpa_score gpa
label values graduation_score_grade grad_score
label values country state
label values risk risk_level
label values university_enrolled uni
label values university_enrolled_prior_gradua uni
label values study_field field
label values study_field_prior_graduation field
label values student_job_aspiration job_aspiration
label values employer_nationality_preference employer_nationality_prefer
label values employer_nationality_preference_ employer_nationality_prefer_op
label values currently_employed dummy2
label values longest_work_experience_employer longest_employer
label values second_work_experience_employer_ longest_employer
label values fair_salary fair_sa
label values fair_salary_ranking fair_sa_rank
label values favourable_contract_term fair_sa
label values favourable_contract_term_ranking fair_sa_rank
label values future_development fair_sa
label values future_development_raking fair_sa_rank
label values working_hours fair_sa
label values working_hours_ranking fair_sa_rank
label values work_place_safety fair_sa
label values work_place_safety_ranking fair_sa_rank
label values work_independently fair_sa
label values work_independently_ranking fair_sa_rank
label values labor_laws fair_sa
label values labor_laws_ranking fair_sa_rank
label values corruption fair_sa
label values corruption_ranking fair_sa_rank
label values social_responsibility fair_sa
label values social_responsibility_ranking fair_sa_rank
label values local_culture fair_sa
label values local_culture_ranking fair_sa_rank
label values diversity_inclusion fair_sa
label values diversity_inclusion_ranking fair_sa_rank

* generate index for trust
gen trust_index = trust_1 + trust_2 + trust_3
histogram trust_index, percent
** mean 
egen meantrust_index = rowmean(trust_1 trust_2 trust_3)
histogram meantrust_index, percent
* check the correlation
pwcorr trust_1 trust_2 trust_3
* Cronbach's alpha
alpha trust_1 trust_2 trust_3
alpha trust_1 trust_2 trust_3, item

* generate index for trust_chinese
gen trust_chinese_index = trust_chinese_1 + trust_chinese_2 + trust_chinese_3
histogram trust_chinese_index, percent
** mean 
egen meantrust_chinese_index = rowmean(trust_chinese_1 trust_chinese_2 trust_chinese_3)
histogram meantrust_chinese_index, percent
* check the correlation
pwcorr trust_chinese_1 trust_chinese_2 trust_chinese_3
* Cronbach's alpha
alpha trust_chinese_1 trust_chinese_2 trust_chinese_3
alpha trust_chinese_1 trust_chinese_2 trust_chinese_3, item

