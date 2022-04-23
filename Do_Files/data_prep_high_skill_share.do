clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

cd $data\ipums_micro

u 1990_2000_2010_temp, clear

keep if year==1990
keep if uhrswork>=30
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g college=0
replace college=1 if educ>=10 & educ<.

collapse college, by(occ2010)

ren college college_share
g high_skill=0
replace high_skill=1 if college_share>=0.4
cd $data\temp_files

save high_skill, replace

***
cd $data\ipums_micro

u 1990_2000_2010_temp, clear

keep if year==1990
keep if uhrswork>=30
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g college=0
replace college=1 if educ>=10 & educ<.

collapse college, by(occ2010)

ren college college_share
g high_skill=0
replace high_skill=1 if college_share>=0.3
cd $data\temp_files

save high_skill_30, replace

cd $data\ipums_micro

u 1990_2000_2010_temp, clear

keep if year==1990
keep if uhrswork>=30
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g college=0
replace college=1 if educ>=10 & educ<.

collapse college, by(occ2010)

ren college college_share
g high_skill=0
replace high_skill=1 if college_share>=0.5
cd $data\temp_files

save high_skill_50, replace

