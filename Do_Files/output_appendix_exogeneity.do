clear all
global data="C:\Users\alen_\Dropbox\paper_folder\replication\data"

*** Regressing change in incidence of working long hours in the suburbs and central cities
cd $data\ipums_micro
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50


cd $data\geographic
merge m:1 statefip puma1990 using puma1990_downtown_5mi
g downtown=0
replace downtown=1 if _merge==3
drop _merge

merge m:1 statefip puma using puma_downtown_5mi
replace downtown=1 if _merge==3
drop _merge

collapse greaterthan50, by(year occ2010 downtown)
drop if year==.
reshape wide greaterthan50, i(occ2010 downtown) j(year)


g ln_d=ln( greaterthan502010)-ln( greaterthan501990)

drop greaterthan501990 greaterthan502010
reshape wide ln_d, i(occ2010) j(downtown)
reg ln_d1 ln_d0


cd $data\temp_files
merge 1:1 occ2010 using occ2010_count
drop _merge


******** Table A3
*** Regressing change in incidence of working long hour on changing LHP
cd $data\temp_files

merge 1:1 occ2010 using val_40_60_total_1990_2000_2010
drop _merge

g dval=val_2010-val_1990 

** Column 1
reg ln_d1 dval [w=count1990] if dval!=., r

** Column 2
reg ln_d0 dval [w=count1990] if dval!=., r

** Column 3
reg ln_d1 ln_d0 [w=count1990] if dval!=., r