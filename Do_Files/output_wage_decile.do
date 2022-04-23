clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\ipums_micro
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
*keep if year==1990 | year==2010


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
xtile wage_tile2000=wage_real [w=perwt] if year==2000, nq(10)
xtile wage_tile2010=wage_real [w=perwt] if year==2010, nq(10)
g wage_tile=wage_tile1990 if year==1990
replace wage_tile=wage_tile2000 if year==2000
replace wage_tile=wage_tile2010 if year==2010

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50


collapse greaterthan50 [w=perwt], by(year wage_tile)

cd $data\temp_files
save tile_1990_2010, replace

****
cd $data\ipums_micro
u 1980_1990, clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1980


drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999
ren inctot inctot_real

replace inctot_real=inctot_real/52

g wage_real=inctot_real/uhrswork

xtile wage_tile=wage_real [w=perwt], nq(10)


g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50

collapse greaterthan50 [w=perwt], by(year wage_tile)

cd $data\temp_files
append using tile_1990_2010

*keep if year==1980 | year==2010

sort wage_tile year

by wage_tile: g dg10=greaterthan50-greaterthan50[_n-1]
by wage_tile: g dg20=greaterthan50-greaterthan50[_n-2]
by wage_tile: g dg30=greaterthan50-greaterthan50[_n-3]

*** Main figure
   cd $data\graph\
 
 # delimit 
 graph twoway (bar dg30 wage_tile if year==2010, msymbol(O) ) 
 , graphregion(color(white)) xtitle(Wage decile) ytitle(Change in prob of working >=50 hrs/week)
 xscale(range(1 10)) xlabel(1(1)10) legend(lab(1 "1980") lab(2 "2010")) saving(dgreaterthan50_wage_tile, replace);
 # delimit cr
 
 graph export dgreaterthan50_wage_tile.emf, replace
 
** Appendix figure

    cd $data\graph\
 
 # delimit 
 graph twoway (bar dg20 wage_tile if year==2000, msymbol(O) ) 
 , graphregion(color(white)) xtitle(Wage decile) ytitle(Change in prob of working >=50 hrs/week)
 xscale(range(1 10)) xlabel(1(1)10);
 # delimit cr
 

 graph export dgreaterthan50_wage_tile1980_2000.emf, replace
 
 
     cd $data\graph\
 
 # delimit 
 graph twoway (bar dg10 wage_tile if year==2010, msymbol(O) ) 
 , graphregion(color(white)) xtitle(Wage decile) ytitle(Change in prob of working >=50 hrs/week)
 xscale(range(1 10)) xlabel(1(1)10) yscale(range(-0.2 0)) ylabel(-0.2(0.05)0);
 # delimit cr
 

 graph export dgreaterthan50_wage_tile2000_2010.emf, replace
 
 
 *****************************
 *** Commute
 
 
*** Generate change in commute time by group
** By wage decile
cd $data\ipums_micro
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

keep if age>=25 & age<=65
*keep if year==1990 | year==2010
keep if sex==1

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
xtile wage_tile2000=wage_real [w=perwt] if year==2000, nq(10)
xtile wage_tile2010=wage_real [w=perwt] if year==2010, nq(10)
g wage_tile=wage_tile1990 if year==1990
replace wage_tile=wage_tile2000 if year==2000
replace wage_tile=wage_tile2010 if year==2010

g ln_trantime=ln(trantime)
keep if tranwork<70 & tranwork>0 & trantime>0

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd $data\temp_files
collapse ln_trantime [w=perwt], by(year wage_tile)

save commute_tile_1990_2010, replace

****
cd $data\ipums_micro
u 1980_1990, clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1980


drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999
ren inctot inctot_real

replace inctot_real=inctot_real/52

g wage_real=inctot_real/uhrswork

xtile wage_tile=wage_real [w=perwt], nq(10)

g ln_trantime=ln(trantime)

keep if tranwork<70 & tranwork>0 & trantime>0

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25
collapse ln_trantime [w=perwt], by(year wage_tile)

cd $data\temp_files
append using commute_tile_1990_2010

sort wage_tile year
 
 by wage_tile: g dln_trantime_10 = ln_trantime-ln_trantime[_n-1]

 **Main Figure
 by wage_tile: g dln_trantime_30 = ln_trantime-ln_trantime[_n-3]
  # delimit 
 graph twoway (bar dln_trantime_30 wage_tile if year==2010, msymbol(O) ) 
 , graphregion(color(white)) xtitle(Wage decile) ytitle(Change in mean log commute time)
 xscale(range(1 10)) xlabel(1(1)10) yscale(range(0.00 0.15)) ylabel(0(0.04)0.16) saving(ln_trantime_rank25_1980_2010, replace);
 # delimit cr
 
 graph export ln_trantime_rank25_1980_2010.png, replace
 
 
 *** Appendix figures
   cd $data\graph\
 # delimit 
 graph twoway (bar dln_trantime_10 wage_tile if year==2010, msymbol(O) ) 
 , graphregion(color(white)) xtitle(Wage decile) ytitle(Change in mean log commute time)
 xscale(range(1 10)) xlabel(1(1)10) yscale(range(0.00 0.15)) ylabel(0(0.04)0.16) saving(ln_trantime_rank25_2000_2010, replace);
 # delimit cr
 graph export ln_trantime_rank25_2000_2010.png, replace


by wage_tile: g dln_trantime_20 = ln_trantime-ln_trantime[_n-2]
   cd $data\graph\
 # delimit 
 graph twoway (bar dln_trantime_20 wage_tile if year==2000, msymbol(O) ) 
 , graphregion(color(white)) xtitle(Wage decile) ytitle(Change in mean log commute time)
 xscale(range(1 10)) xlabel(1(1)10) yscale(range(0.00 0.15)) ylabel(0(0.04)0.16) saving(ln_trantime_rank25_1980_2000, replace);
 # delimit cr
  graph export ln_trantime_rank25_1980_2000.png, replace
 
 
 