clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


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
collapse greaterthan50, by(year occ2010)

reshape wide greaterthan50, i(occ2010) j(year)

g ln_d=ln( greaterthan502010)-ln( greaterthan501990)

cd $data\temp_files

merge 1:1 occ2010 using inc_occ_1990_2000_2010
drop _merge

drop inc_mean1990 inc_mean2000 inc_mean2010 wage_real1990 wage_real2000 wage_real2010

cd $data\temp_files

merge 1:1 occ2010 using val_40_60_total_1990_2000_2010
drop _merge

g dval=val_2010-val_1990


cd $data\temp_files

save reduced_form, replace
*****
*** Regress change in long hours on long hour premium 
cd $data\temp_files
u reduced_form, clear
** Table 3
* Column 1
reg ln_d dval [w=count1990] if dval!=., r


**** Change in central city share on change in long hours

cd $data\temp_files
 u tract_impute.dta, clear
 cd $data\geographic
 merge m:1 gisjoin using tract1990_downtown5mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge

cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

drop serial year

collapse (sum) impute1990 impute2000 impute2010, by(occ2010 metarea rank downtown)
by occ2010 metarea: g ratio1990=impute1990/(impute1990+impute1990[_n-1])
by occ2010 metarea: g ratio2000=impute2000/(impute2000+impute2000[_n-1])
by occ2010 metarea: g ratio2010=impute2010/(impute2010+impute2010[_n-1])

keep occ2010 metarea downtown ratio1990 ratio2000 ratio2010 rank

g dratio=ln(ratio2010)-ln(ratio1990)

cd $data\temp_files
merge m:1 occ2010 using reduced_form
keep if _merge==3
drop _merge

drop count*
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

* Table 2
* Column 1 - 3 
reg dratio i.metarea ln_d [ w=count1990] if dval!=. & rank<=10 & downtown==1, cluster(metarea)
reg dratio i.metarea ln_d [ w=count1990] if dval!=. & rank<=25 & downtown==1, cluster(metarea)
reg dratio i.metarea ln_d [ w=count1990] if dval!=. & downtown==1, cluster(metarea)

** Table 3
* Column 2-4
reg dratio i.metarea dval [ w=count1990] if dval!=. & downtown==1 & rank<=10, cluster(metarea)
reg dratio i.metarea dval [ w=count1990] if dval!=. & downtown==1 & rank<=25, cluster(metarea)
reg dratio i.metarea dval [ w=count1990] if dval!=. & downtown==1, cluster(metarea)


**** Commute time on change in long hours

cd $data\ipums_micro
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

*keep if rank<=25
keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010

replace trantime=ln(trantime)
collapse trantime, by(year occ2010 metarea rank)

reshape wide trantime, i(occ2010 metarea) j(year)

g dtran= trantime2010-trantime1990

cd $data\temp_files
merge m:1 occ2010 using reduced_form
drop _merge

drop count*
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

* Table 2
* Column 4-6 
reg dtran i.metarea ln_d [w=count1990] if dval!=. & rank<=10, cluster(metarea)
reg dtran i.metarea ln_d [w=count1990] if dval!=. & rank<=25, cluster(metarea)
reg dtran i.metarea ln_d [w=count1990] if dval!=., cluster(metarea)

* Table 3
* Column 5-7 
reg dtran i.metarea dval [w=count1990] if dval!=. & rank<=10, cluster(metarea)
reg dtran i.metarea dval [w=count1990] if dval!=. & rank<=25, cluster(metarea)
reg dtran i.metarea dval [w=count1990] if dval!=., cluster(metarea)