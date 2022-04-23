clear all
global data="C:\Users\alen_\Dropbox\paper_folder\replication\data"


** residential data
cd $data\temp_files
u tract_impute_share, clear

** Commute time data
cd $data\temp_files\commute

merge 1:m gisjoin occ2010 using commute
keep if _merge==3
drop _merge

ren expected_commute expected_commute_1990

merge 1:m gisjoin occ2010 using commute2010
keep if _merge==3
drop _merge

ren expected_commute expected_commute_2010
ren expected_commute_1990 expected_commute

g dexpected=expected_commute_2010-expected_commute

*** value of time data
cd $data\temp_files
merge m:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge

drop se_1990 se_2000

*** rent
cd $data\temp_files
merge m:1 gisjoin using rent
drop if _merge==2
drop _merge

*** instrument for location demand


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

cd $data\temp_files\commute
merge m:1 gisjoin occ_group using commute_total
drop _merge


cd $data\temp_files\iv
merge m:1 gisjoin occ_group using sim_iv
keep if _merge==3
drop _merge

merge m:1 gisjoin using sim_iv_total
keep if _merge==3
drop _merge

cd $data\temp_files
merge m:1 gisjoin using skill_ratio_occupation
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

drop if count1990==.

g dimpute=ln(impute_share2010)-ln(impute_share1990)
egen tract_id=group(gisjoin)
egen metarea_occ=group(metarea occ2010)
drop year serial
drop  count2000 count2010

g dval=val_2010-val_1990

g dval_expected_commute=dval*expected_commute

g drent=ln(rent2010+1)-ln(rent1990+1)

ren count1990 count

cd $data\temp_files
merge m:1 occ2010 using high_skill_30
drop if _merge==2
drop _merge


cd $data\temp_files
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66


g high_skill_dratio=high_skill*dratio

g high_skill_dln_sim_high=high_skill* dln_sim_high

g high_skill_dln_sim_low=high_skill* dln_sim_low

g high_skill_dln_sim=high_skill*dln_sim

g dln_sim_density=dln_sim*room_density_1mi_3mi

g dln_sim_high_density=dln_sim_high*room_density_1mi_3mi

g dln_sim_low_density=dln_sim_low*room_density_1mi_3mi

g dln_sim_total_density=dln_sim_total*room_density_1mi_3mi

g dln_sim_high_total_density=dln_sim_high_total*room_density_1mi_3mi

g dln_sim_low_total_density=dln_sim_low_total*room_density_1mi_3mi


***
g high_skill_drent= high_skill*drent
g high_skill_dln_sim_density = high_skill*dln_sim_density
g high_skill_dln_sim_high_density= high_skill*dln_sim_high_density 
g high_skill_dln_sim_low_density =high_skill*dln_sim_low_density
g high_skill_room_density_1mi_3mi= high_skill*room_density_1mi_3mi
g high_skill_expected_commute=high_skill*expected_commute
g high_dval_expected_commute=high_skill*dval_expected_commute
*** construct rent equation variable
cd $data\temp_files
merge m:1 gisjoin using ddemand
keep if _merge==3
drop _merge

cd $temp_files
save data_30, replace

**** Regress 
cd $data\temp_files
u data_30, clear

 g ddemand_density=room_density_1mi_3mi*ddemand
 *** Main specification (Table 7)
 ** Column 7
  # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute dval_expected_commute high_dval_expected_commute (dratio high_skill_dratio drent high_skill_drent=  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi) [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr
 
 
 * Commute cost
 
* High-skilled
lincom dval_expected_commute+ high_dval_expected_commute
* Low-skilled
lincom dval_expected_commute

* Amenities

* High-skilled
lincom dratio + high_skill_dratio
* low-skilled
lincom dratio

* Rent

* High_skilled
lincom drent + high_skill_drent
* Low-skilled
lincom drent

 