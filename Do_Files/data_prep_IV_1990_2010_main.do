clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


** Commute time data
cd $data\temp_files\commute

u commute, clear

cd $data\geographic\

merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

cd $data\temp_files
merge m:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge

drop se_1990 se_2010


* MANAGEMENT, BUSINESS, SCIENCE, AND ARTS
g occ_group=1 if occ2010>=10 & occ2010<=430
* BUSINESS OPERATIONS SPECIALISTS
replace occ_group=2 if occ2010>=500 & occ2010<=730
* FINANCIAL SPECIALISTS
replace occ_group=3 if occ2010>=800 & occ2010<=950
* COMPUTER AND MATHEMATICAL
replace occ_group=4 if occ2010>=1000 & occ2010<=1240
* ARCHITECTURE AND ENGINEERING
replace occ_group=5 if occ2010>=1300 & occ2010<=1540
* TECHNICIANS
replace occ_group=6 if occ2010>=1550 & occ2010<=1560
* LIFE, PHYSICAL, AND SOCIAL SCIENCE
replace occ_group=7 if occ2010>=1600 & occ2010<=1980
* COMMUNITY AND SOCIAL SERVICES
replace occ_group=8 if occ2010>=2000 & occ2010<=2060
* LEGAL
replace occ_group=9 if occ2010>=2100 & occ2010<=2150
* EDUCATION, TRAINING, AND LIBRARY
replace occ_group=10 if occ2010>=2200 & occ2010<=2550
* ARTS, DESIGN, ENTERTAINMENT, SPORTS, AND MEDIA
replace occ_group=11 if occ2010>=2600 & occ2010<=2920
* HEALTHCARE PRACTITIONERS AND TECHNICAL
replace occ_group=12 if occ2010>=3000 & occ2010<=3540
* HEALTHCARE SUPPORT
replace occ_group=13 if occ2010>=3600 & occ2010<=3650
* PROTECTIVE SERVICE
replace occ_group=14 if occ2010>=3700 & occ2010<=3950
* FOOD PREPARATION AND SERVING
replace occ_group=15 if occ2010>=4000 & occ2010<=4150
* BUILDING AND GROUNDS CLEANING AND MAINTENANCE
replace occ_group=16 if occ2010>=4200 & occ2010<=4250
* PERSONAL CARE AND SERVICE
replace occ_group=17 if occ2010>=4300 & occ2010<=4650
* SALES AND RELATED
replace occ_group=18 if occ2010>=4700 & occ2010<=4965
* OFFICE AND ADMINISTRATIVE SUPPORT
replace occ_group=19 if occ2010>=5000 & occ2010<=5940
* FARMING, FISHING, AND FORESTRY
replace occ_group=20 if occ2010>=6005 & occ2010<=6130
* CONSTRUCTION
replace occ_group=21 if occ2010>=6200 & occ2010<=6765
* EXTRACTION
replace occ_group=22 if occ2010>=6800 & occ2010<=6940
* INSTALLATION, MAINTENANCE, AND REPAIR
replace occ_group=23 if occ2010>=7000 & occ2010<=7630
* PRODUCTION
replace occ_group=24 if occ2010>=7700 & occ2010<=8965
* TRANSPORTATION AND MATERIAL MOVING
replace occ_group=25 if occ2010>=9000 & occ2010<=9750


cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

drop if count1990==.

cd $data\temp_files
merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

cd $data\temp_files

merge m:1 occ2010 gisjoin using tract_impute_share
keep if _merge==3
drop _merge

drop count2000 
cd $data\temp_files
save temp, replace

***

