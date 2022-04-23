clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


*** Plot the change in commute time by skill content

cd $data\ipums_micro
u 1990_2000_2010_temp , clear

cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010

drop wage distance tranwork pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50

replace trantime=ln(trantime)

keep if rank<=25

g college=0
replace college=1 if educ>=10


collapse greaterthan50 trantime, by(year college)
drop if year==.
reshape wide greaterthan50 trantime , i(college) j(year)


g ln_d=ln( greaterthan502010)-ln( greaterthan501990)

g dtrantime=trantime2010-trantime1990

drop greaterthan501990 greaterthan502010 trantime2010 trantime1990

label define college_lab 0 "No College" 1 "College"
label value college college_lab
 cd $data\graph\
  # delimit 
 graph bar dtrantime  , over(college)  graphregion(color(white))  ytitle(Change in mean log commute time);
 # delimit cr
 graph export dtrantime_college.png, replace


*** Plot the change in incidence of work long hours by skill content

cd $data\ipums_micro
u 1990_2000_2010_temp , clear

cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010

drop wage distance tranwork pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50

replace trantime=ln(trantime)


g college=0
replace college=1 if educ>=10


collapse greaterthan50 trantime, by(year college)
drop if year==.
reshape wide greaterthan50 trantime , i(college) j(year)


g ln_d=ln( greaterthan502010)-ln( greaterthan501990)

g dtrantime=trantime2010-trantime1990

drop greaterthan501990 greaterthan502010 trantime2010 trantime1990

label define college_lab 0 "No College" 1 "College"
label value college college_lab
 cd $data\graph
  # delimit 
 graph bar ln_d  , over(college)  graphregion(color(white))  ytitle(Change in prob of working >=50 hrs/week);
 # delimit cr
 graph export ln_d_college.png, replace
 

*** Wage decile and changing incidence of working long


*** Generate change in long hour incidence by group
** By wage decile
cd $data\ipums_micro
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010


*drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g wage_real=inctot_real/uhrswork

xtile wage_tile1990=wage_real [w=perwt] if year==1990, nq(10)
xtile wage_tile2010=wage_real [w=perwt] if year==2010, nq(10)
g wage_tile=wage_tile1990 if year==1990
replace wage_tile=wage_tile2010 if year==2010

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


collapse greaterthan50 [w=perwt], by(year wage_tile downtown)
cd $data\temp_files
save tile_1990_2010, replace

cd $data\temp_files
u tile_1990_2010, clear

keep if year==1990 | year==2010

sort wage_tile downtown year

by wage_tile downtown: g dg=greaterthan50-greaterthan50[_n-1]

by wage_tile downtown: g ln_dg=ln(greaterthan50)-ln(greaterthan50[_n-1])

 
   cd $data\graph
 
 # delimit 
 graph twoway (bar dg wage_tile if year==2010, msymbol(O) ) 
 if downtown==1, graphregion(color(white)) xtitle(Wage decile) ytitle(Change in prob of working >=50 hrs/week)
 xscale(range(1 10)) xlabel(1(1)10) legend(lab(1 "1980") lab(2 "2010")) ;
 # delimit cr
  graph export dgreaterthan50_wage_tile_downtown.emf, replace
 
  # delimit 
 graph twoway (bar dg wage_tile if year==2010, msymbol(O) ) 
 if downtown==0, graphregion(color(white)) xtitle(Wage decile) ytitle(Change in prob of working >=50 hrs/week)
 xscale(range(1 10)) xlabel(1(1)10) legend(lab(1 "1980") lab(2 "2010")) ;
 # delimit cr
 graph export dgreaterthan50_wage_tile_suburbs.emf, replace