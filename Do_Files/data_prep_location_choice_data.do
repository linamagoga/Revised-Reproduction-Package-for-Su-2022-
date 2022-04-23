clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

*** Generate crosswalk between occupation group and occupation
*** 1990's crosswalk between occupation group and 1990's occupation
cd $data\ipums_micro
u 1990_2000_2010_temp if year==1990, clear

*** generate occupation groups that link occ1990 to the nhgis 1990 version occupation group
cd $data\temp_files

g occ1990_group=1 if occ1990>=0 & occ1990<=42
replace occ1990_group=2 if occ1990>=43 & occ1990<=202
replace occ1990_group=3 if occ1990>=203 & occ1990<=242
replace occ1990_group=4 if occ1990>=243 & occ1990<=302
replace occ1990_group=5 if occ1990>=303 & occ1990<=402
replace occ1990_group=6 if occ1990>=403 & occ1990<=412
replace occ1990_group=7 if occ1990>=413 & occ1990<=432
replace occ1990_group=8 if occ1990>=433 & occ1990<=472
replace occ1990_group=9 if occ1990>=473 & occ1990<=502
replace occ1990_group=10 if occ1990>=503 & occ1990<=702
replace occ1990_group=11 if occ1990>=703 & occ1990<=802
replace occ1990_group=12 if occ1990>=803 & occ1990<=863
replace occ1990_group=13 if occ1990>=864 & occ1990<=902
replace occ1990_group=14 if occ1990==999

cd $data\temp_files
save temp, replace
**
cd $data\temp_files
u temp, clear
collapse (count) count=serial, by(statefip puma1990 occ2010 occ1990_group)
drop if occ2010==9920
drop if occ1990_group==.
save temp1, replace

collapse (sum) count_occ=count, by(statefip puma1990 occ1990_group)
merge 1:m statefip puma1990 occ1990_group using temp1
drop _merge

g occ_group_share=count/ count_occ
keep statefip puma1990 occ2010 occ1990_group occ_group_share

cd $data\temp_files
save occ_group_share1990, replace


*** generate occ2010- occ1990_group crosswalk (dropping the uncommon linkage) (make sure for each occ2010, I can map it into a unique occ1990_group)
cd $data\temp_files
u temp, clear
g a=1
collapse (count) count=a, by(occ2010 occ1990_group)
sort occ2010 count
by occ2010: g max=_N
by occ2010: g rank=_n
keep if max==rank
keep occ2010 occ1990_group
sort occ2010 occ1990_group
save occ_occ_group1990, replace


***************************
***************************
**2000

cd $data\ipums_micro
u 1990_2000_2010_temp if year==2000, clear

*** generate occupation groups that link occ1990 to the nhgis 1990 version occupation group


*** generate occupation group
*** management
g occ2000_group=1 if occ>=1 & occ<=95
** professional
replace occ2000_group=2 if occ>=100 & occ<=354
*** health care
replace occ2000_group=3 if occ>=360 & occ<=365
** protective
replace occ2000_group=4 if occ>=370 & occ<=395
** Food preparation
replace occ2000_group=5 if occ>=400 & occ<=413
*** Building clean and maintenance
replace occ2000_group=6 if occ>=420 & occ<=425
** Personal care
replace occ2000_group=7 if occ>=430 & occ<=465
** sales
replace occ2000_group=8 if occ>=470 & occ<=496
** Office and administrative
replace occ2000_group=9 if occ>=500 & occ<=593
** Farming 
replace occ2000_group=10 if occ>=600 & occ<=605
** fishing
replace occ2000_group=11 if occ>=610 & occ<=613
** Construction and extraction
replace occ2000_group=12 if occ>=620 & occ<=694
** Installation
replace occ2000_group=13 if occ>=700 & occ<=762
** Production 
replace occ2000_group=14 if occ>=770 & occ<=896
** Transportation
replace occ2000_group=15 if occ>=900 & occ<=975

cd $data\temp_files
save temp, replace
**
cd $data\temp_files
u temp, clear
collapse (count) count=serial, by(statefip puma occ2010 occ2000_group)
drop if occ2010==9920
drop if occ2000_group==.
save temp1, replace