foreach num of numlist 1(1)21 {
cd $data\temp_files
u temp if occ_group!=`num', clear

g a1990=exp( log(impute_share1990))
g a2010=exp( log(impute_share1990)+7.204779*val_1990*expected_commute-7.204779*val_2010*expected_commute)

sort occ2010 metarea
by occ2010 metarea: egen sim1990=sum(a1990)
by occ2010 metarea: egen sim2010=sum(a2010)

replace sim1990=a1990/sim1990
replace sim2010=a2010/sim2010

replace sim1990=sim1990*count1990
replace sim2010=sim2010*count1990

cd $data\inter_files\demographic\education

g sim1990_high=sim1990 if high_skill==1
g sim1990_low=sim1990 if high_skill==0

g sim2010_high=sim2010 if high_skill==1
g sim2010_low=sim2010 if high_skill==0

collapse (sum) sim1990_high  (sum) sim1990_low (sum) sim2010_high (sum) sim2010_low (sum) count=count1990,by(gisjoin metarea)


g dln_sim_low=ln(sim2010_low)-ln(sim1990_low)
g dln_sim_high=ln(sim2010_high)-ln(sim1990_high)
g dln_sim=ln(sim2010_high+sim2010_low)-ln(sim1990_high+sim1990_low)

keep gisjoin dln_sim_low dln_sim_high dln_sim
g occ_group=`num'
cd $data\temp_files\iv
save sim_iv`num', replace
}


foreach num of numlist 23(1)25 {
cd $data\temp_files
u temp if occ_group!=`num', clear

g a1990=exp( log(impute_share1990))
g a2010=exp( log(impute_share1990)+7.204779*val_1990*expected_commute-7.204779*val_2010*expected_commute)


sort occ2010 metarea
by occ2010 metarea: egen sim1990=sum(a1990)
by occ2010 metarea: egen sim2010=sum(a2010)

replace sim1990=a1990/sim1990
replace sim2010=a2010/sim2010

replace sim1990=sim1990*count1990
replace sim2010=sim2010*count1990

g sim1990_high=sim1990 if high_skill==1
g sim1990_low=sim1990 if high_skill==0

g sim2010_high=sim2010 if high_skill==1
g sim2010_low=sim2010 if high_skill==0

collapse (sum) sim1990_high  (sum) sim1990_low (sum) sim2010_high (sum) sim2010_low (sum) count=count1990,by(gisjoin metarea)

g dln_sim_low=ln(sim2010_low)-ln(sim1990_low)
g dln_sim_high=ln(sim2010_high)-ln(sim1990_high)
g dln_sim=ln(sim2010_high+sim2010_low)-ln(sim1990_high+sim1990_low)

keep gisjoin dln_sim_low dln_sim_high dln_sim
g occ_group=`num'
cd $data\temp_files\iv
save sim_iv`num', replace
}


clear all
foreach num of numlist 1(1)21 {
append using sim_iv`num'
}

foreach num of numlist 23(1)25 {
append using sim_iv`num'
}

save sim_iv, replace


*** total instrument for housing rent

cd $data\temp_files
u temp, clear
g a1990=exp( log(impute_share1990))
g a2010=exp( log(impute_share1990)+8.934139*val_1990*expected_commute-8.934139*val_2010*expected_commute)


sort occ2010 metarea
by occ2010 metarea: egen sim1990=sum(a1990)
by occ2010 metarea: egen sim2010=sum(a2010)

replace sim1990=a1990/sim1990
replace sim2010=a2010/sim2010

replace sim1990=sim1990*count1990
replace sim2010=sim2010*count1990

g sim1990_high=sim1990 if high_skill==1
g sim1990_low=sim1990 if high_skill==0

g sim2010_high=sim2010 if high_skill==1
g sim2010_low=sim2010 if high_skill==0

collapse (sum) sim1990_high  (sum) sim1990_low (sum) sim2010_high (sum) sim2010_low (sum) count=count1990,by(gisjoin metarea)


g dln_sim_low=ln(sim2010_low)-ln(sim1990_low)
g dln_sim_high=ln(sim2010_high)-ln(sim1990_high)
g dln_sim=ln(sim2010_high+sim2010_low)-ln(sim1990_high+sim1990_low)

keep gisjoin dln_sim_low dln_sim_high dln_sim
ren dln_sim_low dln_sim_low_total
ren dln_sim_high dln_sim_high_total
ren dln_sim dln_sim_total
cd $data\temp_files\iv
save sim_iv_total, replace


*** Ingredient for instrument for amenity shock

cd $data\temp_files
u temp, clear

g a1990=exp( log(impute_share1990))
g a2010=exp( log(impute_share1990)+8.934139*val_1990*expected_commute-8.934139*val_2010*expected_commute)

sort occ2010 metarea
by occ2010 metarea: egen sim1990=sum(a1990)
by occ2010 metarea: egen sim2010=sum(a2010)

replace sim1990=a1990/sim1990
replace sim2010=a2010/sim2010

replace sim1990=sim1990*count1990
replace sim2010=sim2010*count1990

cd $data\inter_files\demographic\education

g sim1990_high=sim1990 if high_skill==1
g sim1990_low=sim1990 if high_skill==0

g sim2010_high=sim2010 if high_skill==1
g sim2010_low=sim2010 if high_skill==0

collapse (sum) sim1990_high  (sum) sim1990_low (sum) sim2010_high (sum) sim2010_low,by(gisjoin)

cd $data\temp_files\iv

save ingredient_for_iv_amenity, replace
