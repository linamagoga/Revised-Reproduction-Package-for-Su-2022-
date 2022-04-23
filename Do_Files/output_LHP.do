clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"



*** Financial specialists
cd $data\ipums_micro

u 1990_2000_2010_temp if occ2010==120 | occ2010==800| occ2010==4820, clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<40
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

replace inctot_real=ln(inctot_real)
drop occ met2013 city puma rentgrs valueh bpl occsoc incwage puma1990 greaterthan40 datanum serial pernum rank ind ind2000 hhwt statefip marst inctot occ1990

g hours1990=.
g hours2010=.
replace hours1990=uhrswork if year==1990
replace hours2010=uhrswork if year==2010

reghdfe inctot_real [pw=perwt] , absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(inctot_real_res)
reghdfe hours1990 [pw=perwt] if year==1990, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours1990_res)
reghdfe hours2010  [pw=perwt] if year==2010, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours2010_res)

sum hours1990 [w=perwt]
replace hours1990_res=hours1990_res+r(mean)
sum hours2010 [w=perwt]
replace hours2010_res=hours2010_res+r(mean)
sum inctot_real [w=perwt]
replace inctot_real_res=inctot_real_res+r(mean)

sum inctot_real_res [w=perwt] if hours1990_res<=42 & hours1990_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==1990

sum inctot_real_res [w=perwt] if hours2010_res<=42 & hours2010_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==2010

cd $data\graph\
# delimit
graph twoway (lpoly inctot_real_res hours1990_res [w=perwt] if year==1990 & hours1990_res>=38 & hours1990_res<=60, lpattern(solid) bwidth(2.5)) 
(lpoly inctot_real_res hours2010_res [w=perwt] if year==2010 & hours2010_res>=38 & hours2010_res<=60, lpattern(dash) bwidth(2.5)), graphregion(color(white))
legend(lab(1 "1990") lab(2 "2010")) xtitle(Weekly hours worked) ytitle(Weekly real log earnings) xscale(range(40 60))  yscale(range(0 0.5)) ylabel(0(0.1)0.5) xlabel(40(5)60);
# delimit cr
graph export financial_log_earnings.emf, replace


***
**** lawyer
cd $data\ipums_micro

u 1990_2000_2010_temp if occ2010==2100, clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<40
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

replace inctot_real=ln(inctot_real)
drop occ met2013 city puma rentgrs valueh bpl occsoc incwage puma1990 greaterthan40 datanum serial pernum rank ind ind2000 hhwt statefip marst inctot occ1990

g hours1990=.
g hours2010=.
replace hours1990=uhrswork if year==1990
replace hours2010=uhrswork if year==2010

reghdfe inctot_real [pw=perwt] , absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(inctot_real_res)
reghdfe hours1990 [pw=perwt] if year==1990, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours1990_res)
reghdfe hours2010 [pw=perwt] if year==2010, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours2010_res)

sum hours1990
replace hours1990_res=hours1990_res+r(mean)
sum hours2010
replace hours2010_res=hours2010_res+r(mean)
sum inctot_real
replace inctot_real_res=inctot_real_res+r(mean)

sum inctot_real_res if hours1990_res<=42 & hours1990_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==1990

sum inctot_real_res if hours2010_res<=42 & hours2010_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==2010

cd $data\graph
# delimit
graph twoway (lpoly inctot_real_res hours1990_res [w=perwt] if year==1990 & hours1990_res>=38 & hours1990_res<=60, lpattern(solid) bwidth(2.5)) 
(lpoly inctot_real_res hours2010_res [w=perwt] if year==2010 & hours2010_res>=38 & hours2010_res<=60, lpattern(dash) bwidth(2.5)), graphregion(color(white))
legend(lab(1 "1990") lab(2 "2010")) xtitle(Weekly hours worked) ytitle(Weekly real log earnings) xscale(range(40 60)) yscale(range(0 0.5)) ylabel(0(0.1)0.5) xlabel(40(5)60);
# delimit cr
graph export lawyer_log_earnings.emf, replace

***
**** Office administrator
cd $data\ipums_micro

u 1990_2000_2010_temp if occ2010==5700, clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<40
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