collapse (sum) count_occ=count, by(statefip puma occ2000_group)
merge 1:m statefip puma occ2000_group using temp1
drop _merge

g occ_group_share=count/ count_occ
keep statefip puma occ2010 occ2000_group occ_group_share

cd $data\temp_files
save occ_group_share2000, replace



*** generate occ2010- occ2000_group crosswalk (dropping the uncommon linkage)
cd $data\temp_files
u temp, clear
g a=1
collapse (count) count=a, by(occ2010 occ2000_group)
sort occ2010 count
by occ2010: g max=_N
by occ2010: g rank=_n
keep if max==rank
keep occ2010 occ2000_group
sort occ2010 occ2000_group
save occ_occ_group2000, replace


******************************
******************************
** 2010
cd $data\ipums_micro

u 1990_2000_2010_temp if year==2010, clear

g occ2010_group=5 if occ2010>=10 & occ2010<=430 & year==2010
** Business and financial
replace occ2010_group=6 if occ2010>=500 & occ2010<=950 & year==2010
*** Computer and mathematical
replace occ2010_group=8 if occ2010>=1000 & occ2010<=1240 & year==2010
** Architecture and engineering
replace occ2010_group=9 if occ2010>=1300 & occ2010<=1560 & year==2010
** Life, physical, and social science
replace occ2010_group=10 if occ2010>=1600 & occ2010<=1980 & year==2010
*** Community and social service
replace occ2010_group=12 if occ2010>=2000 & occ2010<=2060 & year==2010
** legal
replace occ2010_group=13 if occ2010>=2100 & occ2010<=2150 & year==2010
** Education, training, and library
replace occ2010_group=14 if occ2010>=2200 & occ2010<=2550 & year==2010
**Arts, design, entertainment, sports, and media 
replace occ2010_group=15 if occ2010>=2600 & occ2010<=2920 & year==2010
**Health diagnosing and treating practitioners and other technical 
replace occ2010_group=16 if occ2010>=3000 & occ2010<=3540 & year==2010
** Health technologists and technicians
replace occ2010_group=20 if occ2010>=3600 & occ2010<=3650 & year==2010
** Fire fighting and prevention, and other protective service 
replace occ2010_group=21 if occ2010>=3700 & occ2010<=3950 & year==2010
** Food preparation and serving related
replace occ2010_group=24 if occ2010>=4000 & occ2010<=4150 & year==2010
** Building and grounds cleaning and maintenance 
replace occ2010_group=25 if occ2010>=4200 & occ2010<=4250 & year==2010
** Personal care and service
replace occ2010_group=26 if occ2010>=4300 & occ2010<=4650 & year==2010
** Sales and related
replace occ2010_group=28 if occ2010>=4700 & occ2010<=4965 & year==2010
** Office and administrative support
replace occ2010_group=29 if occ2010>=5000 & occ2010<=5940 & year==2010
** Farming, fishing and forestry
replace occ2010_group=31 if occ2010>=6005 & occ2010<=6130 & year==2010
** Construction and extraction 
replace occ2010_group=32 if occ2010>=6200 & occ2010<=6940 & year==2010
** Installation, maintenance, and repair 
replace occ2010_group=33 if occ2010>=7000 & occ2010<=7630 & year==2010
** Production occupations
replace occ2010_group=35 if occ2010>=7700 & occ2010<=8965 & year==2010
** Transportation occupations
replace occ2010_group=36 if occ2010>=9000 & occ2010<=9420 & year==2010
** Material moving occupations
replace occ2010_group=37 if occ2010>=9510 & occ2010<=9750 & year==2010
** unemployed
replace occ2010_group=38 if occ2010==9920 & year==2010

cd $data\temp_files
save temp, replace
**

cd $data\temp_files
u temp, clear
collapse (count) count=serial, by(statefip puma occ2010 occ2010_group)
drop if occ2010==9920
drop if occ2010_group==.
save temp1, replace

collapse (sum) count_occ=count, by(statefip puma occ2010_group)
merge 1:m statefip puma occ2010_group using temp1
drop _merge

g occ_group_share=count/ count_occ
keep statefip puma occ2010 occ2010_group occ_group_share

