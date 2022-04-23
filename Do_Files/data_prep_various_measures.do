clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

*** Income measure for housing demand measure


cd $data\ipums_micro
u 1990_2000_2010_temp , clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

g wage_real=inctot_real/(52*40)

g inc_mean1990=inctot_real if year==1990
g inc_mean2000=inctot_real if year==2000
g inc_mean2010=inctot_real if year==2010

g wage_real1990=wage_real if year==1990
g wage_real2000=wage_real if year==2000
g wage_real2010=wage_real if year==2010

bysort occ2010 year: egen count=count(perwt) 

g count1990=count if year==1990
g count2000=count if year==2000
g count2010=count if year==2010

collapse (mean) count1990 count2000 count2010 inc_mean1990 inc_mean2000 inc_mean2010 wage_real1990 wage_real2000 wage_real2010  [w=perwt], by(occ2010)
cd $data\temp_files
save inc_occ_1990_2000_2010, replace


*** Occupation METAREA count


cd $data\ipums_micro
u 1990_2000_2010_temp , clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<30
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

bysort metarea occ2010 year: egen count=total(perwt) 

g count1990=count if year==1990
g count2000=count if year==2000
g count2010=count if year==2010

collapse (mean) count1990 count2000 count2010 [w=perwt], by(metarea occ2010)

cd $data\temp_files

save count_metarea, replace
******************************

cd $data\ipums_micro
u 1990_2000_2010_temp , clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<30
keep if age>=25 & age<=65
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999


g count1990=perwt if year==1990
g count2000=perwt if year==2000
g count2010=perwt if year==2010

collapse (count) count1990 count2010, by(occ2010)

replace count1990=. if count1990==0
replace count2010=. if count2010==0

cd $data\temp_files

save occ2010_count, replace


****************************
cd $data\ipums_micro
u 1990_2000_2010_temp , clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

keep if sex==1
drop if uhrswork<30
keep if age>=25 & age<=65
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999


g count1990=perwt if year==1990
g count2000=perwt if year==2000
g count2010=perwt if year==2010

collapse (count) count1990 count2010, by(occ2010)

replace count1990=. if count1990==0
replace count2010=. if count2010==0

cd $data\temp_files

save occ2010_count_male, replace

*******************
*** Welfare calculate earnings level


*** compute log wage for every state
cd $data\ipums_micro
u 1990_2000_2010_temp, clear

keep if uhrswork>=30

keep if year==1990 | year==2010

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52
replace inctot_real=ln(inctot_real)

collapse inctot_real (count) count=inctot_real, by(occ2010 year)

reshape wide inctot_real count, i(occ2010) j(year)

drop if inctot_real1990==.
drop if inctot_real2010==.
drop count*

cd $data\temp_files
save val_time_weekly_earnings_total, replace