replace inctot_real=ln(inctot_real)
drop occ met2013 city puma rentgrs valueh bpl occsoc incwage puma1990 greaterthan40 datanum serial pernum rank ind ind2000 hhwt statefip marst inctot occ1990

g hours1990=.
g hours2010=.
replace hours1990=uhrswork if year==1990
replace hours2010=uhrswork if year==2010

reghdfe inctot_real [pw=perwt], absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(inctot_real_res)
reghdfe hours1990 [pw=perwt] if year==1990, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours1990_res)
reghdfe hours2010 [pw=perwt]if year==2010, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours2010_res)

sum hours1990 [w=perwt]
replace hours1990_res=hours1990_res+r(mean)
sum hours2010 [w=perwt]
replace hours2010_res=hours2010_res+r(mean)
sum inctot_real [w=perwt]
replace inctot_real_res=inctot_real_res+r(mean)

sum inctot_real_res [w=perwt] if hours1990_res<=42 & hours1990_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==1990

sum inctot_real_res  [w=perwt] if hours2010_res<=42 & hours2010_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==2010

cd $data\graph
# delimit
graph twoway (lpoly inctot_real_res hours1990_res [w=perwt] if year==1990 & hours1990_res>=38 & hours1990_res<=60, lpattern(solid) bwidth(2.5)) 
(lpoly inctot_real_res hours2010_res [w=perwt] if year==2010 & hours2010_res>=38 & hours2010_res<=60, lpattern(dash) bwidth(2.5)), graphregion(color(white))
legend(lab(1 "1990") lab(2 "2010")) xtitle(Weekly hours worked) ytitle(Weekly real log earnings) xscale(range(40 60) ) yscale(range(0 0.5)) ylabel(0(0.1)0.5) xlabel(40(5)60);
# delimit cr
graph export office_log_earnings.emf, replace

**** Teacher
cd $data\ipums_micro

u 1990_2000_2010_temp if occ2010==2320 | occ2010==2310, clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<40
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

replace inctot_real=ln(inctot_real)
drop occ met2013 city puma rentgrs valueh bpl occsoc incwage puma1990 greaterthan40 datanum serial pernum rank ind ind2000 hhwt statefip marst inctot occ1990

g hours1990=.
g hours2010=.
replace hours1990=uhrswork if year==1990
replace hours2010=uhrswork if year==2010

reghdfe inctot_real [pw=perwt], absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(inctot_real_res)
reghdfe hours1990 [pw=perwt] if year==1990, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours1990_res)
reghdfe hours2010 [pw=perwt] if year==2010, absorb(i.occ2010 i.occ2010#i.age#i.year i.occ2010#i.sex#i.year i.occ2010#i.educ#i.year i.occ2010#i.race#i.year i.occ2010#i.hispan#i.year i.occ2010#i.ind1990#i.year) res(hours2010_res)

sum hours1990 [w=perwt]
replace hours1990_res=hours1990_res+r(mean)
sum hours2010 [w=perwt]
replace hours2010_res=hours2010_res+r(mean)
sum inctot_real [w=perwt]
replace inctot_real_res=inctot_real_res+r(mean)

sum inctot_real_res [w=perwt] if hours1990_res<=42 & hours1990_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==1990

sum inctot_real_res [w=perwt] if hours2010_res<=42 & hours2010_res>=38
replace inctot_real_res=inctot_real_res-r(mean) if year==2010

cd $data\graph
# delimit
graph twoway (lpoly inctot_real_res hours1990_res [w=perwt] if year==1990 & hours1990_res>=38 & hours1990_res<=60, lpattern(solid) bwidth(2.5)) 
(lpoly inctot_real_res hours2010_res [w=perwt] if year==2010 & hours2010_res>=38 & hours2010_res<=60, lpattern(dash) bwidth(2.5)), graphregion(color(white))
legend(lab(1 "1990") lab(2 "2010")) xtitle(Weekly hours worked) ytitle(Weekly real log earnings) xscale(range(40 60) ) yscale(range(0 0.5)) ylabel(0(0.1)0.5) xlabel(40(5)60);
# delimit cr
graph export teacher_log_earnings.emf, replace


******