cd $data\temp_files
save occ_group_share2010, replace

*** generate occ2010- occ1990_group crosswalk (dropping the uncommon linkage)
cd $data\temp_files
u temp, clear
g a=1
collapse (count) count=a, by(occ2010 occ2010_group)
sort occ2010 count
by occ2010: g max=_N
by occ2010: g rank=_n
keep if max==rank
keep occ2010 occ2010_group
sort occ2010 occ2010_group
save occ_occ_group2010, replace


************************************************************************
************************************************************************
**** Construct location choice
*****
**1990
cd $data\nhgis\occupation
import delimited nhgis0013_ds123_1990_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
cd $data\geographic
merge 1:1 gisjoin using puma1990_tract1990
keep if _merge==3
drop _merge
drop anrca county year res_onlya trusta aianhha res_trsta blck_grpa tracta cda c_citya countya cty_suba divisiona msa_cmsaa placea pmsaa regiona state statea urbrurala urb_areaa zipa cd103a anpsadpi

foreach num of numlist 1(1)9 {
g occ1990_group`num'=e4q00`num'
}
foreach num of numlist 10(1)13 {
g occ1990_group`num'=e4q0`num'
}

drop e4p* e4q*

sort gisjoin

cd $data\temp_files
save occ_tract1990, replace

*** employment number by census tract

cd $data\temp_files
u occ_tract1990, clear
ren puma puma1990
keep gisjoin statefip puma1990 occ1990*


reshape long occ1990_group, i(gisjoin statefip puma1990) j(group)
ren occ1990_group number_occ1990
ren group occ1990_group

collapse (sum) number_tract=number_occ1990, by(gisjoin statefip puma1990)
save number_tract1990, replace

*** merge
cd $data\temp_files
u occ_tract1990, clear

ren puma puma1990
keep gisjoin statefip puma1990 occ1990*


reshape long occ1990_group, i(gisjoin statefip puma1990) j(group)
ren occ1990_group number_occ1990
ren group occ1990_group

cd $data\temp_files
joinby statefip puma1990 occ1990_group using occ_group_share1990

g impute=number_occ1990*occ_group_share

collapse (sum) impute, by(gisjoin statefip puma1990 occ2010)


keep gisjoin statefip puma1990 occ2010 impute
merge m:1 occ2010 using occ_occ_group1990
keep if _merge==3
drop _merge


fillin gisjoin occ2010

replace impute=0 if impute==.
drop _fillin
drop statefip puma1990 occ1990_group
replace impute=round(impute)
save tract_impute1990, replace


*** 2000

*********************
***2000

cd $data\nhgis\occupation

import delimited nhgis0014_ds153_2000_tract.csv, clear 

drop year regiona divisiona state statea county countya cty_suba placea tracta trbl_cta blck_grpa trbl_bga c_citya res_onlya trusta aianhha trbl_suba anrca msa_cmsaa pmsaa necmaa urb_areaa cd106a cd108a cd109a zip3a zctaa name
sort gisjoin

cd $data\geographic
merge 1:m gisjoin using tract1990_tract2000

keep if _merge==3
drop _merge


foreach num of numlist 1(1)9 {
replace h0400`num'=h0400`num'*percentage
}

foreach num of numlist 10(1)30 {
replace h040`num'=h040`num'*percentage
}


drop gisjoin
ren gisjoin_1 gisjoin
collapse (sum) h04001 h04002 h04003 h04004 h04005 h04006 h04007 h04008 h04009 h04010 h04011 h04012 h04013 h04014 h04015 h04016 h04017 h04018 h04019 h04020 h04021 h04022 h04023 h04024 h04025 h04026 h04027 h04028 h04029 h04030 , by(gisjoin)

g occ2000_group1=h04001 + h04016
g occ2000_group2=h04002 + h04017
g occ2000_group3=h04003 + h04018
g occ2000_group4=h04004 + h04019
g occ2000_group5=h04005 + h04020
g occ2000_group6=h04006 + h04021
g occ2000_group7=h04007 + h04022
g occ2000_group8=h04008 + h04023
g occ2000_group9=h04009 + h04024
g occ2000_group10=h04010 + h04025
g occ2000_group11=h04011 + h04026
g occ2000_group12=h04012 + h04027
g occ2000_group13=h04013 + h04028
g occ2000_group14=h04014 + h04029
g occ2000_group15=h04015 + h04030

foreach num of numlist 1(1)15 {
replace occ2000_group`num'=round(occ2000_group`num')
}


drop h04* 

sort gisjoin

cd $data\geographic
merge 1:1 gisjoin using puma_tract1990
keep if _merge==3
drop _merge

cd $data\temp_files
save occ_tract2000, replace

*** employment number by census tract

u occ_tract2000, clear
keep gisjoin statefip puma occ2000*


reshape long occ2000_group, i(gisjoin statefip puma) j(group)
ren occ2000_group number_occ2000
ren group occ2000_group

collapse (sum) number_tract=number_occ2000, by(gisjoin statefip puma)
save number_tract2000, replace

*** merge
u occ_tract2000, clear

keep gisjoin statefip puma occ2000*


reshape long occ2000_group, i(gisjoin statefip puma) j(group)
ren occ2000_group number_occ2000
ren group occ2000_group

cd $data\temp_files
joinby statefip puma occ2000_group using occ_group_share2000

g impute=number_occ2000*occ_group_share

collapse (sum) impute, by(gisjoin statefip puma occ2010)


keep gisjoin statefip puma occ2010 impute

merge m:1 occ2010 using occ_occ_group2000
keep if _merge==3
drop _merge

replace impute=round(impute)
keep gisjoin occ2010 impute 

fillin gisjoin occ2010

replace impute=0 if impute==.
drop _fillin
save tract_impute2000, replace

***************************

*********************
***2010

cd $data\nhgis\occupation

import delimited nhgis0013_ds184_20115_2011_tract.csv, clear 

drop year regiona divisiona state statea county countya name_m cousuba placea tracta blkgrpa concita aianhha res_onlya trusta aitscea anrca cbsaa csaa metdiva nectaa cnectaa nectadiva uaa cdcurra sldua sldla zcta5a submcda sdelma sdseca sdunia puma5a bttra btbga name_e

cd $data\geographic
merge 1:m gisjoin using tract1990_tract2010
keep if _merge==3
drop _merge

foreach num of numlist 1(1)9 {
replace mspe00`num'=mspe00`num'*percentage
}

foreach num of numlist 10(1)73 {
replace mspe0`num'=mspe0`num'*percentage
}


foreach num of numlist 1(1)9 {
replace ms0e00`num'=ms0e00`num'*percentage
}

foreach num of numlist 10(1)55 {
replace ms0e0`num'=ms0e0`num'*percentage
}

drop gisjoin
ren gisjoin_1 gisjoin

collapse (sum) mspe001 mspe002 mspe003 mspe004 mspe005 mspe006 mspe007 mspe008 mspe009 mspe010 mspe011 mspe012 mspe013 mspe014 mspe015 mspe016 mspe017 mspe018 mspe019 mspe020 mspe021 mspe022 mspe023 mspe024 mspe025 mspe026 mspe027 mspe028 mspe029 mspe030 mspe031 mspe032 mspe033 mspe034 mspe035 mspe036 mspe037 mspe038 mspe039 mspe040 mspe041 mspe042 mspe043 mspe044 mspe045 mspe046 mspe047 mspe048 mspe049 mspe050 mspe051 mspe052 mspe053 mspe054 mspe055 mspe056 mspe057 mspe058 mspe059 mspe060 mspe061 mspe062 mspe063 mspe064 mspe065 mspe066 mspe067 mspe068 mspe069 mspe070 mspe071 mspe072 mspe073 , by(gisjoin)


g occ2010_group1=mspe001
g occ2010_group2=mspe002+mspe038
g occ2010_group3=mspe003+mspe039
g occ2010_group4=mspe004+mspe040
g occ2010_group5=mspe005+mspe041
g occ2010_group6=mspe006+mspe042
g occ2010_group7=mspe007+mspe043
g occ2010_group8=mspe008+mspe044
g occ2010_group9=mspe009+mspe045
g occ2010_group10=mspe010+mspe046
g occ2010_group11=mspe011+mspe047
g occ2010_group12=mspe012+mspe048
g occ2010_group13=mspe013+mspe049
g occ2010_group14=mspe014+mspe050
g occ2010_group15=mspe015+mspe051
g occ2010_group16=mspe016+mspe052
g occ2010_group17=mspe017+mspe053
g occ2010_group18=mspe018+mspe054
g occ2010_group19=mspe019+mspe055
g occ2010_group20=mspe020+mspe056
g occ2010_group21=mspe021+mspe057
g occ2010_group22=mspe022+mspe058
g occ2010_group23=mspe023+mspe059
g occ2010_group24=mspe024+mspe060
g occ2010_group25=mspe025+mspe061
g occ2010_group26=mspe026+mspe062
g occ2010_group27=mspe027+mspe063
g occ2010_group28=mspe028+mspe064
g occ2010_group29=mspe029+mspe065
g occ2010_group30=mspe030+mspe066
g occ2010_group31=mspe031+mspe067
g occ2010_group32=mspe032+mspe068
g occ2010_group33=mspe033+mspe069
g occ2010_group34=mspe034+mspe070
g occ2010_group35=mspe035+mspe071
g occ2010_group36=mspe036+mspe072
g occ2010_group37=mspe037+mspe073


drop mspe*
drop occ2010_group1 occ2010_group2

foreach num of numlist 3(1)37 {
replace occ2010_group`num'=round(occ2010_group`num')
}

sort gisjoin

cd $data\geographic
merge 1:1 gisjoin using puma_tract1990
keep if _merge==3
drop _merge

cd $data\temp_files
save occ_tract2010, replace

*** employment number by census tract
cd $data\temp_files
u occ_tract2010, clear
keep gisjoin statefip puma occ2010*


reshape long occ2010_group, i(gisjoin statefip puma) j(group)
ren occ2010_group number_occ2010
ren group occ2010_group

collapse (sum) number_tract=number_occ2010, by(gisjoin statefip puma)
cd $data\temp_files
save number_tract2010, replace

*** merge
cd $data\temp_files
u occ_tract2010, clear

keep gisjoin statefip puma occ2010*


reshape long occ2010_group, i(gisjoin statefip puma) j(group)
ren occ2010_group number_occ2010
ren group occ2010_group

joinby statefip puma occ2010_group using occ_group_share2010

g impute=number_occ2010*occ_group_share

collapse (sum) impute, by(gisjoin statefip puma occ2010)


keep gisjoin statefip puma occ2010 impute
merge m:1 occ2010 using occ_occ_group2010
keep if _merge==3
drop _merge

replace impute=round(impute)
keep gisjoin occ2010 impute 
sort gisjoin occ2010

fillin gisjoin occ2010

replace impute=0 if impute==.
drop _fillin
cd $data\temp_files
save tract_impute2010, replace




**** Combining all the data

u tract_impute1990, clear

ren impute impute1990

merge 1:1 occ2010 gisjoin using tract_impute2000
drop _merge

ren impute impute2000

merge 1:1 occ2010 gisjoin using tract_impute2010
drop _merge

ren impute impute2010

replace impute1990=0 if impute1990==.
replace impute2000=0 if impute2000==.
replace impute2010=0 if impute2010==.

*** Make sure the observations are consistent across three periods
cd $data\temp_files
merge m:1 occ2010 using occ2010_count
keep if _merge==3
drop _merge
drop count*
cd $data\geographic
merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

*** Add one to all census tract to smooth over zero observations. 
cd $data\temp_files
replace impute1990=impute1990+1
replace impute2000=impute2000+1
replace impute2010=impute2010+1
save tract_impute, replace


cd $data\temp_files
u tract_impute, clear
collapse (sum) impute_total1990=impute1990 impute_total2000=impute2000 impute_total2010=impute2010, by(occ2010 metarea)

merge 1:m occ2010 metarea using tract_impute
drop _merge

g impute_share1990=impute1990/impute_total1990
g impute_share2000=impute2000/impute_total2000
g impute_share2010=impute2010/impute_total2010
keep occ2010 metarea gisjoin impute_share1990 impute_share2000 impute_share2010
save tract_impute_share, replace